local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local MIBC = '/lua/editor/MiscBuildConditions.lua'
local TASlow = '/mods/SCTA-master/lua/AI/TAEditors/TAAIUtils.lua'
local TAutils = '/mods/SCTA-master/lua/AI/TAEditors/TAAIInstantConditions.lua'
local TAPrior = import('/mods/SCTA-master/lua/AI/TAEditors/TAPriorityManager.lua')
local TIDAL = (categories.cortide + categories.armtide)

BuilderGroup {
    BuilderGroupName = 'SCTANavalFormer',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'SCTA Scout Ships',
        PlatoonTemplate = 'SCTAPatrolBoatAttack',
        Priority = 150,
        InstanceCount = 4,
        BuilderType = 'SeaForm',
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 0, categories.LIGHTBOAT } },
         },
         BuilderData = {
            LocationType = 'LocationType',
            UseFormation = 'AttackFormation',
            ThreatWeights = {
                IgnoreStrongerTargetsRatio = 100.0,  #DUNCAN - uncommented, was 100
                PrimaryThreatTargetType = 'Naval',
                SecondaryThreatTargetType = 'Economy',
                SecondaryThreatWeight = 0.1,
                WeakAttackThreatWeight = 1,
                VeryNearThreatWeight = 10,
                NearThreatWeight = 5,
                MidThreatWeight = 1,
                FarThreatWeight = 1,
            },
        },
    },
    Builder {
        BuilderName = 'SCTA Hunt Ships',
        PlatoonTemplate = 'SCTAPatrolBoatHunt',
        PriorityFunction = TAPrior.NavalProduction,
        Priority = 125,
        InstanceCount = 25,
        BuilderType = 'SeaForm',
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 1, categories.LIGHTBOAT } },
         },
         BuilderData = {
            LocationType = 'LocationType',
            UseFormation = 'AttackFormation',
            ThreatWeights = {
                IgnoreStrongerTargetsRatio = 100.0,  #DUNCAN - uncommented, was 100
                PrimaryThreatTargetType = 'Naval',
                SecondaryThreatTargetType = 'Economy',
                SecondaryThreatWeight = 0.1,
                WeakAttackThreatWeight = 1,
                VeryNearThreatWeight = 10,
                NearThreatWeight = 5,
                MidThreatWeight = 1,
                FarThreatWeight = 1,
            },
        },
    },
    Builder {
        BuilderName = 'SCTA Sub Hunt Ships',
        PlatoonTemplate = 'SCTASubHunter',
        PriorityFunction = TAPrior.NavalProduction,
        Priority = 120,
        InstanceCount = 5,
        BuilderType = 'SeaForm',
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 1, categories.NAVAL * categories.SUBMERSIBLE * categories.MOBILE - categories.ENGINEER} },
         },
         BuilderData = {
            LocationType = 'LocationType',
            UseFormation = 'AttackFormation',
            ThreatWeights = {
                IgnoreStrongerTargetsRatio = 100.0,  #DUNCAN - uncommented, was 100
                PrimaryThreatTargetType = 'AntiSub',
                SecondaryThreatTargetType = 'Naval',
                SecondaryThreatWeight = 0.1,
                WeakAttackThreatWeight = 1,
                VeryNearThreatWeight = 10,
                NearThreatWeight = 5,
                MidThreatWeight = 1,
                FarThreatWeight = 1,
            },
        },
    },
    Builder {
        BuilderName = 'SCTA T1 Naval Assault',
        PlatoonTemplate = 'SCTANavalAssault',
        PriorityFunction = TAPrior.NavalProduction,
        Priority = 110,
        InstanceCount = 20,
        BuilderType = 'SeaForm',
        BuilderData = {
            LocationType = 'LocationType',
            UseFormation = 'AttackFormation',
            ThreatWeights = {
                IgnoreStrongerTargetsRatio = 100.0,  #DUNCAN - uncommented, was 100
                PrimaryThreatTargetType = 'Naval',
                SecondaryThreatTargetType = 'Economy',
                SecondaryThreatWeight = 0.1,
                WeakAttackThreatWeight = 1,
                VeryNearThreatWeight = 10,
                NearThreatWeight = 5,
                MidThreatWeight = 1,
                FarThreatWeight = 1,
            },
        },
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 2, categories.NAVAL * categories.MOBILE * categories.MOBILE - categories.ENGINEER } },
        },
    },
    Builder {
        BuilderName = 'SCTAAI Bomber Attack Torpedo',
        PlatoonTemplate = 'SCTATorpedosBombers',
        PriorityFunction = TAPrior.NavalProduction,
        Priority = 200,
        InstanceCount = 50,
        BuilderType = 'SeaForm',
        BuilderData = {
        },        
        BuilderConditions = { 
            --{ TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', { 1, SKY * categories.BOMBER} },
            },
        },
    Builder {
        BuilderName = 'SCTAAI Air Naval Intercept',
        PlatoonTemplate = 'IntieAISCTAEnd',
        PriorityFunction = TAPrior.GantryConstruction,
        Priority = 110,
        InstanceCount = 10,
        PlatoonAddBehaviors = { 'SCTAAirUnitRefit' },                              
        BuilderType = 'SeaForm',
        BuilderData = {
            LocationType = 'LocationType',
            Energy = true,
        },        
        BuilderConditions = { 
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 1,  (categories.ANTIAIR * categories.MOBILE * categories.AIR) - categories.BOMBER - categories.GROUNDATTACK} },
        },
    },
    Builder {
        BuilderName = 'SCTA Hover Naval Strike',
        PlatoonTemplate = 'StrikeForceSCTAHover', -- The platoon template tells the AI what units to include, and how to use them.
        PriorityFunction = TAPrior.ProductionT3,
        Priority = 120,
        InstanceCount = 25,
        BuilderType = 'SeaForm',
        BuilderData = {
            LocationType = 'LocationType',
            Small = true,
            NeverGuardBases = false,
            NeverGuardEngineers = false,
            UseFormation = 'AttackFormation',
        },        
        BuilderConditions = {
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', { 2,  categories.MOBILE * categories.HOVER} },
         },
    },
    Builder {
        BuilderName = 'SCTA Engineer Finish Navy',
        PlatoonTemplate = 'EngineerBuilderSCTANaval',
        PlatoonAIPlan = 'ManagerEngineerFindUnfinishedSCTA',
        Priority = 500,
        InstanceCount = 2,
        DelayEqualBuildPlattons = {'Unfinished', 2},
        BuilderConditions = {
            { TASlow, 'CheckBuildPlatoonDelaySCTA', { 'Unfinished' }},
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', { 1, categories.ENGINEER * categories.NAVAL} },
            { UCBC, 'UnfinishedUnits', { 'LocationType', categories.STRUCTURE}},
        },
        BuilderData = {
            Assist = {
                BeingBuiltCategories = {'STRUCTURE'},
                AssistLocation = 'LocationType',
                AssistUntilFinished = true,
                AssisteeType = 'Engineer',
                Time = 20,
            },
        },
        BuilderType = 'SeaForm',
    },
    Builder {
        BuilderName = 'SCTA Engineer Reclaim Energy Naval',
        PlatoonTemplate = 'EngineerBuilderSCTANaval',
        PriorityFunction = TAPrior.TechEnergyExist,
        PlatoonAIPlan = 'ReclaimStructuresAI',
        Priority = 111,
        InstanceCount = 8,
        BuilderConditions = {
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', { 1,  TIDAL}},
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', { 1,  categories.ENGINEER * categories.NAVAL} },
            { TAutils, 'LessMassStorageMaxTA',  { 0.3}},
            },
        BuilderData = {
            Location = 'LocationType',
            Reclaim = {'cortide, armtide,'},
            ReclaimTime = 30,
        },
        BuilderType = 'SeaForm',
    },
    Builder {
        BuilderName = 'SCTA Aircraft Carrier',
        PlatoonTemplate = 'SCTAAirCarrier',
        PriorityFunction = TAPrior.AirCarrierExist,
        Priority = 111,
        InstanceCount = 2,
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 0, categories.NAVALCARRIER} },
            },
        BuilderType = 'SeaForm',
    },
}