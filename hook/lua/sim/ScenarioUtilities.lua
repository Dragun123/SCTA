---local TACreateInitialArmyGroup = CreateInitialArmyGroup

function CreateInitialArmyGroup(strArmy, createCommander)
	CreateWind()
	for index, moddata in __active_mods do
		if not moddata.name == 'AI-Uveso' then
			BuildGraphAreasTA()
		end
	end
	--[[for index, moddata in __active_mods do
		if moddata.name == 'All factions FAF BlackOps Nomads' then
			TACreateInitialArmyGroup(strArmy, createCommander)
		end
	end]] ---Need To Decide How I want compatibility to work
	local tblGroup = CreateArmyGroup(strArmy, 'INITIAL')
	local cdrUnit = false
	local initialUnitName
    if createCommander and ( tblGroup == nil or 0 == table.getn(tblGroup) )  then
		local ABrain = GetArmyBrain(strArmy);
		if(ABrain.BrainType == 'Human') then
			local initialUnitName = 'mas0001'
			cdrUnit = CreateInitialArmyUnit(strArmy, initialUnitName)
			cdrUnit:SetUnSelectable(false)
			cdrUnit:SetBusy(true)
			cdrUnit:SetBlockCommandQueue(true)
			ForkThread(ControlDelay, cdrUnit, 8.75)
		else
			local tblGroup = CreateArmyGroup( strArmy, 'INITIAL')
			local cdrUnit = false
		
			if createCommander and ( tblGroup == nil or 0 == table.getn(tblGroup) ) then
				local per = ScenarioInfo.ArmySetup[ABrain.Name].AIPersonality
				if per == 'sctaaiarm' then
					initialUnitName = 'armcom'
				elseif per == 'sctaaicore' then
					initialUnitName = 'corcom'
				else
					local factionIndex = GetArmyBrain(strArmy):GetFactionIndex()
					initialUnitName = import('/lua/factions.lua').Factions[factionIndex].InitialUnit
				end
				cdrUnit = CreateInitialArmyUnit(strArmy, initialUnitName)
				if EntityCategoryContains(categories.COMMAND, cdrUnit) then
					if ScenarioInfo.Options['PrebuiltUnits'] == 'Off' then
						cdrUnit:HideBone(0, true)
						ForkThread(CommanderWarpDelay, cdrUnit, 3)
					end
				end
			end
		end
    end
    return tblGroup, cdrUnit
end


function ControlDelay(cdrUnit, delay)
    WaitSeconds(delay)
		cdrUnit:SetUnSelectable(false)
		cdrUnit:SetBusy(false)
		cdrUnit:SetBlockCommandQueue(false)
end

function CreateWind()
	if not ScenarioInfo.WindStats then
		ScenarioInfo.WindStats = {Thread = ForkThread(WindThread)}
	end
end

function WindThread()
	WaitTicks(26)
	--Declared locally for performance, since they are used a lot.
	local random = math.random
	local min = math.min
	local max = math.max
	local mod = math.mod
	while true do
		ScenarioInfo.WindStats.Power = min(max( (ScenarioInfo.WindStats.Power or 0.5) + 0.5 - random(),0),1)
		--Defines a real number, starting from 0.5, between 0 and 1 that randomly fluctuates by up to 0.5 either direction.
		--math.random() with no args returns a real number between 0 and 1
		ScenarioInfo.WindStats.Direction = mod((ScenarioInfo.WindStats.Direction or random(0,360)) + random(-5,5) + random(-5,5) + random(-5,5) + random(-5,5), 360)
		--Defines an int between 0 and 360, that fluctuates by up to 20 either direction, with a strong bias towards 0 fluctuation, that cylces around when 0 or 360 is exceeded.
		WaitTicks(30 + 1)
		--Wait ticks waits 1 less tick than it should. #timingissues
	end
end

