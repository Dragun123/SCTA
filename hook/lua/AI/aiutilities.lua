WARN('['..string.gsub(debug.getinfo(1).source, ".*\\(.*.lua)", "%1")..', line:'..debug.getinfo(1).currentline..'] * SCTAAI: offset ATUtils.lua' )

function TAGetTransports(platoon, units)
    if not units then
        units = platoon:GetPlatoonUnits()
    end

    -- Check for empty platoon
    if table.getn(units) == 0 then
        return 0
    end

    local neededTable = GetNumTransports(units)
    local transportsNeeded = false
    if neededTable.Small > 0 or neededTable.Medium > 0 or neededTable.Large > 0 then
        transportsNeeded = true
    end


    local aiBrain = platoon:GetBrain()
    local pool = aiBrain:GetPlatoonUniquelyNamed('ArmyPool')

    -- Make sure more are needed
    local tempNeeded = {}
    tempNeeded.Small = neededTable.Small
    tempNeeded.Medium = neededTable.Medium
    tempNeeded.Large = neededTable.Large

    local location = platoon:GetPlatoonPosition()
    if not location then
        -- We can assume we have at least one unit here
        location = units[1]:GetCachePosition()
    end

    if not location then
        return 0
    end

    -- Determine distance of transports from platoon
    local transports = {}
    for _, unit in pool:GetPlatoonUnits() do
        if not unit.Dead and EntityCategoryContains(categories.TRANSPORTFOCUS, unit) and not unit:IsUnitState('Busy') and not unit:IsUnitState('TransportLoading') and table.getn(unit:GetCargo()) < 1 and unit:GetFractionComplete() == 1 then
            local unitPos = unit:GetPosition()
            local curr = {Unit = unit, Distance = VDist2(unitPos[1], unitPos[3], location[1], location[3]),
                           Id = unit.UnitId}
            table.insert(transports, curr)
        end
    end

    local numTransports = 0
    local transSlotTable = {}
    if not table.empty(transports) then
        local sortedList = {}
        -- Sort distances
        for k = 1, table.getn(transports) do
            local lowest = -1
            local key, value
            for j, u in transports do
                if lowest == -1 or u.Distance < lowest then
                    lowest = u.Distance
                    value = u
                    key = j
                end
            end
            sortedList[k] = value
            -- Remove from unsorted table
            table.remove(transports, key)
        end

        -- Take transports as needed
        for i = 1, table.getn(sortedList) do
            if transportsNeeded and table.getn(sortedList[i].Unit:GetCargo()) < 1 and not sortedList[i].Unit:IsUnitState('TransportLoading') then
                local id = sortedList[i].Id
                aiBrain:AssignUnitsToPlatoon(platoon, {sortedList[i].Unit}, 'Scout', 'GrowthFormation')
                numTransports = numTransports + 1
                if not transSlotTable[id] then
                    transSlotTable[id] = GetNumTransportSlots(sortedList[i].Unit)
                end
                local tempSlots = {}
                tempSlots.Small = transSlotTable[id].Small
                tempSlots.Medium = transSlotTable[id].Medium
                tempSlots.Large = transSlotTable[id].Large
                -- Update number of slots needed
                while tempNeeded.Large > 0 and tempSlots.Large > 0 do
                    tempNeeded.Large = tempNeeded.Large - 1
                    tempSlots.Large = tempSlots.Large - 1
                    tempSlots.Medium = tempSlots.Medium - 2
                    tempSlots.Small = tempSlots.Small - 4
                end
                while tempNeeded.Medium > 0 and tempSlots.Medium > 0 do
                    tempNeeded.Medium = tempNeeded.Medium - 1
                    tempSlots.Medium = tempSlots.Medium - 1
                    tempSlots.Small = tempSlots.Small - 2
                end
                while tempNeeded.Small > 0 and tempSlots.Small > 0 do
                    tempNeeded.Small = tempNeeded.Small - 1
                    tempSlots.Small = tempSlots.Small - 1
                end
                if tempNeeded.Small <= 0 and tempNeeded.Medium <= 0 and tempNeeded.Large <= 0 then
                    transportsNeeded = false
                end
            end
        end
    end

    if transportsNeeded then
        ReturnTransportsToPool(platoon:GetSquadUnits('Scout'), false)
        return false, tempNeeded.Small, tempNeeded.Medium, tempNeeded.Large
    else
        platoon.UsingTransport = true
        return numTransports, 0, 0, 0
    end
end

