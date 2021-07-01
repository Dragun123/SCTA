WARN('['..string.gsub(debug.getinfo(1).source, ".*\\(.*.lua)", "%1")..', line:'..debug.getinfo(1).currentline..'] * SCTAAI: offset aibehaviors.lua' )

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
    local WaitTaunt = 600 + Random(1, 600)
    local aiBrain = cdr:GetAIBrain()
    aiBrain:BuildScoutLocations()
    TAReclaim.TAAIRandomizeTaunt(aiBrain)
    SetCDRHome(cdr, platoon)
    while not cdr.Dead do
        -- Overcharge
        if not cdr.Dead and table.getn(cdr.EngineerBuildQueue) == 0 and cdr.BuildingUnit == false then CDRSCTADGun(aiBrain, cdr) end
        WaitTicks(1)

        -- Go back to base
        if not cdr.Dead then SCTACDRReturnHome(aiBrain, cdr) end
        WaitTicks(1)
        if not cdr:IsDead() and cdr:IsIdleState() then
            if not cdr.EngineerBuildQueue or table.getn(cdr.EngineerBuildQueue) == 0 then
                local pool = aiBrain:GetPlatoonUniquelyNamed('ArmyPool')
                aiBrain:AssignUnitsToPlatoon( pool, {cdr}, 'Unassigned', 'None' )
            elseif cdr.EngineerBuildQueue and table.getn(cdr.EngineerBuildQueue) != 0 then
                if not cdr.NotBuildingThread then
                    cdr.NotBuildingThread = cdr:ForkThread(platoon.WatchForNotBuilding)
                end             
            end
        end
        WaitTicks(1)        
        if not cdr.Dead and GetGameTimeSeconds() > WaitTaunt and (not aiBrain.LastVocTaunt or GetGameTimeSeconds() - aiBrain.LastVocTaunt > WaitTaunt) then
            TAReclaim.TAAIRandomizeTaunt(aiBrain)
            WaitTaunt = 600 + Random(1, 900)
        end
    end
end