function BuildGraphAreasTA()
    local GraphIndex = {
        ['Land Path Node'] = 0,
        ['Water Path Node'] = 0,
        ['Amphibious Path Node'] = 0,
        ['Air Path Node'] = 0,
    }
    local old
    for k, v in Scenario.MasterChain._MASTERCHAIN_.Markers do
        -- only check waypoint markers
        if MarkerDefaults[v.type] then
            -- Do we have already an Index number for this Graph area ?
            if not v.GraphArea then
                GraphIndex[v.type] = GraphIndex[v.type] + 1
                Scenario.MasterChain._MASTERCHAIN_.Markers[k].GraphArea = GraphIndex[v.type]
                --LOG('*BuildGraphAreas: Marker '..k..' has no Graph index, set it to '..GraphArea[v.type])
            end
            -- check adjancents
            if v.adjacentTo then
                local adjancents = STR_GetTokens(v.adjacentTo or '', ' ')
                if adjancents[0] then
                    for i, node in adjancents do
                        -- check if the new node has not a GraphIndex 
                        if not Scenario.MasterChain._MASTERCHAIN_.Markers[node].GraphArea then
                            --LOG('*BuildGraphAreas: adjacentTo '..node..' has no Graph index, set it to '..Scenario.MasterChain._MASTERCHAIN_.Markers[k].GraphArea)
                            Scenario.MasterChain._MASTERCHAIN_.Markers[node].GraphArea = Scenario.MasterChain._MASTERCHAIN_.Markers[k].GraphArea
                        -- the node has already a graph index. Overwrite all nodes connected to this node with the new index
                        elseif Scenario.MasterChain._MASTERCHAIN_.Markers[node].GraphArea ~= Scenario.MasterChain._MASTERCHAIN_.Markers[k].GraphArea then
                            -- save the old index here, we will overwrite Markers[node].GraphArea
                            old = Scenario.MasterChain._MASTERCHAIN_.Markers[node].GraphArea
                            --LOG('*BuildGraphAreas: adjacentTo '..node..' has Graph index '..old..' overwriting it with '..Scenario.MasterChain._MASTERCHAIN_.Markers[k].GraphArea)
                            for k2, v2 in Scenario.MasterChain._MASTERCHAIN_.Markers do
                                -- Has the adjacent the same type than the marker
                                if v.type == v2.type then
                                    -- has this node the same index then our main marker ?
                                    if Scenario.MasterChain._MASTERCHAIN_.Markers[k2].GraphArea == old then
                                        --LOG('*BuildGraphAreas: adjacentTo '..k2..' has Graph index '..old..' overwriting it with '..Scenario.MasterChain._MASTERCHAIN_.Markers[k].GraphArea)
                                        Scenario.MasterChain._MASTERCHAIN_.Markers[k2].GraphArea = Scenario.MasterChain._MASTERCHAIN_.Markers[k].GraphArea
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    -- make propper Area names and IDs
    for k, v in Scenario.MasterChain._MASTERCHAIN_.Markers do
        if v.GraphArea then
            -- We can't just copy it into .graph without breaking stuff, so we use .GraphArea instead
--            Scenario.MasterChain._MASTERCHAIN_.Markers[k].graph = MarkerDefaults[v.type].area..'_'..v.GraphArea
            Scenario.MasterChain._MASTERCHAIN_.Markers[k].GraphArea = MarkerDefaults[v.type].area..'_'..v.GraphArea
        end
    end

    -- Validate
    local GraphCountIndex = {
        ['Land Path Node'] = {},
        ['Water Path Node'] = {},
        ['Amphibious Path Node'] = {},
        ['Air Path Node'] = {},
    }
    for k, v in Scenario.MasterChain._MASTERCHAIN_.Markers do
        if v.GraphArea then
            GraphCountIndex[v.type][v.GraphArea] = GraphCountIndex[v.type][v.GraphArea] or 1
            GraphCountIndex[v.type][v.GraphArea] = GraphCountIndex[v.type][v.GraphArea] + 1
        end
    end
    SPEW('* AI-Uveso: BuildGraphAreas(): '..repr(GraphCountIndex))
end