WARN('['..string.gsub(debug.getinfo(1).source, ".*\\(.*.lua)", "%1")..', line:'..debug.getinfo(1).currentline..'] * SCTAAI: offset attackutil.lua' )

function TAPlatoonAttackVector(aiBrain, platoon, bAggro)
    --Engine handles whether or not we can occupy our vector now, so this should always be a valid, occupiable spot.
    local attackPos = GetBestThreatTarget(aiBrain, platoon)
    local bNeedTransports = false
    if not attackPos then
        attackPos = GetBestThreatTarget(aiBrain, platoon, true)
        bNeedTransports = true
        if not attackPos then
            platoon:StopAttack()
            return {}
        end
    end
    GetMostRestrictiveLayer(platoon)
    local oldPathSize = table.getn(platoon.LastAttackDestination)
    if oldPathSize == 0 or attackPos[1] != platoon.LastAttackDestination[oldPathSize][1] or
    attackPos[3] != platoon.LastAttackDestination[oldPathSize][3] then

        GetMostRestrictiveLayer(platoon)
        local path, reason = PlatoonGenerateSafePathToSCTAAI(aiBrain, platoon.MovementLayer, platoon:GetPlatoonPosition(), attackPos, platoon.PlatoonData.NodeWeight or 10)
        platoon:Stop()

        local usedTransports = false
        local position = platoon:GetPlatoonPosition()
        if (not path and reason == 'NoPath') or bNeedTransports then
            usedTransports = SendPlatoonWithTransportsNoCheck(aiBrain, platoon, attackPos, true)
        elseif VDist2Sq(position[1], position[3], attackPos[1], attackPos[3]) > 512*512 then
            usedTransports = SendPlatoonWithTransportsNoCheck(aiBrain, platoon, attackPos, true)
        elseif VDist2Sq(position[1], position[3], attackPos[1], attackPos[3]) > 256*256 then
            usedTransports = SendPlatoonWithTransportsNoCheck(aiBrain, platoon, attackPos, false)
        end

        if not usedTransports then
            if not path then
                if reason == 'NoStartNode' or reason == 'NoEndNode' then
                    --Couldn't find a valid pathing node. Just use shortest path.
                    platoon:AggressiveMoveToLocation(attackPos)
                end
                # force reevaluation
                platoon.LastAttackDestination = {attackPos}
            else
                local pathSize = table.getn(path)
                platoon.LastAttackDestination = path
                # move to new location
                for wpidx,waypointPath in path do
                    if wpidx == pathSize or bAggro then
                        platoon:AggressiveMoveToLocation(waypointPath)
                    else
                        platoon:MoveToLocation(waypointPath, false)
                    end
                end
            end
        end
    end

    local cmd = {}
    for k,v in platoon:GetPlatoonUnits() do
        if not v.Dead then
            local unitCmdQ = v:GetCommandQueue()
            for cmdIdx,cmdVal in unitCmdQ do
                table.insert(cmd, cmdVal)
                break
            end
        end
    end
    return cmd
end



function PlatoonGenerateSafePathToSCTAAI(aiBrain, platoonLayer, start, destination, optThreatWeight, optMaxMarkerDist, testPathDist)
    -- if we don't have markers for the platoonLayer, then we can't build a path.
    if not GetPathGraphs()[platoonLayer] then
        return false, 'NoGraph'
    end
    local location = start
    optMaxMarkerDist = optMaxMarkerDist or 250
    optThreatWeight = optThreatWeight or 1
    local finalPath = {}

    --If we are within 100 units of the destination, don't bother pathing. (Sorian and Duncan AI)
    if VDist2(start[1], start[3], destination[1], destination[3]) <= 100 then
        table.insert(finalPath, destination)
        return finalPath
    end

    --Get the closest path node at the platoon's position
    local startNode
    startNode = GetClosestPathNodeInRadiusByLayer(location, optMaxMarkerDist, platoonLayer)
    if not startNode then return false, 'NoStartNode' end

    --Get the matching path node at the destiantion
    local endNode
    endNode = GetClosestPathNodeInRadiusByGraph(destination, optMaxMarkerDist, startNode.graphName)
    if not endNode then return false, 'NoEndNode' end

    --Generate the safest path between the start and destination
    local path

        -- The original AI is using the vanilla version of GeneratePath. No cache, ugly (AStarLoopBody) code, but reacts faster on new situations.
    path = GeneratePathTA(aiBrain, startNode, endNode, ThreatTable[platoonLayer], optThreatWeight, destination, location)
    if not path then return false, 'NoPath' end

    -- Insert the path nodes (minus the start node and end nodes, which are close enough to our start and destination) into our command queue.
    for i,node in path.path do
        if i > 1 and i < table.getn(path.path) then
            table.insert(finalPath, node.position)
        end
    end

    table.insert(finalPath, destination)

    return finalPath
end