function CDRSCTADGunDecoy(aiBrain, cdr)
    local weapBPs = cdr:GetBlueprint().Weapon
    local weapon
    for k, v in weapBPs do
        if v.Label == 'OverCharge' then
            weapon = v
            break
        end
    end

    local distressRange = 100
    local maxRadius = weapon.MaxRadius * 4.55
    local weapRange = weapon.MaxRadius
    cdr.UnitBeingBuiltBehavior = false

    local cdrPos = cdr.CDRHome
    local numUnits1 = aiBrain:GetNumUnitsAroundPoint(categories.LAND * categories.TECH1 - categories.SCOUT - categories.ENGINEER, cdrPos, maxRadius, 'Enemy')
    local numUnits2 = aiBrain:GetNumUnitsAroundPoint(categories.LAND * categories.TECH2 - categories.SCOUT - categories.ENGINEER, cdrPos, maxRadius, 'Enemy')
    local numUnits3 = aiBrain:GetNumUnitsAroundPoint(categories.LAND * categories.TECH3 - categories.SCOUT - categories.ENGINEER, cdrPos, maxRadius, 'Enemy')
    local numUnitsEng = aiBrain:GetNumUnitsAroundPoint(categories.ENGINEER * (categories.TECH1 + categories.TECH2 + categories.TECH3), cdrPos, maxRadius, 'Enemy')
    local numUnits4 = aiBrain:GetNumUnitsAroundPoint(categories.EXPERIMENTAL, cdrPos, maxRadius + 130, 'Enemy')
    local numStructs = aiBrain:GetNumUnitsAroundPoint(categories.STRUCTURE, cdrPos, maxRadius, 'Enemy')
    local numUnitsDF = aiBrain:GetNumUnitsAroundPoint(categories.DEFENSE * categories.STRUCTURE * categories.DIRECTFIRE - categories.TECH1, cdrPos, maxRadius + 50, 'Enemy')
    local numUnitsDF1 = aiBrain:GetNumUnitsAroundPoint(categories.DEFENSE * categories.STRUCTURE * categories.DIRECTFIRE * categories.TECH1, cdrPos, maxRadius + 30, 'Enemy')
    local numUnitsIF = aiBrain:GetNumUnitsAroundPoint(categories.DEFENSE * categories.STRUCTURE * categories.INDIRECTFIRE - categories.TECH1, cdrPos, maxRadius + 260, 'Enemy')
    local totalUnits = numUnits1 + numUnits2 + numUnits3 + numUnits4 + numStructs + numUnitsEng
    local distressLoc = aiBrain:BaseMonitorDistressLocation(cdrPos)

    if Utilities.XZDistanceTwoVectors(cdrPos, cdr:GetPosition()) > distressRange then
        return
    end

    local commanderResponse = false
    if distressLoc then
        local distressUnitsNaval = aiBrain:GetNumUnitsAroundPoint(categories.NAVAL, distressLoc, 40, 'Enemy')
        local distressUnitsAir = aiBrain:GetNumUnitsAroundPoint(categories.AIR * (categories.BOMBER + categories.GROUNDATTACK + categories.ANTINAVY), distressLoc, 30, 'Enemy')
        local distressUnitsexp = aiBrain:GetNumUnitsAroundPoint(categories.EXPERIMENTAL, distressLoc, 50, 'Enemy')
        if distressUnitsNaval > 0 then
            if cdr:HasEnhancement('NaniteTorpedoTube') and distressUnitsNaval < 5 and distressUnitsexp < 1 then
                commanderResponse = true
            else
                commanderResponse = false
            end
        elseif distressUnitsAir > 0 then
            commanderResponse = false
        elseif distressUnitsexp > 0 then
            commanderResponse = false
        elseif numUnits1 > 14 or numUnits2 > 9 or numUnits3 > 4 or numUnits4 > 0 or numUnitsDF > 0 or numUnitsIF > 0 or numUnitsDF1 > 2 then
            commanderResponse = false
        else
            commanderResponse = true
        end
    end

    local overCharging = false
    if (not cdr.DistressCall and distressLoc and commanderResponse and Utilities.XZDistanceTwoVectors(distressLoc, cdrPos) < distressRange) then
        CDRRevertPriorityChange(aiBrain, cdr)
        if cdr.UnitBeingBuilt then
            cdr.UnitBeingBuiltBehavior = cdr.UnitBeingBuilt
        end

        cdr.Fighting = true
        cdr.GoingHome = false
        cdr.Upgrading = false
        local plat = aiBrain:MakePlatoon('', '')
        aiBrain:AssignUnitsToPlatoon(plat, {cdr}, 'support', 'None')
        plat:Stop()

        local priList = {categories.ENERGYPRODUCTION * categories.STRUCTURE * categories.DRAGBUILD, categories.TECH3 * categories.INDIRECTFIRE,
            categories.TECH3 * categories.MOBILE, categories.TECH2 * categories.INDIRECTFIRE, categories.MOBILE * categories.TECH2,
            categories.TECH1 * categories.INDIRECTFIRE, categories.TECH1 * categories.MOBILE, categories.CONSTRUCTION * categories.STRUCTURE, categories.ECONOMIC * categories.STRUCTURE, categories.ALLUNITS}
        plat:SetPrioritizedTargetList('support', priList)
        cdr:SetTargetPriorities(priList)

        local target
        local continueFighting = true
        local counter = 0
        local cdrThreat = cdr:GetBlueprint().Defense.SurfaceThreatLevel or 75
        local enemyThreat
        repeat
            overCharging = false
            local cdrCurrentPos = cdr:GetPosition()
            if counter >= 5 or not target or target.Dead or Utilities.XZDistanceTwoVectors(cdrPos, target:GetPosition()) > maxRadius then
                counter = 0
                for _, v in priList do
                    target = plat:FindClosestUnit('Support', 'Enemy', true, v)
                    if target and Utilities.XZDistanceTwoVectors(cdrPos, target:GetPosition()) < maxRadius then
                        local cdrLayer = cdr:GetCurrentLayer()
                        local targetLayer = target:GetCurrentLayer()
                        if not (cdrLayer == 'Land' and (targetLayer == 'Air' or targetLayer == 'Sub' or targetLayer == 'Seabed')) and
                           not (cdrLayer == 'Seabed' and (targetLayer == 'Air' or targetLayer == 'Water')) then
                            break
                        end
                    end
                    target = false
                end
                if target then
                    local targetPos = target:GetPosition()
                    enemyThreat = aiBrain:GetThreatAtPosition(targetPos, 1, true, 'AntiSurface')
                    enemyCdrThreat = aiBrain:GetThreatAtPosition(targetPos, 1, true, 'Commander')
                    friendlyThreat = aiBrain:GetThreatAtPosition(targetPos, 1, true, 'AntiSurface', aiBrain:GetArmyIndex())
                    if enemyThreat - enemyCdrThreat >= friendlyThreat + cdrThreat then
                        return
                    end
                    if aiBrain:GetEconomyStored('ENERGY') >= weapon.EnergyRequired and target and not target.Dead and Utilities.XZDistanceTwoVectors(cdrCurrentPos, target:GetPosition()) <= weapRange then
                        overCharging = true
                        IssueClearCommands({cdr})
                        IssueOverCharge({cdr}, target)
                    elseif target and not target.Dead then
                        local tarPos = target:GetPosition()
                        IssueClearCommands({cdr})
                        IssueMove({cdr}, tarPos)
                        IssueOverCharge({cdr}, target)
                        IssueMove({cdr}, cdr.CDRHome)
                    end
                elseif distressLoc then
                    enemyThreat = aiBrain:GetThreatAtPosition(distressLoc, 1, true, 'AntiSurface')
                    enemyCdrThreat = aiBrain:GetThreatAtPosition(distressLoc, 1, true, 'Commander')
                    friendlyThreat = aiBrain:GetThreatAtPosition(distressLoc, 1, true, 'AntiSurface', aiBrain:GetArmyIndex())
                    if enemyThreat - enemyCdrThreat >= friendlyThreat + (cdrThreat / 1.5) then
                        return
                    end
                    if distressLoc and (Utilities.XZDistanceTwoVectors(distressLoc, cdrPos) < distressRange) then
                        IssueClearCommands({cdr})
                        IssueMove({cdr}, distressLoc)
                        IssueMove({cdr}, cdr.CDRHome)
                    end
                end
            end
            if overCharging then
                while target and not target.Dead and not cdr.Dead and counter <= 5 do
                    WaitSeconds(0.5)
                    counter = counter + 0.5
                end
            else
                WaitSeconds(3)
                counter = counter + 0.5
            end

            distressLoc = aiBrain:BaseMonitorDistressLocation(cdrPos)
            if cdr.Dead then
                return
            end

            enemyThreat = aiBrain:GetThreatAtPosition(cdrPos, 1, true, 'AntiSurface')
            enemyCdrThreat = aiBrain:GetThreatAtPosition(cdrPos, 1, true, 'Commander')
            friendlyThreat = aiBrain:GetThreatAtPosition(cdrPos, 1, true, 'AntiSurface', aiBrain:GetArmyIndex())
            if ((aiBrain:GetNumUnitsAroundPoint(categories.LAND - categories.SCOUT, cdrPos, maxRadius, 'Enemy') == 0)
                and (not distressLoc or (Utilities.XZDistanceTwoVectors(distressLoc, cdrPos) > distressRange)
                and (Utilities.XZDistanceTwoVectors(cdr.CDRHome, cdr:GetPosition()) < maxRadius))) or enemyThreat - enemyCdrThreat >= friendlyThreat + (cdrThreat / 1.5) or (aiBrain:GetNumUnitsAroundPoint(categories.LAND - categories.SCOUT, cdrPos, maxRadius, 'Enemy')) >= 15 then
                continueFighting = false
            end
        until not continueFighting or not aiBrain:PlatoonExists(plat)

        cdr.Fighting = false
        IssueClearCommands({cdr})
        if overCharging then
            IssueMove({cdr}, cdr.CDRHome)
        end

        if cdr.UnitBeingBuiltBehavior then
            cdr:ForkThread(CDRFinishUnit)
        end
    end
