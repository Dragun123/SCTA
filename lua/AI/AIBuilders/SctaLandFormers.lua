local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local EBC = '/lua/editor/EconomyBuildConditions.lua'
local SAI = '/lua/ScenarioPlatoonAI.lua'
local TAutils = '/mods/SCTA-master/lua/AI/TAEditors/TAAIInstantConditions.lua'
local TASlow = '/mods/SCTA-master/lua/AI/TAEditors/TAAIUtils.lua'
local MIBC = '/lua/editor/MiscBuildConditions.lua'
local TAPrior = import('/mods/SCTA-master/lua/AI/TAEditors/TAPriorityManager.lua')
local RAIDER = (categories.armpw + categories.corak + categories.armflash + categories.corgator)
local SPECIAL = (RAIDER + categories.EXPERIMENTAL + categories.ENGINEER + categories.SCOUT)
local GROUND = categories.MOBILE * categories.LAND
local TACATS = (categories.ANTISHIELD + categories.AMPHIBIOUS)
local RANGE = (categories.ARTILLERY + categories.SILO + categories.ANTIAIR + categories.SNIPER)


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
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', { 1, categories.SCOUT * categories.LAND * categories.MOBILE } },
         },
    },
    Builder {
        BuilderName = 'SCTAAI Laser',
        PlatoonTemplate = 'AttackForceSCTALaser', -- The platoon template tells the AI what units to include, and how to use them.
        Priority = 200,
        PriorityFunction = TAPrior.UnitProduction,
        InstanceCount = 25,
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
            { TAutils, 'GreaterEnergyStorageMaxTA', { 0.2 } },
        },
    },
---Defensive/MidGame Platoons
    Builder {
        BuilderName = 'SCTAAI Strike Force Early',
        PlatoonTemplate = 'StrikeForceSCTAEarly',
        PriorityFunction = TAPrior.UnitProductionT1, -- The platoon template tells the AI what units to include, and how to use them.
        Priority = 100,
        InstanceCount = 50,
        BuilderType = 'LandForm',
        BuilderData = {
            ThreatSupport = 25,
            NeverGuardBases = true,
            NeverGuardEngineers = true,
            UseMoveOrder = true,
            UseFormation = 'AttackFormation',
            LocationType = 'LocationType',
            ThreatWeights = {
            SecondaryTargetThreatType = 'StructuresNotMex',
            IgnoreStrongerTargetsRatio = 100.0,
            },
        },        
        BuilderConditions = {
            --{ UCBC, 'PoolGreaterAtLocation', { 'LocationType', 1, GROUND - SPECIAL - RANGE - TACATS}},
        },
    },
    Builder {
        BuilderName = 'SCTAAI Strike Mid',
        PlatoonTemplate = 'StrikeForceSCTAMid', -- The platoon template tells the AI what units to include, and how to use them.
        PriorityFunction = TAPrior.UnitProduction,
        Priority = 150,
        InstanceCount = 100,
        BuilderType = 'LandForm',
        BuilderData = {
            ThreatSupport = 50,
            UseMoveOrder = true,
            NeverGuardBases = false,
            NeverGuardEngineers = false,
            UseFormation = 'AttackFormation',
            LocationType = 'LocationType',
        },        
        BuilderConditions = {
        { MIBC, 'GreaterThanGameTime', {600} },
        --{ UCBC, 'PoolGreaterAtLocation', { 'LocationType', 4,  GROUND - SPECIAL - categories.BOMB}},
        },
    },
    Builder {
        BuilderName = 'SCTAAI Strike Endgame',
        PlatoonTemplate = 'StrikeForceSCTAEndgame', -- The platoon template tells the AI what units to include, and how to use them.
        PriorityFunction = TAPrior.StructureProductionT2,
        Priority = 250,
        InstanceCount = 200,
        BuilderType = 'LandForm',
        BuilderData = {
            ThreatSupport = 75,
            UseMoveOrder = true,
            NeverGuardBases = false,
            NeverGuardEngineers = false,
            UseFormation = 'AttackFormation',
            LocationType = 'LocationType',
            Energy = true,
            Sniper = true,
        },        
        BuilderConditions = {
            { MIBC, 'GreaterThanGameTime', {1200} },
            --{ UCBC, 'PoolGreaterAtLocation', { 'LocationType', 4,  GROUND - SPECIAL - categories.BOMB}},
        },
    },
    ----AggressivePlatoons
    Builder {
        BuilderName = 'SCTAAI Missile Hunt',
        PlatoonTemplate = 'LandRocketAttackSCTA', -- The platoon template tells the AI what units to include, and how to use them.
        --PlatoonAddPlans = { 'HighlightSCTAHuntAI' },
        Priority = 125,
        InstanceCount = 50,
        BuilderType = 'LandForm',
        BuilderData = {
            TAWeaponRange = 30, 
            ThreatSupport = 50,
            NeverGuardBases = true,
            NeverGuardEngineers = true,
            UseFormation = 'AttackFormation',
            LocationType = 'LocationType',
            AggressiveMove = true,
        ThreatWeights = {
            SecondaryTargetThreatType = 'StructuresNotMex',
            IgnoreStrongerTargetsRatio = 100.0,
            },
        },        
        BuilderConditions = {
            --{ UCBC, 'PoolGreaterAtLocation', { 'LocationType', 1, GROUND * RANGE} },
         },
    },
    Builder {
        BuilderName = 'SCTAAI Land Attack Mid',
        PlatoonTemplate = 'LandAttackSCTAMid', -- The platoon template tells the AI what units to include, and how to use them.
        PriorityFunction = TAPrior.UnitProductionT1, -- The platoon template tells the AI what units to include, and how to use them.
        --PlatoonAddPlans = { 'HighlightSCTAHuntAI' },
        Priority = 150,
        InstanceCount = 50,
        --DelayEqualBuildPlattons = 5,
        BuilderType = 'LandForm',
        BuilderData = {
            ThreatSupport = 75,
            TAWeaponRange = 30,
            NeverGuardBases = true,
            NeverGuardEngineers = true,
            UseFormation = 'AttackFormation',
            LocationType = 'LocationType',
            AggressiveMove = true,
        ThreatWeights = {
            SecondaryTargetThreatType = 'StructuresNotMex',
            IgnoreStrongerTargetsRatio = 100.0,
            },
        },        
        BuilderConditions = {
            --{ UCBC, 'PoolGreaterAtLocation', { 'LocationType', 4, GROUND * RANGE } },
            { MIBC, 'GreaterThanGameTime', {480} },
         },
    },
    Builder {
        BuilderName = 'SCTA Hover Strike Land',
        PlatoonTemplate = 'StrikeForceSCTAHover', -- The platoon template tells the AI what units to include, and how to use them.
        Priority = 200,
        InstanceCount = 25,
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
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', { 2,  categories.MOBILE * (categories.HOVER + categories.AMPHIBIOUS) - categories.COMMAND} },
         },
    },
}