function SCTAEngineerMoveWithSafePath(aiBrain, unit, destination)
    if not destination then
        return false
    end
    if not unit.PlatoonHandle.MovementLayer then
        if unit.PlatoonHandle then
            import('/lua/AI/aiattackutilities.lua').GetMostRestrictiveLayer(unit.PlatoonHandle)
        else
            WARN('Unit has no PlatoonHandle : unable to set movement layer, did we create this platoon normally')
        end
    end
    local NavUtils = import('/lua/sim/NavUtils.lua')
    local result, reason = false
    local unitPos = unit:GetPosition()
    local movementLayer = unit.PlatoonHandle.MovementLayer
    result, reason = NavUtils.CanPathTo(movementLayer, unitPos, destination)
    if not result and reason == 'NotGenerated' then
        result, _ = unit:CanPathTo(destination)
    end
    -- If we're here, we haven't used transports and we can path to the destination
    if result then
        local path, reason = AIAttackUtils.PlatoonGenerateSafePathToSCTAAI(aiBrain, unit.Blueprint.Physics.Climber or movementLayer, unit:GetPosition(), destination, 10)
        if path then
            local pathSize = table.getn(path)
            -- Move to way points (but not to destination... leave that for the final command)
            for widx, waypointPath in path do
                if pathSize ~= widx then
                    IssueMove({unit}, waypointPath)
                end
            end
        end
        -- If there wasn't a *safe* path (but dest was pathable), then the last move would have been to go there directly
        -- so don't bother... the build/capture/reclaim command will take care of that after we return
        return true
    end
    return false
end

function SCTAEngineerMoveWithSafePathAir(aiBrain, unit, destination)
    if not destination then
        return false
    end
    local NavUtils = import('/lua/sim/NavUtils.lua')
    local result, reason = false
    local unitPos = unit:GetPosition()
    result, reason = NavUtils.CanPathTo('Air', unitPos, destination)
    if not result and reason == 'NotGenerated' then
        result, _ = unit:CanPathTo(destination)
    end
    -- If we're here, we haven't used transports and we can path to the destination
    if result then
        local path, reason = AIAttackUtils.PlatoonGenerateSafePathToSCTAAI(aiBrain, 'Air', unit:GetPosition(), destination, 10)
        if path then
            local pathSize = table.getn(path)
            -- Move to way points (but not to destination... leave that for the final command)
            for widx, waypointPath in path do
                if pathSize ~= widx then
                    IssueMove({unit}, waypointPath)
                end
            end
        end
        -- If there wasn't a *safe* path (but dest was pathable), then the last move would have been to go there directly
        -- so don't bother... the build/capture/reclaim command will take care of that after we return
        return true
    end

    return false
end

function SCTAEngineerMoveWithSafePathNaval(aiBrain, unit, destination)
    if not destination then
        return false
    end
    local NavUtils = import('/lua/sim/NavUtils.lua')
    local result, reason = false
    local unitPos = unit:GetPosition()
    result, reason = NavUtils.CanPathTo('Water', unitPos, destination)
    if not result and reason == 'NotGenerated' then
        result, _ = unit:CanPathTo(destination)
    end
    -- If we're here, we haven't used transports and we can path to the destination
    if result then
        local path, reason = AIAttackUtils.PlatoonGenerateSafePathToSCTAAI(aiBrain, 'Water', unitPos, destination, 10)
        if path then
            local pathSize = table.getn(path)
            -- Move to way points (but not to destination... leave that for the final command)
            for widx, waypointPath in path do
                if pathSize ~= widx then
                    IssueMove({unit}, waypointPath)
                end
            end
        end
        -- If there wasn't a *safe* path (but dest was pathable), then the last move would have been to go there directly
        -- so don't bother... the build/capture/reclaim command will take care of that after we return
        return true
    end
    return false
end

function SCTAEngineerMoveWithSafePathLand(aiBrain, unit, destination)
    if not destination then
        return false
    end
    local NavUtils = import('/lua/sim/NavUtils.lua')
    local result, reason = false
    local unitPos = unit:GetPosition()
    result, reason = NavUtils.CanPathTo('Land', unitPos, destination)
    if not result and reason == 'NotGenerated' then
        result, _ = unit:CanPathTo(destination)
    end

    -- If we're here, we haven't used transports and we can path to the destination
    if result then
        local path, reason = AIAttackUtils.PlatoonGenerateSafePathToSCTAAI(aiBrain, 'Land', unit:GetPosition(), destination)
        if path then
            local pathSize = table.getn(path)
            -- Move to way points (but not to destination... leave that for the final command)
            for widx, waypointPath in path do
                if pathSize ~= widx then
                    IssueMove({unit}, waypointPath)
                end
            end
        end
        -- If there wasn't a *safe* path (but dest was pathable), then the last move would have been to go there directly
        -- so don't bother... the build/capture/reclaim command will take care of that after we return
        return true
    end
    return false
end


--[[function AIGetSortedMassLocationsNavalSCTA(aiBrain, maxNum, tMin, tMax, tRings, tType, position)
    local markerList = AIGetMarkerLocations(aiBrain, 'Mass')
    local newList = {}
    for _, v in markerList do
        local height = GetTerrainHeight(v.Position[1], v.Position[3])
        local surfHeight = GetSurfaceHeight(v.Position[1], v.Position[3])
        -- check distance to map border. (game engine can't build mass closer then 8 mapunits to the map border.) 
        if v.Position[1] <= 8 or v.Position[1] >= ScenarioInfo.size[1] - 8 or v.Position[3] <= 8 or v.Position[3] >= ScenarioInfo.size[2] - 8 or v.Height > v.surfHeight then
            -- mass marker is too close to border, skip it.
            continue
        end
        if aiBrain:CanBuildStructureAt('ueb1103', v.Position) then
            table.insert(newList, v)
        end
    end
    return AISortMarkersFromLastPos(aiBrain, newList, maxNum, tMin, tMax, tRings, tType, position)
end]]
