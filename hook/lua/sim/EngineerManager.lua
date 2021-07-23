WARN('['..string.gsub(debug.getinfo(1).source, ".*\\(.*.lua)", "%1")..', line:'..debug.getinfo(1).currentline..'] * SCTAAI: offset EngineerManager.lua' )

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
        unit.ForkedEngineerTask = unit:ForkThread(manager.TAWait, manager, delaytime or (math.random(10,30)))
    end,

    TAWait = function(unit, manager, ticks)
        coroutine.yield(ticks)
        if unit.bType and not unit.Dead then
            manager:TAAssignEngineerTask(unit, unit.bType)
        elseif not unit.Dead then
            manager:AssignEngineerTask(unit)
        end
    end,

    ForkEngineerTask = function(manager, unit)
        if not manager.Brain.SCTAAI then
            --LOG('*TABrain', manager.Brain.SCTAAI)
            return SCTAEngineerManager.ForkEngineerTask(manager, unit)
        end
        if unit.ForkedEngineerTask then
            KillThread(unit.ForkedEngineerTask)
            unit.ForkedEngineerTask = unit:ForkThread(manager.TAWait, manager, 3)
        else
            unit.ForkedEngineerTask = unit:ForkThread(manager.TAWait, manager, 20)
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
        unit.DesiresAssist = false
        unit.NumAssistees = nil
        unit.MinNumAssistees = nil
        if unit.bType then
            ---in case it loops back shomehow
            return self:TAAssignEngineerTask(unit, unit.bType)
        else
            if unit.AssigningTask and unit:IsIdleState() then
                unit.AssigningTask = nil
            elseif unit.AssigningTask and not unit:IsIdleState() then
                self:TADelayAssign(unit, 50)
                return
            end
            local bp = unit:GetBlueprint().Economy
                if bp.Land then
                    unit.bType = 'LandTA'
                    --return self:TAAssignEngineerTask(unit, 'LandTA')
                elseif bp.Air then
                    unit.bType = 'AirTA'
                    --return self:TAAssignEngineerTask(unit, 'AirTA')
                elseif bp.Naval then
                    unit.bType = 'SeaTA'
                    --return self:TAAssignEngineerTask(unit, 'SeaTA')
                elseif bp.TECH3 then
                    unit.bType = 'T3TA'
                    --return self:TAAssignEngineerTask(unit, 'T3TA')
                elseif bp.Command then
                    unit.bType = 'Command'
                    --return self:TAAssignEngineerTask(unit, 'Command')
                else
                    ---if Inherit they are used as support engineers 
                    unit.bType = 'FieldTA'                
                end
                return self:TAAssignEngineerTask(unit, unit.bType)
            end
        end,


    TAAssignEngineerTask = function(self, unit, bType)
        ---LOG('*Brain', self.Brain.SCTAAI)   
        --unit.bType = bType
        ---Kinda Amazing Did this all on my own yet no recgonization
        ---I mean all this effort, and Az spent like several hours working on it and no one shout out
        ---meh eitherway this is such a pointless commenting. Oh yeah, modifying the assign via hooking has interesting and had to seperate it until two different types
        if unit.AssigningTask and unit:IsIdleState() then
            unit.AssigningTask = nil
        elseif unit.AssigningTask and not unit:IsIdleState() then
            self:TADelayAssign(unit, 50)
            return
        end
        local builder = self:GetHighestBuilder(bType, {unit})
        if builder then
            unit.AssigningTask = true
            -- Fork off the platoon here
            local template = self:GetEngineerPlatoonTemplate(builder:GetPlatoonTemplate())
            local hndl = self.Brain:MakePlatoon(template[1], template[2])
            self.Brain:AssignUnitsToPlatoon(hndl, {unit}, 'Support', 'none')
            if bType == 'LandTA' and self.Brain.Plants < 6 then
                ---LOG('*TABrain', self.Brain.Plants)
                local Escort = self.Brain:GetUnitsAroundPoint(categories.LAND * categories.MOBILE * categories.SILO, unit:GetPosition(), 10, 'Ally')[1] 
                if Escort then 
                    self.Brain:AssignUnitsToPlatoon(hndl, {Escort}, 'Guard', 'none')
                end
            end
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

            if hndl.PlatoonData.DesiresAssist then
                unit.DesiresAssist = hndl.PlatoonData.DesiresAssist
            end

            if hndl.PlatoonData.NumAssistees then
                unit.NumAssistees = hndl.PlatoonData.NumAssistees
            end


            builder:StoreHandle(hndl)
            unit.AssigningTask = nil
            return
        end
        unit.AssigningTask = nil
        self:TADelayAssign(unit)
    end,
}