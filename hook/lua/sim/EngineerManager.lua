WARN('['..string.gsub(debug.getinfo(1).source, ".*\\(.*.lua)", "%1")..', line:'..debug.getinfo(1).currentline..'] * SCTAAI: offset EngineerManager.lua' )

local PROTECTION = (categories.LAND * categories.MOBILE * categories.SILO - categories.ENGINEER)

SCTAEngineerManager = EngineerManager
EngineerManager = Class(SCTAEngineerManager) {
    Create = function(self, brain, lType, location, radius)
        if not brain.SCTAAI then
            return SCTAEngineerManager.Create(self, brain, lType, location, radius)
        end
        BuilderManager.Create(self,brain)
        if not lType or not location or not radius then
            error('*PLATOOM FORM MANAGER ERROR: Invalid parameters; requires locationType, location, and radius')
            return false
        end
        ---LOG('IEXIST')
        self.Location = location
        self.Radius = radius
        self.LocationType = lType
        self.ConsumptionUnits = {
            Engineers = { Category = categories.ENGINEER, Units = {}, UnitsList = {}, Count = 0, },
            Fabricators = { Category = categories.MASSFABRICATION * categories.STRUCTURE, Units = {}, UnitsList = {}, Count = 0, },
            Intel = { Category = categories.STRUCTURE * ( categories.SONAR + categories.RADAR + categories.OMNI) - categories.FACTORY, Units = {}, UnitsList = {}, Count = 0, },
            MobileIntel = { Category = categories.MOBILE - categories.ENGINEER, Units = {}, UnitsList = {}, Count = 0, },
        }
        local builderTypes = { 'AirTA', 'LandTA', 'SeaTA', 'T3TA', 'FieldTA', 'Command', }
        for k,v in builderTypes do
            self:AddBuilderType(v)
        end
        ---LOG(self.ConsumptionUnits)

    end,

    GetEngineerFactionIndex = function(self, engineer)
        if not self.Brain.SCTAAI then
            return SCTAEngineerManager.GetEngineerFactionIndex(self, engineer)
        end
        if EntityCategoryContains(categories.ARM, engineer) then
            return 6
        elseif EntityCategoryContains(categories.CORE, engineer) then
            return 7
        end
    end,
    
    LowMass = function(self)
        if not self.Brain.SCTAAI then
            return SCTAEngineerManager.LowMass(self)
        end
    end,

    LowEnergy = function(self)
        if not self.Brain.SCTAAI then
            return SCTAEngineerManager.LowEnergy(self)
        end
    end,

    TADelayAssign = function(manager, unit, delaytime)
        if unit.ForkedEngineerTask then
            KillThread(unit.ForkedEngineerTask)
        end
        unit.ForkedEngineerTask = unit:ForkThread(manager.TAWait, manager, delaytime or (math.random(8,28)))
    end,

    TAWait = function(unit, manager, ticks)
        coroutine.yield(ticks + 2)
        if not unit.Dead then
            if unit.bType then
            manager:TAAssignEngineerTask(unit, unit.bType)
            else 
            manager:AssignEngineerTask(unit)
            end
        end
    end,

    RemoveUnit = function(self, unit)
        if not self.Brain.SCTAAI then
            return SCTAEngineerManager.RemoveUnit(self, unit)
        end
        --[[local guards = unit:GetGuards()
        for k,v in guards do
            if not v.Dead and v.AssistPlatoon then
                if self.Brain:PlatoonExists(v.AssistPlatoon) then
                    v.AssistPlatoon:ForkThread(v.AssistPlatoon.TAEconAssistBody)
                else
                    v.AssistPlatoon = nil
                end
            end
        end]]

        local found = false
        for k,v in self.ConsumptionUnits do
            if EntityCategoryContains(v.Category, unit) then
                for num,sUnit in v.Units do
                    if sUnit.Unit == unit then
                        table.remove(v.Units, num)
                        table.remove(v.UnitsList, num)
                        v.Count = v.Count - 1
                        found = true
                        break
                    end
                end
            end
            if found then
                break
            end
        end
    end,

    UnitConstructionFinished = function(self, unit, finishedUnit)
        if not self.Brain.SCTAAI then
            return SCTAEngineerManager.UnitConstructionFinished(self, unit, finishedUnit)
        end
        if EntityCategoryContains(categories.FACTORY, finishedUnit) and finishedUnit:GetAIBrain():GetArmyIndex() == self.Brain:GetArmyIndex() then
            self.Brain.BuilderManagers[self.LocationType].FactoryManager:AddFactory(finishedUnit)
        end
        if finishedUnit:GetAIBrain():GetArmyIndex() == self.Brain:GetArmyIndex() then
            self:AddUnit(finishedUnit)
        end
        --[[local guards = unit:GetGuards()
        for k,v in guards do
            if not v.Dead and v.AssistPlatoon then
                if self.Brain:PlatoonExists(v.AssistPlatoon) then
                    v.AssistPlatoon:ForkThread(v.AssistPlatoon.TAEconAssistBody)
                else
                    v.AssistPlatoon = nil
                end
            end
        end]]
    end,

    GetNumCategoryBeingBuilt = function(self, category, engCategory)
        if not self.Brain.SCTAAI then
            return SCTAEngineerManager.GetNumCategoryBeingBuilt(self, category, engCategory)
        end
        return table.getn(self:TAGetEngineersBuildingCategory(category, engCategory))
    end,

    TAGetEngineersBuildingCategory = function(self, category, engCategory)
        local engs = self:GetUnits('Engineers', engCategory)
        local units = {}
        for k,v in engs do
            if not (v.Dead or v.UnitBeingBuilt.Dead) and v:IsUnitState('Building') and EntityCategoryContains(category, v.UnitBeingBuilt) then
            table.insert(units, v)
            end
        end
        return units
    end,

    TAGetEngineersWantingAssistance = function(self, category, engCategory)
        local testUnits = self:TAGetEngineersBuildingCategory(category, engCategory)
        local retUnits = {}
        for k,v in testUnits do
            if v.DesiresAssist and v.NumAssistees and not table.getn(v:GetGuards()) >= v.NumAssistees then
            table.insert(retUnits, v)
            end
        end
        return retUnits
    end,

    ForkEngineerTask = function(manager, unit)
        if not manager.Brain.SCTAAI then
            --LOG('*TABrain', manager.Brain.SCTAAI)
            return SCTAEngineerManager.ForkEngineerTask(manager, unit)
        end
        if unit.ForkedEngineerTask then
            KillThread(unit.ForkedEngineerTask)
            unit.ForkedEngineerTask = unit:ForkThread(manager.TAWait, manager, 2)
        else
            unit.ForkedEngineerTask = unit:ForkThread(manager.TAWait, manager, 18)
        end
    end,

    AddBuilder = function(self, builderData, locationType)
        if not self.Brain.SCTAAI then
            return SCTAEngineerManager.AddBuilder(self, builderData, locationType)
        end
        local newBuilder = Builder.CreateEngineerBuilder(self.Brain, builderData, locationType)
        if newBuilder:GetBuilderType() == 'Any' then
            for k,v in self.BuilderData do
                self:AddInstancedBuilder(newBuilder, k)
            end
            elseif newBuilder:GetBuilderType() == 'ACU' then
            --for __,v in self.BuilderData do
                self:AddInstancedBuilder(newBuilder, 'Command')
                self:AddInstancedBuilder(newBuilder, 'T3TA')
            --end
            elseif newBuilder:GetBuilderType() == 'NotACU' then
            --for __,v in self.BuilderData do
                self:AddInstancedBuilder(newBuilder, 'T3TA')
                self:AddInstancedBuilder(newBuilder, 'AirTA')
                self:AddInstancedBuilder(newBuilder, 'LandTA')
            --end
            elseif newBuilder:GetBuilderType() == 'OmniLand' then
            --for __,v in self.BuilderData do
                self:AddInstancedBuilder(newBuilder, 'T3TA')
                self:AddInstancedBuilder(newBuilder, 'LandTA')
            --end
            elseif newBuilder:GetBuilderType() == 'OmniAir' then
            --for __,v in self.BuilderData do
                self:AddInstancedBuilder(newBuilder, 'T3TA')
                self:AddInstancedBuilder(newBuilder, 'AirTA')
            --end
            elseif newBuilder:GetBuilderType() == 'OmniNaval' then
            --for __,v in self.BuilderData do
                self:AddInstancedBuilder(newBuilder, 'SeaTA')
                self:AddInstancedBuilder(newBuilder, 'T3TA')
            --end
        else
            self:AddInstancedBuilder(newBuilder)
        end
        return newBuilder
    end,

    AssignEngineerTask = function(self, unit)
        --LOG('*Brain', self.Brain.SCTAAI)
        --LOG('*Who', unit)
        if not self.Brain.SCTAAI then
            return SCTAEngineerManager.AssignEngineerTask(self, unit)
        end
        if unit.bType then
            ---in case it loops back shomehow
            return self:TAAssignEngineerTask(unit, unit.bType)
        else
            local bp = unit:GetBlueprint().Economy
                if bp.Land then
                    unit.bType = 'LandTA'
                    --return self:TAAssignEngineerTask(unit, 'LandTA')
                elseif bp.Air then
                    unit.bType = 'AirTA'
                    --return self:TAAssignEngineerTask(unit, 'AirTA')
                elseif bp.TECH3 then
                    unit.bType = 'T3TA'
                    --return self:TAAssignEngineerTask(unit, 'T3TA')
                elseif bp.Command then
                    unit.bType = 'Command'
                    --return self:TAAssignEngineerTask(unit, 'Command')
                elseif bp.Naval then
                    unit.bType = 'SeaTA'
                    --return self:TAAssignEngineerTask(unit, 'SeaTA')
                else
                    --_ALERT('TABrainEngineer', unit.bType)
                    ---if Inherit they are used as support engineers 
                    unit.bType = 'FieldTA'                
                end
                return self:TAAssignEngineerTask(unit, unit.bType)
            end
        end,


    TAAssignEngineerTask = function(self, unit, bType)
        ---LOG('*Brain', self.Brain.SCTAAI)   
        --unit.bType = bType
        ---meh eitherway this is such a pointless commenting. Oh yeah, modifying the assign via hooking has interesting and had to seperate it until two different types
        if unit.DesiresAssist then
        unit.DesiresAssist = nil
        unit.NumAssistees = nil
        end
        ----RealizingProper Assignment In DisbandPlatoon
        if unit.AssigningTask and not unit:IsIdleState() then
            self:TADelayAssign(unit, 48)
            return
        end
        local builder = self:GetHighestBuilder(bType, {unit})
        if builder and not unit.AssigningTask then
            unit.AssigningTask = true
            -- Fork off the platoon here
            local template = self:GetEngineerPlatoonTemplate(builder:GetPlatoonTemplate())
            local hndl = self.Brain:MakePlatoon(template[1], template[2])
            self.Brain:AssignUnitsToPlatoon(hndl, {unit}, 'Support', 'none')
            unit.PlatoonHandle = hndl

            --if EntityCategoryContains(categories.COMMAND, unit) then
            --LOG('*AI DEBUG: ARMY '..self.Brain.Nickname..': Engineer Manager Forming - '..builder.BuilderName..' - Priority: '..builder:GetPriority())
            --end

            --LOG('*AI DEBUG: ARMY ', repr(self.Brain:GetArmyIndex()),': Engineer Manager Forming - ',repr(builder.BuilderName),' - Priority: ', builder:GetPriority())
            hndl.PlanName = template[2]

            --If we have specific AI, fork that AI thread
            if builder:GetPlatoonAIFunction() then
                hndl:StopAI()
                local aiFunc = builder:GetPlatoonAIFunction()
                hndl:ForkAIThread(import(aiFunc[1])[aiFunc[2]])
            end
            if builder:GetPlatoonAIPlan() then
                hndl.PlanName = builder:GetPlatoonAIPlan()
                hndl:SetAIPlan(hndl.PlanName)
            end

            --If we have additional threads to fork on the platoon, do that as well.
            if builder:GetPlatoonAddPlans() then
                for papk, papv in builder:GetPlatoonAddPlans() do
                    hndl:ForkThread(hndl[papv])
                end
            end

            if builder:GetPlatoonAddFunctions() then
                for pafk, pafv in builder:GetPlatoonAddFunctions() do
                    hndl:ForkThread(import(pafv[1])[pafv[2]])
                end
            end

            if builder:GetPlatoonAddBehaviors() then
                for pafk, pafv in builder:GetPlatoonAddBehaviors() do
                    hndl:ForkThread(import('/lua/ai/AIBehaviors.lua')[pafv])
                end
            end

            hndl.Priority = builder:GetPriority()
            hndl.BuilderName = builder:GetBuilderName()

            hndl:SetPlatoonData(builder:GetBuilderData(self.LocationType))
            --LOG('*TABrain', self.Brain.Level2)
            if hndl.PlatoonData.TAEscort and not self.Brain.Level2 then
                ---LOG('*TABrain', self.Brain.Plants)
                --local Escort = self.Brain:GetUnitsAroundPoint((categories.LAND * categories.MOBILE * (categories.SILO + categories.DIRECTFIRE)) - categories.SCOUT - categories.corak - categories.armpw - categories.armflash - categories.corgator - categories.ENGINEER, unit:GetPosition(), 20, 'Ally')[1]
                ---This final major fish to fry in terms of ai working correctly
                ---the code here grabs nearest missile base TA Units (Relavent units are Storms, and the T1 AntiAir Mobile). And have them protect the engineeer
                ---This will protect the engineer from bombers and labs. 
                ---Experimenting with the location of the unit vs location of the manager
                local Escorts = self.Brain:GetUnitsAroundPoint(PROTECTION, self.Location, 25, 'Ally') 
                --return
                --local Escort = table.remove(Escort, Escort.Escorting)
                for _,Escort in Escorts do
                    if Escort and Escort.SCTAAIBrain and not Escort.Escorting then 
                    Escort.Escorting = true
                    self.Brain:AssignUnitsToPlatoon(hndl, {Escort}, 'Guard', 'none')
                    ---break here to ensure only first LEGAL option is the one grabbed 
                    break
                    --WaitSeconds(3)
                    --Escort.Escorting = nil
                    end
                end
            end

            if hndl.PlatoonData.DesiresAssist then
                unit.DesiresAssist = true
            end
            --[[if hndl.PlatoonData.Reclaimer then
                unit.TAReclaimer = true
                --LOG('*TABrain', unit.TAReclaimer)
            end]]
            --[[if hndl.PlatoonData.DesiresTAAssist and (self.Brain.Level2 or hndl.PlatoonData.Hydro) then
                ---LOG('*TABrain', self.Brain.Plants)
                --local Escort = self.Brain:GetUnitsAroundPoint((categories.LAND * categories.MOBILE * (categories.SILO + categories.DIRECTFIRE)) - categories.SCOUT - categories.corak - categories.armpw - categories.armflash - categories.corgator - categories.ENGINEER, unit:GetPosition(), 20, 'Ally')[1]
                ---This final major fish to fry in terms of ai working correctly
                ---the code here grabs nearest missile base TA Units (Relavent units are Storms, and the T1 AntiAir Mobile). And have them protect the engineeer
                ---This will protect the engineer from bombers and labs. 
                ---Experimenting with the location of the unit vs location of the manager
                local Escorts = self.Brain:GetUnitsAroundPoint(categories.ENGINEER - categories.COMMAND, self.Location, 25, 'Ally') 
                --return
                --local Escort = table.remove(Escort, Escort.Escorting)
                for _,Escort in Escorts do
                    if Escort and Escort.SCTAAIBrain and not Escort.Escorting then 
                    Escort.Escorting = true
                    self.Brain:AssignUnitsToPlatoon(hndl, {Escort}, 'Attack', 'none')
                    ---break here to ensure only first LEGAL option is the one grabbed 
                    break
                    --WaitSeconds(3)
                    --Escort.Escorting = nil
                    end
                end
            end]]

            if hndl.PlatoonData.NumAssistees then
                unit.NumAssistees = hndl.PlatoonData.NumAssistees
            end


            builder:StoreHandle(hndl)
            --unit.AssigningTask = nil
            return
        end
        --unit.AssigningTask = nil
        self:TADelayAssign(unit)
    end,
}