function GeneratePathTA(aiBrain, startNode, endNode, threatType, threatWeight, destination, location)
    if not aiBrain.PathCache then
        aiBrain.PathCache = {}
    end
    -- create a new path
    aiBrain.PathCache[startNode.name] = aiBrain.PathCache[startNode.name] or {}
    aiBrain.PathCache[startNode.name][endNode.name] = aiBrain.PathCache[startNode.name][endNode.name] or {}
    aiBrain.PathCache[startNode.name][endNode.name].settime = aiBrain.PathCache[startNode.name][endNode.name].settime or GetGameTimeSeconds()

    if aiBrain.PathCache[startNode.name][endNode.name].path and aiBrain.PathCache[startNode.name][endNode.name].path != 'bad'
    and aiBrain.PathCache[startNode.name][endNode.name].settime + 60 > GetGameTimeSeconds() then
        return aiBrain.PathCache[startNode.name][endNode.name].path
    end

    -- Uveso - Clean path cache. Loop over all paths's and remove old ones
    if aiBrain.PathCache then
        local GameTime = GetGameTimeSeconds()
        for StartNode, EndNodeCache in aiBrain.PathCache do
            for EndNode, Path in EndNodeCache do
                if Path.settime and Path.settime + 60 < GameTime then
                    aiBrain.PathCache[StartNode][EndNode] = nil
                end
            end
        end
    end

    threatWeight = threatWeight or 1

    local graph = GetPathGraphs()[startNode.layer][startNode.graphName]

    local closed = {}

    local queue = {
            path = {startNode, },
    }

    if VDist2Sq(location[1], location[3], startNode.position[1], startNode.position[3]) > 10000 and
    SUtils.DestinationBetweenPoints(destination, location, startNode.position) then
        local newPath = {
                path = {newNode = {position = destination}, },
        }
        return newPath
    end

    local lastNode = startNode

    repeat
        if closed[lastNode] then
            --aiBrain.PathCache[startNode.name][endNode.name] = { settime = 36000 , path = 'bad' }
            return false
        end

        closed[lastNode] = true

        local mapSizeX = ScenarioInfo.size[1]
        local mapSizeZ = ScenarioInfo.size[2]

        local lowCost = false
        local bestNode = false

        for i, adjacentNode in lastNode.adjacent do

            local newNode = graph[adjacentNode]

            if not newNode or closed[newNode] then
                continue
            end

            if SUtils.DestinationBetweenPoints(destination, lastNode.position, newNode.position) then
                aiBrain.PathCache[startNode.name][endNode.name] = { settime = GetGameTimeSeconds(), path = queue }
                return queue
            end

            local dist = VDist2Sq(newNode.position[1], newNode.position[3], endNode.position[1], endNode.position[3])

            dist = 100 * dist / (mapSizeX + mapSizeZ)

            --get threat from current node to adjacent node
            local threat = aiBrain:GetThreatBetweenPositions(newNode.position, lastNode.position, nil, threatType)

            --update path stuff
            local cost = dist + threat*threatWeight

            if lowCost and cost >= lowCost then
                continue
            end

            bestNode = newNode
            lowCost = cost
        end
        if bestNode then
            table.insert(queue.path,bestNode)
            lastNode = bestNode
        end
    until lastNode == endNode

    aiBrain.PathCache[startNode.name][endNode.name] = { settime = GetGameTimeSeconds(), path = queue }

    return queue
end

function CanGraphAreaToSCTA(unit, destPos, layer)
    local startNode = GetClosestPathNodeInRadiusByLayer(unit, 100, layer)
    local endNode = false
    if startNode then
        endNode = GetClosestPathNodeInRadiusByLayer(destPos, 100, layer)
    end
    --WARN('* AI-Uveso: CanGraphAreaTo: Start Area: '..repr(Scenario.MasterChain._MASTERCHAIN_.Markers[startNode.name].GraphArea)..' - End Area: '..repr(Scenario.MasterChain._MASTERCHAIN_.Markers[endNode.name].GraphArea)..'')
    if Scenario.MasterChain._MASTERCHAIN_.Markers[startNode.name].GraphArea == Scenario.MasterChain._MASTERCHAIN_.Markers[endNode.name].GraphArea then
        return true
    end
    return false
end

--[[function CanGraphAreaToSCTANew(startPos, destPos, layer)
    local graphTable = GetPathGraphs()[layer]
    local startNode, endNode, distS, distE
    local bestDistS, bestDistE = 100, 100 -- will only find markers that are closer than 100 map units
    if graphTable then
        for mn, markerInfo in graphTable['Default'..layer] do
            distS = VDist2Sq(startPos[1], startPos[3], markerInfo.position[1], markerInfo.position[3])
            distE = VDist2Sq(destPos[1], destPos[3], markerInfo.position[1], markerInfo.position[3])
            if distS < bestDistS then
                bestDistS = distS
                startNode = markerInfo.name
            end
            if distE < bestDistE then
                bestDistE = distE
                endNode = markerInfo.name
            end
            if bestDistS == 0 and bestDistE == 0 then
                break
            end
        end
    end
    --WARN('* AI-Uveso: CanGraphAreaTo: Start Area: '..repr(Scenario.MasterChain._MASTERCHAIN_.Markers[startNode.name].GraphArea)..' - End Area: '..repr(Scenario.MasterChain._MASTERCHAIN_.Markers[endNode.name].GraphArea)..'')
    if startNode and endNode and Scenario.MasterChain._MASTERCHAIN_.Markers[startNode].GraphArea == Scenario.MasterChain._MASTERCHAIN_.Markers[endNode].GraphArea then
        return true
    end
    return false
end]]