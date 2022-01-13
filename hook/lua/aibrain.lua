WARN('['..string.gsub(debug.getinfo(1).source, ".*\\(.*.lua)", "%1")..', line:'..debug.getinfo(1).currentline..'] * SCTAAI: offset aibrain.lua' )
--local TAReclaim = import('/mods/SCTA-master/lua/AI/TAEditors/TAAIUtils.lua')
local TAEco = import('/mods/SCTA-master/lua/AI/TAEditors/TAAIInstantConditions.lua').GreaterTAStorageRatio
local TANomic = import('/mods/SCTA-master/lua/AI/TAEditors/TAAIInstantConditions.lua').EcoManagementTA

SCTAAIBrainClass = AIBrain
AIBrain = Class(SCTAAIBrainClass) {
    VOSounds = {
        -- {timeout delay, default cue, observers}
        NuclearLaunchDetected =        {timeout = 1, bank = nil, obs = true},
        OnTransportFull =              {timeout = 1, bank = nil},
        OnFailedUnitTransfer =         {timeout = 10, bank = 'Computer_Computer_CommandCap_01298'},
        OnPlayNoStagingPlatformsVO =   {timeout = 5, bank = 'XGG_Computer_CV01_04756'},
        OnPlayBusyStagingPlatformsVO = {timeout = 5, bank = 'XGG_Computer_CV01_04755'},
        OnPlayCommanderUnderAttackVO = {timeout = 15, bank = 'Computer_Computer_Commanders_01314'},
        TECHAchievedTA = {timeout = 15,  bank = 'Computer_Computer_UnitRevalation_01370'},
    },

    ---base game unlock
    ---Computer_Computer_UnitRevalation_01370
    ---Computer_Computer_UnitRevalation_01372
    TECHTAchieve = function(self)
        self:PlayVOSound('TECHAchievedTA')
    --self:PlayVOSound('TECH3TAchieve', Sound {Bank = 'TA_Sound', Cue = 'VICTORY4'})
    end,

        OnSpawnPreBuiltUnits = function(self)
            if not self.SCTAAI then
                return SCTAAIBrainClass.OnSpawnPreBuiltUnits(self)
            end
            local per = ScenarioInfo.ArmySetup[self.Name].AIPersonality
            local resourceStructures = nil
            local initialUnits = nil
            local posX, posY = self:GetArmyStartPos()
    
            if string.find(self.TA, 'ARM') then
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
            --LOG('BEGINNING SCTA FORMMANAGER')
            --_ALERT('TABrain', aiBrain.SCTAAI)
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
                if aiBrain.LandForm < 1 and checks.LandForm < 1 then
                    aiBrain.LandForm = GetCurrentUnits(aiBrain, (categories.LAND * categories.MOBILE) - categories.ENGINEER - categories.SCOUT)
                    --WaitTicks(1)
                    coroutine.yield(2)
                    checks.LandForm = checks.LandForm + 2
                end
                if aiBrain.AirForm < 1 and checks.AirForm < 1 then
                    aiBrain.AirForm = GetCurrentUnits(aiBrain, (categories.AIR * categories.MOBILE) - categories.ENGINEER - categories.SCOUT)
                    --WaitTicks(1)
                    coroutine.yield(2)
                    checks.AirForm = checks.AirForm + 3
                end
                if aiBrain.SeaForm < 1 and checks.SeaForm < 1 and aiBrain.TANavy then
                    aiBrain.SeaForm = GetCurrentUnits(aiBrain, (categories.NAVAL * categories.MOBILE) - categories.ENGINEER)
                    --WaitTicks(1)
                    coroutine.yield(2)
                    checks.SeaForm = checks.SeaForm + 4
                end
                if aiBrain.StructureForm < 3 and checks.StructureForm < 1 and (aiBrain.Level2) then
                    aiBrain.StructureForm = GetCurrentUnits(aiBrain, categories.STRUCTURE * (categories.CQUEMOV + categories.MASSFABRICATION))
                    coroutine.yield(2)
                    checks.StructureForm = checks.StructureForm + 5
                    --if aiBrain.Rally < 10 then
                    --end
                end
                if aiBrain.Other < 1 and checks.Other < 1 and (aiBrain.Level3) then
                    aiBrain.Other = GetCurrentUnits(aiBrain, categories.EXPERIMENTAL * categories.MOBILE)
                    ---WaitTicks(1)
                    coroutine.yield(2)
                    checks.Other = checks.Other + 10
                    --if aiBrain.Rally < 20 then
                    --aiBrain.Rally = 20
                    --end
                end
                if aiBrain.Scout < 1 and checks.Scout < 1 then
                    aiBrain.Scout = GetCurrentUnits(aiBrain, (categories.armpw + categories.corgator + (categories.SCOUT + categories.AMPHIBIOUS) - categories.ENGINEER - categories.EXPERIMENTAL))
                    --WaitTicks(1)
                    coroutine.yield(2)
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
                --WaitSeconds(1.5)
                coroutine.yield(16)
                if aiBrain.Level3 and aiBrain.Other > 0 then
                    aiBrain:ForkThread(aiBrain.KillTAFormer)
                end
                --if aibrain.Scout >= 1 and aibrain.LandForm >= 1 and aibrain.LandForm >= 1
                ---will add a check in future if every AIBrain is greater than X kill the thread
            end
        end,

        KillTAFormer = function(aiBrain)
            if aiBrain.SCTAFormCounter then
                KillThread(aiBrain.SCTAFormCounter)
                aiBrain.SCTAFormCounter = nil
            end
        end,

        KillTAAssist = function(aiBrain)
            if aiBrain.TAAssistThread then
                KillThread(aiBrain.TAAssistThread)
                aiBrain.TAAssistThread = nil
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
            BuilderHandles = {},
             Position = position,
             BaseType = Scenario.MasterChain._MASTERCHAIN_.Markers[baseName].type or 'MAIN',
         }
         self.NumBases = self.NumBases + 1
         --self:InitializePlatoonBuildManager()
     end,

    OnCreateAI = function(self, planName) 
        --LOG('Oncreate')
        if string.find(ScenarioInfo.ArmySetup[self.Name].AIPersonality, 'scta') then
            --LOG('* AI-SCTA: This is SCTA')
            self.SCTAAI = true
            --self.ForkThread(TAReclaim.MassFabManagerThreadSCTAI, self)
            self.TARally = 5
            self.TAEcoCycle = 15
            if not self.SCTAFormCounter then
            self.SCTAFormCounter = ForkThread(self.FormManagerSCTA, self)
            end
            if not self.TAAssistThread then
            self.TAAssistThread = ForkThread(self.TAFactoryAssistThread, self)
            end
        end
        SCTAAIBrainClass.OnCreateAI(self, planName)
    end,

    --[[InitializePlatoonBuildManager = function(self)
        SCTAAIBrainClass.InitializePlatoonBuildManager(self)
        ALERT('SCTAPBMEXIST')
    end,]]

    TAFactoryAssistThread = function(aiBrain)
        while (aiBrain.Result ~= 'defeat') do
            WaitSeconds(aiBrain.TAEcoCycle)
            if ((aiBrain.Level2 or aiBrain.Level3) and TANomic(aiBrain, 0.75, 0.75)) or TANomic(aiBrain, 0.9, 0.5) then
                aiBrain.TAFactoryAssistance = true
            else
            coroutine.yield(2)
            aiBrain.TAFactoryAssistance = nil
            coroutine.yield(31)
            end
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
        --LOG('SCTAIEXIST1', self.SCTAAI)
        if not self.SCTAAI then
            return SCTAAIBrainClass.UnderEnergyThreshold(self)
        end
    end,

    OverEnergyThreshold = function(self)
        --LOG('SCTAIEXIST2', self.SCTAAI)
        if not self.SCTAAI then
            return SCTAAIBrainClass.OverEnergyThreshold(self)
        end
    end,

    UnderMassThreshold = function(self)
        --LOG('SCTAIEXIST3', self.SCTAAI)
        if not self.SCTAAI then
            return SCTAAIBrainClass.UnderMassThreshold(self)
        end
    end,

    OverMassThreshold = function(self)
        --LOG('SCTAIEXIST4', self.SCTAAI)
        if not self.SCTAAI then
            return SCTAAIBrainClass.OverMassThreshold(self)
        end
    end,


    InitializeEconomyState = function(self)
        -- Only use this with AI-SCTAAI
        --LOG('SCTAIEXIST', self.SCTAAI)
        if not self.SCTAAI then
            --LOG('SCTAIEXIST', self.SCTAAI)
            return SCTAAIBrainClass.InitializeEconomyState(self)
        end
    end,

    OnDefeat = function(self)
        SCTAAIBrainClass.OnDefeat(self)
        if self.SCTAAI then
        self.Labs = nil
        self.Plants = nil
        self.Level2 = nil
        self.Level3 = nil
        self.TA = nil
        self.TARally = nil
            if self.SCTAFormCounter then
                self:ForkThread(self.KillTAFormer, self)
            end
            if self.TAAssistThread then
                self:ForkThread(self.KillTAAssist, self)
            end
        end
    end, 
}