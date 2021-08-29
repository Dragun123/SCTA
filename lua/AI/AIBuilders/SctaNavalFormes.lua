local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local TASlow = '/mods/SCTA-master/lua/AI/TAEditors/TAAIUtils.lua'
local TAutils = '/mods/SCTA-master/lua/AI/TAEditors/TAAIInstantConditions.lua'
local TAPrior = import('/mods/SCTA-master/lua/AI/TAEditors/TAPriorityManager.lua')
TIDAL = (categories.cortide + categories.armtide)
SKY = categories.AIR * categories.MOBILE
NAVY = (categories.NAVAL * categories.MOBILE) - categories.ENGINEER

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
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', { 2, categories.LIGHTBOAT} },
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
        InstanceCount = 5,
        BuilderType = 'SeaForm',
        BuilderConditions = {
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', { 2, categories.LIGHTBOAT} },
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
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', { 2, categories.SUBMERSIBLE * NAVY} },
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
        Priority = 200,
        InstanceCount = 10,
        BuilderType = 'SeaForm',
        BuilderData = {
            LocationType = 'LocationType',
            UseFormation = 'AttackFormation',
            ThreatWeights = {
                IgnoreStrongerTargetsRatio = 100.0,
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
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', { 2,  NAVY - categories.TECH3} },
        },
    },
    Builder {
        BuilderName = 'SCTA Battleship Assault',
        PlatoonTemplate = 'SCTABattleshipNaval',
        PriorityFunction = TAPrior.ProductionT3,
        Priority = 150,
        InstanceCount = 5,
        BuilderType = 'SeaForm',
        BuilderData = {
            LocationType = 'LocationType',
            UseFormation = 'AttackFormation',
            ThreatWeights = {
                IgnoreStrongerTargetsRatio = 100.0,
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
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', { 1,  NAVY * categories.TECH3} },
        },
    },
    Builder {
        BuilderName = 'SCTAAI Bomber Attack Torpedo',
        PlatoonTemplate = 'SCTATorpedosBombers',
        PriorityFunction = TAPrior.NavalProduction,
        Priority = 200,
        InstanceCount = 10,
        BuilderType = 'SeaForm',
        BuilderData = {
        },        
        BuilderConditions = { 
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', { 2, SKY * categories.BOMBER * categories.ANTINAVY} },
            },
        },
    Builder {
        BuilderName = 'SCTAAI Air Naval Intercept',
        PlatoonTemplate = 'IntieAISCTAEnd',
        PriorityFunction = TAPrior.GantryConstruction,
        Priority = 110,
        InstanceCount = 5,
        PlatoonAddBehaviors = { 'SCTAAirUnitRefit' },                                   
        BuilderType = 'SeaForm',
        BuilderData = {
            Energy = true,
            Interceptor = true,
        },        
        BuilderConditions = { 
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', { 1, SKY * categories.ANTIAIR - categories.BOMBER - categories.GROUNDATTACK} },
        },
    },
    Builder {
        BuilderName = 'SCTA Hover Naval Strike',
        PlatoonTemplate = 'StrikeForceSCTAHover', -- The platoon template tells the AI what units to include, and how to use them.
        PriorityFunction = TAPrior.ProductionT3,
        Priority = 120,
        InstanceCount = 5,
        BuilderType = 'SeaForm',
        BuilderData = {
            LocationType = 'LocationType',
            Small = true,
            NeverGuardBases = false,
            NeverGuardEngineers = false,
            UseFormation = 'AttackFormation',
        },        
        BuilderConditions = {
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', { 2,  categories.MOBILE * categories.HOVER - categories.TRANSPORTFOCUS} },
         },
    },
    Builder {
        BuilderName = 'SCTA Aircraft Carrier',
        PlatoonTemplate = 'SCTAAirCarrier',
        PriorityFunction = TAPrior.AirCarrierExist,
        Priority = 111,
        InstanceCount = 2,
        BuilderConditions = {
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', { 1, categories.NAVALCARRIER} },
            },
        BuilderType = 'SeaForm',
    },
}