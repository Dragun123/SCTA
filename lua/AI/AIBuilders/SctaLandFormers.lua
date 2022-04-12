local TAutils = '/mods/SCTA-master/lua/AI/TAEditors/TAAIInstantConditions.lua'
local TASlow = '/mods/SCTA-master/lua/AI/TAEditors/TAAIUtils.lua'
local MIBC = '/lua/editor/MiscBuildConditions.lua'
local TAPrior = import('/mods/SCTA-master/lua/AI/TAEditors/TAPriorityManager.lua')
GROUND = categories.MOBILE * categories.LAND


BuilderGroup {
    BuilderGroupName = 'SCTAAILandFormers',
    BuildersType = 'PlatoonFormBuilder', -- A PlatoonFormBuilder is for builder groups of units.
    Builder {
        BuilderName = 'SCTAAI Land Scout',
        PlatoonTemplate = 'T1LandScoutFormSCTA',
        Priority = 125,
        InstanceCount = 2,
        BuilderType = 'Scout',
        BuilderData = {
            LocationType = 'LocationType',
            },
        BuilderConditions = {
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', { 1, categories.SCOUT * GROUND} },
         },
    },
    Builder {
        BuilderName = 'SCTAAI Laser',
        PlatoonTemplate = 'AttackForceSCTALaser', -- The platoon template tells the AI what units to include, and how to use them.
        Priority = 200,
        PriorityFunction = TAPrior.UnitProduction,
        InstanceCount = 10,
        --DelayEqualBuildPlattons = 5,
        BuilderType = 'LandForm',
        BuilderData = {
            TAWeaponRange = 30,
            ThreatSupport = 75,
            Energy = true,
            NeverGuardBases = false,
            NeverGuardEngineers = false,
            UseFormation = 'AttackFormation',
            LocationType = 'LocationType',
            AggressiveMove = true,
            ThreatWeights = {
            SecondaryTargetThreatType = 'StructuresNotMex',
            IgnoreStrongerTargetsRatio = 100.0,
            },
        },        
        BuilderConditions = {
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', { 2, GROUND * (categories.ANTISHIELD + categories.FIELDENGINEER)} },
            { TAutils, 'GreaterEnergyStorageMaxTA', { 0.1 } },
        },
    },
---Defensive/MidGame Platoons
    Builder {
        BuilderName = 'SCTAAI Strike Force',
        PlatoonTemplate = 'StrikeForceSCTA',
        PriorityFunction = TAPrior.UnitProductionT1, -- The platoon template tells the AI what units to include, and how to use them.
        Priority = 100,
        InstanceCount = 10,
        BuilderType = 'LandForm',
        BuilderData = {
            SearchRadius = 50,
            ThreatSupport = 25,
            NeverGuardBases = true,
            NeverGuardEngineers = true,
            UseMoveOrder = true,
            UseFormation = 'GrowthFormation',
            LocationType = 'LocationType',
            ThreatWeights = {
            SecondaryTargetThreatType = 'StructuresNotMex',
            IgnoreStrongerTargetsRatio = 100.0,
            },
        },        
        BuilderConditions = {
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', { 2, categories.DIRECTFIRE * GROUND - categories.ENGINEER} },
        },
    },
    Builder {
        BuilderName = 'SCTAAI Strike Force Mid',
        PlatoonTemplate = 'StrikeForceSCTA',
        PriorityFunction = TAPrior.UnitProduction, -- The platoon template tells the AI what units to include, and how to use them.
        Priority = 100,
        InstanceCount = 10,
        BuilderType = 'LandForm',
        BuilderData = {
            SearchRadius = 50,
            ThreatSupport = 25,
            NeverGuardBases = true,
            NeverGuardEngineers = true,
            UseMoveOrder = true,
            UseFormation = 'GrowthFormation',
            LocationType = 'LocationType',
            ThreatWeights = {
            SecondaryTargetThreatType = 'StructuresNotMex',
            IgnoreStrongerTargetsRatio = 100.0,
            },
        },        
        BuilderConditions = {
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', { 4, categories.DIRECTFIRE * GROUND - categories.ENGINEER} },
        },
    },
    Builder {
        BuilderName = 'SCTAAI Strike Force EndGame',
        PlatoonTemplate = 'StrikeForceSCTA',
        PriorityFunction = TAPrior.ProductionT3, -- The platoon template tells the AI what units to include, and how to use them.
        Priority = 100,
        InstanceCount = 10,
        BuilderType = 'LandForm',
        BuilderData = {
            SearchRadius = 50,
            ThreatSupport = 25,
            NeverGuardBases = true,
            NeverGuardEngineers = true,
            UseMoveOrder = true,
            UseFormation = 'GrowthFormation',
            LocationType = 'LocationType',
            ThreatWeights = {
            SecondaryTargetThreatType = 'StructuresNotMex',
            IgnoreStrongerTargetsRatio = 100.0,
            },
        },        
        BuilderConditions = {
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', { 8, categories.DIRECTFIRE * GROUND - categories.ENGINEER} },
        },
    },
    ----AggressivePlatoons
    Builder {
        BuilderName = 'SCTAAI Missile Hunt',
        PlatoonTemplate = 'LandRocketAttackSCTA', -- The platoon template tells the AI what units to include, and how to use them.
        --PlatoonAddPlans = { 'HighlightSCTAHuntAI' },
        Priority = 125,
        InstanceCount = 10,
        BuilderType = 'LandForm',
        BuilderData = {
            SearchRadius = 50,
            TAWeaponRange = 30, 
            ThreatSupport = 50,
            NeverGuardBases = true,
            NeverGuardEngineers = true,
            UseFormation = 'AttackFormation',
            LocationType = 'LocationType',
        ThreatWeights = {
            SecondaryTargetThreatType = 'StructuresNotMex',
            IgnoreStrongerTargetsRatio = 100.0,
            },
        },        
        BuilderConditions = {
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', { 1, (categories.SILO + categories.ARTILLERY + categories.SNIPER) * GROUND - categories.ENGINEER} },
         },
    },
    Builder {
        BuilderName = 'SCTA Hover Strike Land',
        PlatoonTemplate = 'StrikeForceSCTAHover', -- The platoon template tells the AI what units to include, and how to use them.
        Priority = 200,
        InstanceCount = 10,
        BuilderType = 'LandForm',
        BuilderData = {
            TAWeaponRange = 30,
            LocationType = 'LocationType',
            Small = true,
            NeverGuardBases = false,
            NeverGuardEngineers = false,
            UseFormation = 'AttackFormation',
        },        
        BuilderConditions = {
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', { 2,  GROUND * (categories.HOVER + categories.AMPHIBIOUS) - categories.COMMAND - categories.TRANSPORTFOCUS} },
         },
    },
}