end

function BehemothBehaviorTotal(self)
    AssignExperimentalPrioritiesSorian(self)

    -- Find target loop
    local experimental
    local targetUnit = false
    local lastBase = false
    local airUnit = false
    local useMove = true
    local farTarget = false
    local aiBrain = self:GetBrain()
    local platoonUnits = self:GetPlatoonUnits()
    local cmd 
    while aiBrain:PlatoonExists(self) do
        self:MergeWithNearbyPlatoonsSCTA('ExperimentalAIHubTA', 'ExperimentalAIHubTA', 50)
        useMove = InWaterCheck(self)
        if lastBase then
            targetUnit, lastBase = WreckBaseSorian(self, lastBase)
        end

        if not lastBase then
            targetUnit, lastBase = FindExperimentalTarget(self)
        end

        farTarget = false
        if targetUnit and SUtils.XZDistanceTwoVectorsSq(self:GetPlatoonPosition(), targetUnit:GetPosition()) >= 40000 then
            farTarget = true
        end

        if targetUnit then
            IssueClearCommands(platoonUnits)
            if useMove or not farTarget then
                cmd = ExpPathToLocation(aiBrain, self, 'Amphibious', targetUnit:GetPosition(), false)
            else
                cmd = ExpPathToLocation(aiBrain, self, 'Amphibious', targetUnit:GetPosition(), 'AttackMove')
            end
        end

        -- Walk to and kill target loop
        local nearCommander = CommanderOverrideCheckSorian(self)
        local ACUattack = false
        while aiBrain:PlatoonExists(self) and targetUnit and not targetUnit.Dead and useMove == InWaterCheck(self) and
        self:IsCommandsActive(cmd) and (nearCommander or ((farTarget and SUtils.XZDistanceTwoVectorsSq(self:GetPlatoonPosition(), targetUnit:GetPosition()) >= 40000) or
        (not farTarget and SUtils.XZDistanceTwoVectorsSq(self:GetPlatoonPosition(), targetUnit:GetPosition()) < 40000))) do
            self:MergeWithNearbyPlatoonsSCTA('ExperimentalAIHubTA', 'ExperimentalAIHubTA', 50)
            useMove = InWaterCheck(self)
            nearCommander = CommanderOverrideCheckSorian(self)

            if nearCommander and (nearCommander ~= targetUnit or
            (not ACUattack and SUtils.XZDistanceTwoVectorsSq(self:GetPlatoonPosition(), nearCommander:GetPosition()) < 40000)) then
                IssueClearCommands(platoonUnits)
                if useMove then
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

            if not airUnit then
                closestBlockingShield = GetClosestShieldProtectingTargetSorian(experimental, experimental)
            end
            closestBlockingShield = closestBlockingShield or GetClosestShieldProtectingTargetSorian(experimental, targetUnit)

            -- Kill shields loop
            local oldTarget = false
            while closestBlockingShield do
                oldTarget = oldTarget or targetUnit
                targetUnit = false
                self:MergeWithNearbyPlatoonsSCTA('ExperimentalAIHubTA', 'ExperimentalAIHubTA', 50)
                useMove = InWaterCheck(self)
                IssueClearCommands(platoonUnits)
                if useMove or SUtils.XZDistanceTwoVectorsSq(self:GetPlatoonPosition(), closestBlockingShield:GetPosition()) < 40000 then
                    cmd = ExpPathToLocation(aiBrain, self, 'Amphibious', closestBlockingShield:GetPosition(), false)
                else
                    cmd = ExpPathToLocation(aiBrain, self, 'Amphibious', closestBlockingShield:GetPosition(), 'AttackMove')
                end

                local farAway = true
                if SUtils.XZDistanceTwoVectorsSq(self:GetPlatoonPosition(), closestBlockingShield:GetPosition()) < 40000 then
                    farAway = false
                end

                -- Wait for shield to die loop
                while not closestBlockingShield.Dead and aiBrain:PlatoonExists(self) and useMove == InWaterCheck(self)
                and self:IsCommandsActive(cmd) do
                    self:MergeWithNearbyPlatoonsSCTA('ExperimentalAIHubTA', 'ExperimentalAIHubTA', 50)
                    useMove = InWaterCheck(self)
                    local targDistSq = SUtils.XZDistanceTwoVectorsSq(self:GetPlatoonPosition(), closestBlockingShield:GetPosition())
                    if (farAway and targDistSq < 40000) or (not farAway and targDistSq >= 40000) then
                        break
                    end
                    WaitSeconds(1)
                end

                closestBlockingShield = false
                for k, v in platoonUnits do
                    if not v.Dead then
                        experimental = v
                        break
                    end
                end

                if not airUnit then
                    closestBlockingShield = GetClosestShieldProtectingTargetSorian(experimental, experimental)
                end
                closestBlockingShield = closestBlockingShield or GetClosestShieldProtectingTargetSorian(experimental, oldTarget)
                WaitSeconds(1)
            end
            WaitSeconds(1)
        end
        WaitSeconds(1)
    end
