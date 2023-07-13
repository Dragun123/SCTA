WARN('['..string.gsub(debug.getinfo(1).source, ".*\\(.*.lua)", "%1")..', line:'..debug.getinfo(1).currentline..'] * SCTAAI: offset aibehaviors.lua' )
--local TAPrior = import('/mods/SCTA-master/lua/AI/TAEditors/TAPriorityManager.lua')
local TAReclaim = import('/mods/SCTA-master/lua/AI/TAEditors/TAAIUtils.lua')
function CommanderBehaviorSCTA(platoon)
    for _, v in platoon:GetPlatoonUnits() do
        if not v.Dead and not v.CommanderThread then
            v.CommanderThread = v:ForkThread(CommanderThreadSCTA, platoon)
        end
    end
end

function CommanderBehaviorSCTADecoy(platoon)
    for _, v in platoon:GetPlatoonUnits() do
        if not v.Dead and not v.CommanderThread then
            v.CommanderThread = v:ForkThread(CommanderThreadSCTADecoy, platoon)
        end
    end
end

function CommanderThreadSCTADecoy(cdr, platoon)
    --LOG('cdr is '..cdr.UnitId)
    local aiBrain = cdr:GetAIBrain()
    if not cdr.Taunt then
        TAReclaim.TAAIRandomizeTaunt(aiBrain)
        cdr.Taunt = true
        cdr:SetAutoOvercharge()
        cdr:OnScriptBitClear(8)
    end
    while not cdr.Dead do
        -- Overcharge
        --cdr:SetAutoOvercharge()
        -- Go back to base
        if not cdr.Dead and cdr:IsIdleState() then
            if not cdr.EngineerBuildQueue or table.getn(cdr.EngineerBuildQueue) == 0 then
                local pool = aiBrain:GetPlatoonUniquelyNamed('ArmyPool')
                aiBrain:AssignUnitsToPlatoon( pool, {cdr}, 'Unassigned', 'None' )
            elseif cdr.EngineerBuildQueue and table.getn(cdr.EngineerBuildQueue) != 0 then
                if not cdr.NotBuildingThread then
                    cdr.NotBuildingThread = cdr:ForkThread(platoon.SCTAWatchForNotBuilding)
                end             
            end
        end
        coroutine.yield(2)
    end
end
    
function CommanderThreadSCTA(cdr, platoon)
    --LOG('cdr is '..cdr.UnitId)
    local WaitTaunt = 600 + Random(1, 600)
    local aiBrain = cdr:GetAIBrain()
    aiBrain:BuildScoutLocations()
    TAReclaim.TAAIRandomizeTaunt(aiBrain)
    cdr:SetAutoOvercharge()
    SetCDRHome(cdr, platoon)
    while not cdr.Dead do
        if (cdr:GetHealthPercent() < 0.6 or aiBrain.Level2) and not cdr.Dead then
            coroutine.yield(2)      
            SCTACDRReturnHome(aiBrain, cdr, platoon)
        end
        if not cdr.Dead and cdr:IsIdleState() then
            if aiBrain.TAFactoryAssistance then
                if aiBrain.Level3 and not cdr.CLOAKAITA then
                    ---LOG('IEXISTTA')
                    cdr:OnScriptBitClear(8)
                    cdr.CLOAKAITA = true
                    coroutine.yield(2)      
                    ---SCTACDRReturnHome(aiBrain, cdr, platoon)
                end
                if aiBrain.Level2 then
                    if not cdr.GoingHome then
                    SCTACDRReturnHome(aiBrain, cdr, platoon)
                    end
                    local Escort = platoon.EngineerTAAssist(cdr, aiBrain, categories.STRUCTURE, 20)
                    if not Escort then
                        Escort = platoon.FactoryTAAssist(cdr, aiBrain, categories.FACTORY, 20)
                    end
                    if Escort and not Escort.Dead then
                        if cdr.CLOAKAITA then
                            cdr.CLOAKAITA = nil
                            cdr:OnScriptBitSet(8)
                        end
                        --IssueClearCommands(cdr)
                        IssueGuard({cdr}, Escort)
                        cdr.Escorting = true 
                        WaitSeconds(30)
                    end
                ---IssueClearCommands(cdr)
                cdr.Escorting = nil
                end
            end
            if not (cdr.Escorting or cdr.GoingHome) and not cdr.EngineerBuildQueue or table.getn(cdr.EngineerBuildQueue) == 0 then
                local pool = aiBrain:GetPlatoonUniquelyNamed('ArmyPool')
                ---cdr:OnScriptBitClear(8)
                aiBrain:AssignUnitsToPlatoon( pool, {cdr}, 'Unassigned', 'None' )
            elseif cdr.EngineerBuildQueue and table.getn(cdr.EngineerBuildQueue) != 0 then
                if not cdr.NotBuildingThread then
                    cdr.NotBuildingThread = cdr:ForkThread(platoon.SCTAWatchForNotBuilding)
                end             
            end
        end
        coroutine.yield(2)      
        if not cdr.Dead then SCTACDRReturnHome(aiBrain, cdr, platoon) end
        coroutine.yield(2)
        if not cdr.Dead and GetGameTimeSeconds() > WaitTaunt and (not aiBrain.LastVocTaunt or GetGameTimeSeconds() - aiBrain.LastVocTaunt > WaitTaunt) then
            import("/lua/ai/sorianutilities.lua").AIRandomizeTaunt(aiBrain)
            ---cdr:OnScriptBitSet('ToggleBit8', 'Cloak')
            WaitTaunt = 600 + Random(1, 900)
        end
    end
