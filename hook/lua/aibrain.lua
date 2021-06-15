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