end


function CommanderThreadSCTA(cdr, platoon)
    --LOG('cdr is '..cdr.UnitId)
    local WaitTaunt = 600 + Random(1, 600)
    local aiBrain = cdr:GetAIBrain()
    aiBrain:BuildScoutLocations()
    TAReclaim.TAAIRandomizeTaunt(aiBrain)
    SetCDRHome(cdr, platoon)
    while not cdr.Dead do
        -- Overcharge
        if not cdr.Dead and table.getn(cdr.EngineerBuildQueue) == 0 and cdr.BuildingUnit == false then CDRSCTADGun(aiBrain, cdr) end
        WaitTicks(1)

        -- Go back to base
        if not cdr.Dead then SCTACDRReturnHome(aiBrain, cdr) end
        WaitTicks(1)
        if not cdr:IsDead() and cdr:IsIdleState() then
            if not cdr.EngineerBuildQueue or table.getn(cdr.EngineerBuildQueue) == 0 then
                local pool = aiBrain:GetPlatoonUniquelyNamed('ArmyPool')
                aiBrain:AssignUnitsToPlatoon( pool, {cdr}, 'Unassigned', 'None' )
            elseif cdr.EngineerBuildQueue and table.getn(cdr.EngineerBuildQueue) != 0 then
                if not cdr.NotBuildingThread then
                    cdr.NotBuildingThread = cdr:ForkThread(platoon.WatchForNotBuilding)
                end             
            end
        end
        WaitTicks(1)        
        if not cdr.Dead and GetGameTimeSeconds() > WaitTaunt and (not aiBrain.LastVocTaunt or GetGameTimeSeconds() - aiBrain.LastVocTaunt > WaitTaunt) then
            SUtils.AIRandomizeTaunt(aiBrain)
            WaitTaunt = 600 + Random(1, 900)
        end
    end
