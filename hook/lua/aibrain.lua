WARN('['..string.gsub(debug.getinfo(1).source, ".*\\(.*.lua)", "%1")..', line:'..debug.getinfo(1).currentline..'] * SCTAAI: offset aibrain.lua' )
--local TAReclaim = import('/mods/SCTA-master/lua/AI/TAEditors/TAAIUtils.lua')

SCTAAIBrainClass = AIBrain
AIBrain = Class(SCTAAIBrainClass) {
        OnSpawnPreBuiltUnits = function(self)
            if not self.SCTAAI then
                return SCTAAIBrainClass.OnSpawnPreBuiltUnits(self)
            end
            local per = ScenarioInfo.ArmySetup[self.Name].AIPersonality
            local resourceStructures = nil
            local initialUnits = nil
            local posX, posY = self:GetArmyStartPos()
    
            if string.find(per, 'arm') then
                resourceStructures = {'armmex', 'armmex', 'armmex', 'armmex'}
                initialUnits = {'armlab', 'armsolar', 'armsolar', 'armsolar', 'armsolar'}
            else
                resourceStructures = {'cormex', 'cormex', 'cormex', 'cormex'}
                initialUnits = {'corvp', 'corsolar', 'corsolar', 'corsolar', 'corsolar'}
            end
    
            if resourceStructures then
                -- Place resource structures down
                for k, v in resourceStructures do
                    local unit = self:CreateResourceBuildingNearest(v, posX, posY)
                end
            end
    
            if initialUnits then
                -- Place initial units down
                for k, v in initialUnits do
                    local unit = self:CreateUnitNearSpot(v, posX, posY)
                end
            end
    
            self.PreBuilt = true
        end,
       

        FormManagerSCTA = function(aiBrain)
            ---local aiBrain = self
            LOG('BEGINNING SCTA FORMMANAGER')
                aiBrain.SeaForm = 0
                aiBrain.StructureForm = 0
                aiBrain.Other = 0
                aiBrain.LandForm = 0
                aiBrain.AirForm = 0
                aiBrain.Scout = 0
            local checks = {
                SeaForm = 0,
                StructureForm = 0,
                Other = 0,
                LandForm = 0,
                AirForm = 0,
                Scout = 0,
            }
            local GetCurrentUnits = moho.aibrain_methods.GetCurrentUnits
            while (aiBrain.Result ~= 'defeat') do
                if aiBrain.SeaForm < 1 and checks.SeaForm < 1 then
                    aiBrain.SeaForm = GetCurrentUnits(aiBrain, (categories.NAVAL * categories.MOBILE) - categories.ENGINEER)
                    WaitTicks(1)
                    checks.SeaForm = checks.SeaForm + 5
                end
                if aiBrain.StructureForm > 3 and checks.StructureForm < 1 then
                    aiBrain.StructureForm = GetCurrentUnits(aiBrain, categories.STRUCTURE * (categories.CQUEMOV + categories.MASSFABRICATION))
                    WaitTicks(1)
                    checks.StructureForm = checks.StructureForm + 5
                end
                if aiBrain.Other < 1 and checks.Other < 1 then
                    aiBrain.Other = GetCurrentUnits(aiBrain, categories.EXPERIMENTAL * categories.MOBILE)
                    WaitTicks(1)
                    checks.Other = checks.Other + 10
                end
                if aiBrain.LandForm < 1 and checks.LandForm < 1 then
                    aiBrain.LandForm = GetCurrentUnits(aiBrain, (categories.LAND * categories.MOBILE) - categories.ENGINEER - categories.SCOUT)
                    WaitTicks(1)
                    checks.LandForm = checks.LandForm + 2
                end
                if aiBrain.AirForm < 1 and checks.AirForm < 1 then
                    aiBrain.AirForm = GetCurrentUnits(aiBrain, (categories.AIR * categories.MOBILE) - categories.ENGINEER - categories.SCOUT)
                    WaitTicks(1)
                    checks.AirForm = checks.AirForm + 3
                end
                if aiBrain.Scout < 1 and checks.Scout < 1 then
                    aiBrain.Scout = GetCurrentUnits(aiBrain, (categories.armpw + categories.corgator + (categories.SCOUT + categories.AMPHIBIOUS) - categories.ENGINEER - categories.EXPERIMENTAL))
                    WaitTicks(1)
                    checks.Scout = checks.Scout + 4
                end
                --[[LOG('formmanagerdata')
                LOG(repr(aiBrain.SeaForm))
                LOG(repr(aiBrain.StructureForm))
                LOG(repr(aiBrain.Other))
                LOG(repr(aiBrain.LandForm))
                LOG(repr(aiBrain.AirForm))
                LOG(repr(aiBrain.Scout))
                LOG('checks '..repr(checks))]]
                for k,v in checks do
                    checks[k] = checks[k] - 1
                end
                --LOG('checks '..repr(checks))
                WaitSeconds(2)
            end
        end,

    AddBuilderManagers = function(self, position, radius, baseName, useCenter)
        -- Only use this with AI-SCTAAI
         if not self.SCTAAI then
             return SCTAAIBrainClass.AddBuilderManagers(self, position, radius, baseName, useCenter)
         end
         --LOG('*templateManager', self.SCTAAI)
         self.BuilderManagers[baseName] = {
             FactoryManager = FactoryManager.CreateFactoryBuilderManager(self, baseName, position, radius, useCenter),
             PlatoonFormManager = PlatoonFormManager.CreatePlatoonFormManager(self, baseName, position, radius, useCenter),
             EngineerManager = EngineerManager.CreateEngineerManager(self, baseName, position, radius),
             MassConsumption = {
                Resources = {Units = {}, Drain = 0, },
                Units = {Units = {}, Drain = 0, },
                Defenses = {Units = {}, Drain = 0, },
                Upgrades = {Units = {}, Drain = 0, },
                Engineers = {Units = {}, Drain = 0, },
                TotalDrain = 0,
            },
            BuilderHandles = {},
             Position = position,
             BaseType = Scenario.MasterChain._MASTERCHAIN_.Markers[baseName].type or 'MAIN',
         }
         self.NumBases = self.NumBases + 1
         --self:InitializePlatoonBuildManager()
     end,

    OnCreateAI = function(self, planName)
        SCTAAIBrainClass.OnCreateAI(self, planName) 
        --LOG('Oncreate')
        if string.find(ScenarioInfo.ArmySetup[self.Name].AIPersonality, 'scta') then
            --LOG('* AI-SCTA: This is SCTA')
            self.SCTAAI = true
            --self.ForkThread(TAReclaim.MassFabManagerThreadSCTAI, self)
            ForkThread(self.FormManagerSCTA, self)
        end
    end,

    ForceManagerSort = function(self)
        if not self.SCTAAI then
            return SCTAAIBrainClass.ForceManagerSort(self)
        end
        for _, v in self.BuilderManagers do
            ----TAEngineerType
            v.EngineerManager:SortBuilderList('LandTA')
            v.EngineerManager:SortBuilderList('AirTA')
            v.EngineerManager:SortBuilderList('SeaTA')
            v.EngineerManager:SortBuilderList('T3TA')
            v.EngineerManager:SortBuilderList('FieldTA')
            v.EngineerManager:SortBuilderList('Command')
            ---TAFactoryType
            v.FactoryManager:SortBuilderList('KBot')
            v.FactoryManager:SortBuilderList('Vehicle')
            v.FactoryManager:SortBuilderList('Hover')
            v.FactoryManager:SortBuilderList('Air')
            v.FactoryManager:SortBuilderList('Seaplane')
            v.FactoryManager:SortBuilderList('Sea')
            v.FactoryManager:SortBuilderList('Gate')
            ---TAPlatoonFormers
            v.PlatoonFormManager:SortBuilderList('LandForm')
            v.PlatoonFormManager:SortBuilderList('AirForm')
            v.PlatoonFormManager:SortBuilderList('SeaForm')
            v.PlatoonFormManager:SortBuilderList('Scout')
            v.PlatoonFormManager:SortBuilderList('Other')
            v.PlatoonFormManager:SortBuilderList('StructureForm')
        end
    end,

    UnderEnergyThreshold = function(self)
        if not self.SCTAAI then
            return SCTAAIBrainClass.UnderEnergyThreshold(self)
        end
    end,

    OverEnergyThreshold = function(self)
        if not self.SCTAAI then
            return SCTAAIBrainClass.OverEnergyThreshold(self)
        end
    end,

    UnderMassThreshold = function(self)
        if not self.SCTAAI then
            return SCTAAIBrainClass.UnderMassThreshold(self)
        end
    end,

    OverMassThreshold = function(self)
        if not self.SCTAAI then
            return SCTAAIBrainClass.OverMassThreshold(self)
        end
    end,


    InitializeEconomyState = function(self)
        -- Only use this with AI-SCTAAI
        if not self.SCTAAI then
            return SCTAAIBrainClass.InitializeEconomyState(self)
        end
    end,
}