end


function SCTACDRReturnHome(aiBrain, cdr, platoon)
    -- This is a reference... so it will autoupdate
    local cdrPos = cdr:GetPosition()
    local distSqAway = 25
    local loc = cdr.CDRHome
    if not cdr.Dead and (VDist2Sq(cdrPos[1], cdrPos[3], loc[1], loc[3]) > distSqAway or cdr:GetHealthPercent() < 0.6 or aiBrain.Level2) then
        local plat = aiBrain:MakePlatoon('', '')
        aiBrain:AssignUnitsToPlatoon(plat, {cdr}, 'Support', 'None')
        repeat
            CDRRevertPriorityChange(aiBrain, cdr)
            if not aiBrain:PlatoonExists(platoon) then
                return
            end
            IssueStop({cdr})
            IssueMove({cdr}, loc)
            cdr.GoingHome = true
            WaitSeconds(7)
        until cdr.Dead or VDist2Sq(cdrPos[1], cdrPos[3], loc[1], loc[3]) <= distSqAway
        cdr.GoingHome = nil
        IssueClearCommands({cdr})
    end
end


function SCTAAirUnitRefit(self)
    for k, v in self:GetPlatoonUnits() do
        if not v.Dead and not v.RefitThread then
            v.RefitThreat = v:ForkThread(SCTAAirUnitRefitThread, self:GetPlan(), self.PlatoonData)
        end
    end
end

function SCTAAirUnitRefitThread(unit, plan, data)
    unit.PlanName = plan
    if data then
        unit.PlatoonData = data
    end

    local aiBrain = unit:GetAIBrain()
    while not unit.Dead do
        local fuel = unit:GetFuelRatio()
        local health = unit:GetHealthPercent()
        if not unit.Loading and (fuel < 0.2 or health < 0.4) then
            -- Find air stage
            if aiBrain:GetCurrentUnits(categories.AIRSTAGINGPLATFORM) > 0 then
                local unitPos = unit:GetPosition()
                local plats = AIUtils.GetOwnUnitsAroundPoint(aiBrain, categories.AIRSTAGINGPLATFORM, unitPos, 400)
                if not table.empty(plats) then
                    local closest, distance
                    for _, v in plats do
                        if not v.Dead then
                            local roomAvailable = false
                            if not EntityCategoryContains(categories.CARRIER, v) then
                                roomAvailable = v:TransportHasSpaceFor(unit)
                            end
                            if roomAvailable then
                                local platPos = v:GetPosition()
                                local tempDist = VDist2(unitPos[1], unitPos[3], platPos[1], platPos[3])
                                if not closest or tempDist < distance then
                                    closest = v
                                    distance = tempDist
                                end
                            end
                        end
                    end
                    if closest then
                        local plat = aiBrain:MakePlatoon('', '')
                        aiBrain:AssignUnitsToPlatoon(plat, {unit}, 'Attack', 'None')
                        IssueStop({unit})
                        IssueClearCommands({unit})
                        IssueTransportLoad({unit}, closest)
                        if EntityCategoryContains(categories.AIRSTAGINGPLATFORM, closest) and not closest.AirStaging then
                            closest.AirStaging = closest:ForkThread(SCTAAirStagingThread)
                            closest.Refueling = {}
                        elseif EntityCategoryContains(categories.CARRIER, closest) and not closest.CarrierStaging then
                            closest.CarrierStaging = closest:ForkThread(CarrierStagingThread)
                            closest.Refueling = {}
                        end
                        table.insert(closest.Refueling, unit)
                        unit.Loading = true
                    end
                end
            end
        end
        --WaitSeconds(1)
        coroutine.yield(11)
    end
end

function SCTAAirStagingThread(unit)
    local aiBrain = unit:GetAIBrain()
    while not unit.Dead do
        local ready = true
        local numUnits = 0
        for _, v in unit.Refueling do
            if not v.Dead and (v:GetFuelRatio() < 0.5 or v:GetHealthPercent() < 0.5) then
                ready = false
            elseif not v.Dead then
                numUnits = numUnits + 1
            end
        end
        if ready and numUnits > 0 then
            local pos = unit:GetPosition()
            IssueClearCommands({unit})
            IssueTransportUnload({unit}, {pos[1] + 5, pos[2], pos[3] + 5})
            --WaitSeconds(2)
            coroutine.yield(21)
            for _, v in unit.Refueling do
                if not v.Dead then
                    v.Loading = false
                    local plat = aiBrain:MakePlatoon('IntieAISCTA', 'InterceptorAISCTA')
                    if v.PlatoonData then
                        plat.PlatoonData = {}
                        plat.PlatoonData = v.PlatoonData
                    end
                    aiBrain:AssignUnitsToPlatoon(plat, {v}, 'Attack', 'GrowthFormation')
                end
            end
        end
        WaitSeconds(10)
    end
end