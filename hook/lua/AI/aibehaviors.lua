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

function InWaterCheckSCTA(platoon)
    local t4Pos = platoon:GetPlatoonPosition()
    if GetTerrainHeight(t4Pos[1], t4Pos[3]) < GetSurfaceHeight(t4Pos[1], t4Pos[3]) then
        platoon.inWater = true
    else 
        platoon.inWater = nil
    end
end


function CommanderThreadSCTADecoy(cdr, platoon)
    --LOG('cdr is '..cdr.UnitId)
    local WaitTaunt = 600 + Random(1, 600)
    local aiBrain = cdr:GetAIBrain()
    aiBrain:BuildScoutLocations()
    SetCDRHome(cdr, platoon)
    while not cdr.Dead do
        if not cdr.Taunt then
            TAReclaim.TAAIRandomizeTaunt(aiBrain)
            cdr.Taunt = true
            cdr:SetAutoOvercharge()
            cdr:EnableUnitIntel('Toggle', 'Cloak')
        end
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
        if not cdr.Dead then SCTACDRReturnHome(aiBrain, cdr) end
    end
end

function BehemothBehaviorTotal(self)
    if not self:GatherUnitsSorian() then
        return
    end
    AssignExperimentalPrioritiesSorian(self)
    -- Find target loop
    local experimental
    local targetUnit = false
    local lastBase = false
    ---local useMove = true
    local farTarget = false
    local aiBrain = self:GetBrain()
    local platoonUnits = self:GetPlatoonUnits()
    --local t4Pos = self:GetPlatoonPosition()
    local cmd
    while aiBrain:PlatoonExists(self) do
        self:MergeWithNearbyPlatoonsSorian('ExperimentalAIHubTA', 50, true)
        if lastBase then
            targetUnit, lastBase = WreckBaseSorian(self, lastBase)
        end
    
        if not lastBase then
            targetUnit, lastBase = FindExperimentalTargetSorian(self)
        end
    
        farTarget = false
        if targetUnit and SUtils.XZDistanceTwoVectorsSq(self:GetPlatoonPosition(), targetUnit:GetPosition()) >= 40000 then
            farTarget = true
        end
    
        if targetUnit then
            --[[if GetTerrainHeight(t4Pos[1], t4Pos[3]) < GetSurfaceHeight(t4Pos[1], t4Pos[3]) then
                self.inWater = true
            else 
                self.inWater = nil
            end]]
            InWaterCheckSCTA(self)
            IssueClearCommands(platoonUnits)
            if self.inWater or not farTarget then
                cmd = ExpPathToLocation(aiBrain, self, 'Amphibious', targetUnit:GetPosition(), false)
            else
                cmd = ExpPathToLocation(aiBrain, self, 'Amphibious', targetUnit:GetPosition(), 'AttackMove')
            end
        end
    
        -- Walk to and kill target loop
        local nearCommander = CommanderOverrideCheckSorian(self)
        local ACUattack = false
        while aiBrain:PlatoonExists(self) and targetUnit and not targetUnit.Dead and
        self:IsCommandsActive(cmd) and (nearCommander or ((farTarget and SUtils.XZDistanceTwoVectorsSq(self:GetPlatoonPosition(), targetUnit:GetPosition()) >= 40000) or
        (not farTarget and SUtils.XZDistanceTwoVectorsSq(self:GetPlatoonPosition(), targetUnit:GetPosition()) < 40000))) do
            self:MergeWithNearbyPlatoonsSorian('ExperimentalAIHubTA', 50, true)
            ---useMove = InWaterCheckSCTA(self)
            nearCommander = CommanderOverrideCheckSorian(self)
    
            if nearCommander and (nearCommander ~= targetUnit or
            (not ACUattack and SUtils.XZDistanceTwoVectorsSq(self:GetPlatoonPosition(), nearCommander:GetPosition()) < 40000)) then
                IssueClearCommands(platoonUnits)
                InWaterCheckSCTA(self)
                --[[if GetTerrainHeight(t4Pos[1], t4Pos[3]) < GetSurfaceHeight(t4Pos[1], t4Pos[3]) then
                    self.inWater = true
                else 
                    self.inWater = nil
                end]]
                if self.inWater then
                    cmd = ExpPathToLocation(aiBrain, self, 'Amphibious', nearCommander:GetPosition(), false)
                else
                    cmd = self:AttackTarget(targetUnit)
                    ACUattack = true
                end
                targetUnit = nearCommander
            end
    
            -- Check if we or the target are under a shield
            local closestBlockingShield = false
            for k, v in platoonUnits do
                if not v.Dead then
                    experimental = v
                    break
                end
            end

            closestBlockingShield = closestBlockingShield or GetClosestShieldProtectingTargetSorian(experimental, targetUnit)
    
            -- Kill shields loop
            local oldTarget = false
            while closestBlockingShield do
                oldTarget = oldTarget or targetUnit
                targetUnit = false
                self:MergeWithNearbyPlatoonsSorian('ExperimentalAIHubTA', 50, true)
                --[[if GetTerrainHeight(t4Pos[1], t4Pos[3]) < GetSurfaceHeight(t4Pos[1], t4Pos[3]) then
                    self.inWater = true
                else 
                    self.inWater = nil
                end]]
                InWaterCheckSCTA(self)
                IssueClearCommands(platoonUnits)
                if self.inWater or SUtils.XZDistanceTwoVectorsSq(self:GetPlatoonPosition(), closestBlockingShield:GetPosition()) < 40000 then
                    cmd = ExpPathToLocation(aiBrain, self, 'Amphibious', closestBlockingShield:GetPosition(), false)
                else
                    cmd = ExpPathToLocation(aiBrain, self, 'Amphibious', closestBlockingShield:GetPosition(), 'AttackMove')
                end
    
                local farAway = true
                if SUtils.XZDistanceTwoVectorsSq(self:GetPlatoonPosition(), closestBlockingShield:GetPosition()) < 40000 then
                    farAway = false
                end
    
                -- Wait for shield to die loop
                while not closestBlockingShield.Dead and aiBrain:PlatoonExists(self) and self.inWater
                and self:IsCommandsActive(cmd) do
                    self:MergeWithNearbyPlatoonsSorian('ExperimentalAIHubTA', 50, true)
                    local targDistSq = SUtils.XZDistanceTwoVectorsSq(self:GetPlatoonPosition(), closestBlockingShield:GetPosition())
                    if (farAway and targDistSq < 40000) or (not farAway and targDistSq >= 40000) then
                        break
                    end
                    --WaitSeconds(1)
                    coroutine.yield(11)
                end
    
                closestBlockingShield = false
                for k, v in platoonUnits do
                    if not v.Dead then
                        experimental = v
                        break
                    end
                end
    
                closestBlockingShield = closestBlockingShield or GetClosestShieldProtectingTargetSorian(experimental, oldTarget)
                --WaitSeconds(1)
                coroutine.yield(11)
                end
            --WaitSeconds(1)
            coroutine.yield(11)
            end
        --WaitSeconds(1)
        coroutine.yield(11)
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
        -- Go back to base 
        if not cdr.Dead and cdr:IsIdleState() then
            if aiBrain.TAFactoryAssistance then
                if aiBrain.Level3 and not cdr.CLOAKAITA then
                    ---LOG('IEXISTTA')
                    cdr:OnScriptBitClear(8)
                    cdr.CLOAKAITA = true
                end
                if aiBrain.Level2 then
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
                IssueClearCommands(cdr)
                cdr.Escorting = nil
                end
            end
            if not cdr.Escorting and not cdr.EngineerBuildQueue or table.getn(cdr.EngineerBuildQueue) == 0 then
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
        if not cdr.Dead then SCTACDRReturnHome(aiBrain, cdr) end
        coroutine.yield(2)
        if not cdr.Dead and GetGameTimeSeconds() > WaitTaunt and (not aiBrain.LastVocTaunt or GetGameTimeSeconds() - aiBrain.LastVocTaunt > WaitTaunt) then
            SUtils.AIRandomizeTaunt(aiBrain)
            ---cdr:OnScriptBitSet('ToggleBit8', 'Cloak')
            WaitTaunt = 600 + Random(1, 900)
        end
    end
end


function SCTACDRReturnHome(aiBrain, cdr)
    -- This is a reference... so it will autoupdate
    local cdrPos = cdr:GetPosition()
    local distSqAway = 150
    local loc = cdr.CDRHome
    if not cdr.Dead and VDist2Sq(cdrPos[1], cdrPos[3], loc[1], loc[3]) > distSqAway then
        local plat = aiBrain:MakePlatoon('', '')
        aiBrain:AssignUnitsToPlatoon(plat, {cdr}, 'Support', 'None')
        --cdr:SetScriptBit('RULEUTC_CloakToggle', false)
        repeat
            CDRRevertPriorityChange(aiBrain, cdr)
            if not aiBrain:PlatoonExists(plat) then
                return
            end
            IssueStop({cdr})
            IssueMove({cdr}, loc)
            cdr.GoingHome = true
            WaitSeconds(7)
        until cdr.Dead or VDist2Sq(cdrPos[1], cdrPos[3], loc[1], loc[3]) <= distSqAway
        cdr.GoingHome = false
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