end


function CDRSCTADGun(aiBrain, cdr)
    local weapBPs = cdr:GetBlueprint().Weapon
    local weapon
    for k, v in weapBPs do
        if v.Label == 'OverCharge' then
            weapon = v
            break
        end
    end

    local distressRange = 100
    local maxRadius = weapon.MaxRadius * 4.55
    local weapRange = weapon.MaxRadius
    cdr.UnitBeingBuiltBehavior = false

    local cdrPos = cdr.CDRHome
    local numUnits1 = aiBrain:GetNumUnitsAroundPoint(categories.LAND * categories.TECH1 - categories.SCOUT - categories.ENGINEER, cdrPos, maxRadius, 'Enemy')
    local numUnits2 = aiBrain:GetNumUnitsAroundPoint(categories.LAND * categories.TECH2 - categories.SCOUT - categories.ENGINEER, cdrPos, maxRadius, 'Enemy')
    local numUnits3 = aiBrain:GetNumUnitsAroundPoint(categories.LAND * categories.TECH3 - categories.SCOUT - categories.ENGINEER, cdrPos, maxRadius, 'Enemy')
    local numUnitsEng = aiBrain:GetNumUnitsAroundPoint(categories.ENGINEER * (categories.TECH1 + categories.TECH2 + categories.TECH3), cdrPos, maxRadius, 'Enemy')
    local numUnits4 = aiBrain:GetNumUnitsAroundPoint(categories.EXPERIMENTAL, cdrPos, maxRadius + 130, 'Enemy')
    local numStructs = aiBrain:GetNumUnitsAroundPoint(categories.STRUCTURE, cdrPos, maxRadius, 'Enemy')
    local numUnitsDF = aiBrain:GetNumUnitsAroundPoint(categories.DEFENSE * categories.STRUCTURE * categories.DIRECTFIRE - categories.TECH1, cdrPos, maxRadius + 50, 'Enemy')
    local numUnitsDF1 = aiBrain:GetNumUnitsAroundPoint(categories.DEFENSE * categories.STRUCTURE * categories.DIRECTFIRE * categories.TECH1, cdrPos, maxRadius + 30, 'Enemy')
    local numUnitsIF = aiBrain:GetNumUnitsAroundPoint(categories.DEFENSE * categories.STRUCTURE * categories.INDIRECTFIRE - categories.TECH1, cdrPos, maxRadius + 260, 'Enemy')
    local totalUnits = numUnits1 + numUnits2 + numUnits3 + numUnits4 + numStructs + numUnitsEng
    local distressLoc = aiBrain:BaseMonitorDistressLocation(cdrPos)

    if Utilities.XZDistanceTwoVectors(cdrPos, cdr:GetPosition()) > distressRange then
        return
    end

    local commanderResponse = false
    if distressLoc then
        local distressUnitsNaval = aiBrain:GetNumUnitsAroundPoint(categories.NAVAL, distressLoc, 40, 'Enemy')
        local distressUnitsAir = aiBrain:GetNumUnitsAroundPoint(categories.AIR * (categories.BOMBER + categories.GROUNDATTACK + categories.ANTINAVY), distressLoc, 30, 'Enemy')
        local distressUnitsexp = aiBrain:GetNumUnitsAroundPoint(categories.EXPERIMENTAL, distressLoc, 50, 'Enemy')
        if distressUnitsNaval > 0 then
            if cdr:HasEnhancement('NaniteTorpedoTube') and distressUnitsNaval < 5 and distressUnitsexp < 1 then
                commanderResponse = true
            else
                commanderResponse = false
            end
        elseif distressUnitsAir > 0 then
            commanderResponse = false
        elseif distressUnitsexp > 0 then
            commanderResponse = false
        elseif numUnits1 > 14 or numUnits2 > 9 or numUnits3 > 4 or numUnits4 > 0 or numUnitsDF > 0 or numUnitsIF > 0 or numUnitsDF1 > 2 then
            commanderResponse = false
        else
            commanderResponse = true
        end
    end

    local overCharging = false
    if (not cdr.DistressCall and distressLoc and commanderResponse and Utilities.XZDistanceTwoVectors(distressLoc, cdrPos) < distressRange) then
        CDRRevertPriorityChange(aiBrain, cdr)
        if cdr.UnitBeingBuilt then
            cdr.UnitBeingBuiltBehavior = cdr.UnitBeingBuilt
        end

        cdr.Fighting = true
        cdr.GoingHome = false
        cdr.Upgrading = false
        local plat = aiBrain:MakePlatoon('', '')
        aiBrain:AssignUnitsToPlatoon(plat, {cdr}, 'support', 'None')
        plat:Stop()

        local priList = {categories.ENERGYPRODUCTION * categories.STRUCTURE * categories.DRAGBUILD, categories.TECH3 * categories.INDIRECTFIRE,
            categories.TECH3 * categories.MOBILE, categories.TECH2 * categories.INDIRECTFIRE, categories.MOBILE * categories.TECH2,
            categories.TECH1 * categories.INDIRECTFIRE, categories.TECH1 * categories.MOBILE, categories.CONSTRUCTION * categories.STRUCTURE, categories.ECONOMIC * categories.STRUCTURE, categories.ALLUNITS}
        plat:SetPrioritizedTargetList('support', priList)
        cdr:SetTargetPriorities(priList)

        local target
        local continueFighting = true
        local counter = 0
        local cdrThreat = cdr:GetBlueprint().Defense.SurfaceThreatLevel or 75
        local enemyThreat
        repeat
            overCharging = false
            local cdrCurrentPos = cdr:GetPosition()
            if counter >= 5 or not target or target.Dead or Utilities.XZDistanceTwoVectors(cdrPos, target:GetPosition()) > maxRadius then
                counter = 0
                for _, v in priList do
                    target = plat:FindClosestUnit('Support', 'Enemy', true, v)
                    if target and Utilities.XZDistanceTwoVectors(cdrPos, target:GetPosition()) < maxRadius then
                        local cdrLayer = cdr:GetCurrentLayer()
                        local targetLayer = target:GetCurrentLayer()
                        if not (cdrLayer == 'Land' and (targetLayer == 'Air' or targetLayer == 'Sub' or targetLayer == 'Seabed')) and
                           not (cdrLayer == 'Seabed' and (targetLayer == 'Air' or targetLayer == 'Water')) then
                            break
                        end
                    end
                    target = false
                end
                if target then
                    local targetPos = target:GetPosition()
                    enemyThreat = aiBrain:GetThreatAtPosition(targetPos, 1, true, 'AntiSurface')
                    enemyCdrThreat = aiBrain:GetThreatAtPosition(targetPos, 1, true, 'Commander')
                    friendlyThreat = aiBrain:GetThreatAtPosition(targetPos, 1, true, 'AntiSurface', aiBrain:GetArmyIndex())
                    if enemyThreat - enemyCdrThreat >= friendlyThreat + cdrThreat then
                        return
                    end
                    if aiBrain:GetEconomyStored('ENERGY') >= weapon.EnergyRequired and target and not target.Dead and Utilities.XZDistanceTwoVectors(cdrCurrentPos, target:GetPosition()) <= weapRange then
                        overCharging = true
                        IssueClearCommands({cdr})
                        IssueOverCharge({cdr}, target)
                    elseif target and not target.Dead then
                        local tarPos = target:GetPosition()
                        IssueClearCommands({cdr})
                        IssueMove({cdr}, tarPos)
                        IssueOverCharge({cdr}, target)
                        IssueMove({cdr}, cdr.CDRHome)
                    end
                elseif distressLoc then
                    enemyThreat = aiBrain:GetThreatAtPosition(distressLoc, 1, true, 'AntiSurface')
                    enemyCdrThreat = aiBrain:GetThreatAtPosition(distressLoc, 1, true, 'Commander')
                    friendlyThreat = aiBrain:GetThreatAtPosition(distressLoc, 1, true, 'AntiSurface', aiBrain:GetArmyIndex())
                    if enemyThreat - enemyCdrThreat >= friendlyThreat + (cdrThreat / 1.5) then
                        return
                    end
                    if distressLoc and (Utilities.XZDistanceTwoVectors(distressLoc, cdrPos) < distressRange) then
                        IssueClearCommands({cdr})
                        IssueMove({cdr}, distressLoc)
                        IssueMove({cdr}, cdr.CDRHome)
                    end
                end
            end
            if overCharging then
                while target and not target.Dead and not cdr.Dead and counter <= 5 do
                    WaitSeconds(0.5)
                    counter = counter + 0.5
                end
            else
                WaitSeconds(3)
                counter = counter + 0.5
            end

            distressLoc = aiBrain:BaseMonitorDistressLocation(cdrPos)
            if cdr.Dead then
                return
            end

            enemyThreat = aiBrain:GetThreatAtPosition(cdrPos, 1, true, 'AntiSurface')
            enemyCdrThreat = aiBrain:GetThreatAtPosition(cdrPos, 1, true, 'Commander')
            friendlyThreat = aiBrain:GetThreatAtPosition(cdrPos, 1, true, 'AntiSurface', aiBrain:GetArmyIndex())
            if ((aiBrain:GetNumUnitsAroundPoint(categories.LAND - categories.SCOUT, cdrPos, maxRadius, 'Enemy') == 0)
                and (not distressLoc or (Utilities.XZDistanceTwoVectors(distressLoc, cdrPos) > distressRange)
                and (Utilities.XZDistanceTwoVectors(cdr.CDRHome, cdr:GetPosition()) < maxRadius))) or enemyThreat - enemyCdrThreat >= friendlyThreat + (cdrThreat / 1.5) or (aiBrain:GetNumUnitsAroundPoint(categories.LAND - categories.SCOUT, cdrPos, maxRadius, 'Enemy')) >= 15 then
                continueFighting = false
            end
        until not continueFighting or not aiBrain:PlatoonExists(plat)

        cdr.Fighting = false
        IssueClearCommands({cdr})
        if overCharging then
            IssueMove({cdr}, cdr.CDRHome)
        end

        if cdr.UnitBeingBuiltBehavior then
            cdr:ForkThread(CDRFinishUnit)
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
        aiBrain:AssignUnitsToPlatoon(plat, {cdr}, 'support', 'None')
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
        WaitSeconds(1)
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
            WaitSeconds(2)
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