local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local TASlow = '/mods/SCTA-master/lua/AI/TAEditors/TAAIUtils.lua'
RAIDAIR = categories.armfig + categories.corveng + categories.GROUNDATTACK
RAIDER = categories.armpw + categories.corak + categories.armflash + categories.corgator
local BaseRestrictedArea, BaseMilitaryArea, BaseDMZArea, BaseEnemyArea = import('/mods/SCTA-master/lua/AI/TAEditors/TAAIInstantConditions.lua').TAGetMOARadii()
local TAPrior = import('/mods/SCTA-master/lua/AI/TAEditors/TAPriorityManager.lua')

BuilderGroup {
    BuilderGroupName = 'SCTAAIUniversalFormers',
    BuildersType = 'PlatoonFormBuilder', -- A PlatoonFormBuilder is for builder groups of units.
    Builder {
        BuilderName = 'SCTAAI Terrain',
        PlatoonTemplate = 'StrikeForceSCTATerrain', -- The platoon template tells the AI what units to include, and how to use them.
        Priority = 200,
        ---PlatoonAddPlans = { 'HighlightSCTAHuntAI' },
        InstanceCount = 2,
        BuilderType = 'LandForm',
        BuilderData = {
            Layer = 'Air',
            NeverGuardBases = true,
            NeverGuardEngineers = true,
            UseMoveOrder = true,
            UseFormation = 'AttackFormation',
        },        
        BuilderConditions = {          
        { TASlow, 'TAEnemyUnitsLessAtLocationRadius', { BaseEnemyArea, 'LocationType', 1, categories.COMMAND }},	
        { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', {1, categories.AMPHIBIOUS - categories.SCOUT - categories.ENGINEER} }, },
    },
    Builder {
        BuilderName = 'SCTAAI LAB',
        PlatoonTemplate = 'LABSCTA', -- The platoon template tells the AI what units to include, and how to use them.
        Priority = 150,
        InstanceCount = 3,
        BuilderType = 'Scout',
        BuilderData = {
            LocationType = 'LocationType',
            Lab = true,
            NeverGuardBases = true,
            NeverGuardEngineers = true,
            UseFormation = 'AttackFormation',
        },        
        BuilderConditions = { 
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', {1, RAIDER + (categories.AMPHIBIOUS - categories.COMMAND)} },
            { TASlow, 'TAEnemyUnitsLessAtLocationRadius', { BaseEnemyArea, 'LocationType', 1, categories.COMMAND }},	
        },
    },
    Builder {
        BuilderName = 'SCTAAI Air Hunt',
        PlatoonTemplate = 'LABSCTA',
        PlatoonAIPlan = 'HuntAirAISCTA',
        PriorityFunction = TAPrior.UnitProductionT1,
        Priority = 150,
        InstanceCount = 10,
        BuilderType = 'AirForm', 
        BuilderData = {
            Lab = true,
            NeverGuardBases = true,
            NeverGuardEngineers = true,
            UseFormation = 'AttackFormation',
        },     
        BuilderConditions = { 
            { TASlow, 'TAEnemyUnitsLessAtLocationRadius', { BaseEnemyArea, 'LocationType', 1, categories.ANTIAIR }},	
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', {1, categories.TECH1 * (categories.BOMBER + RAIDAIR)} },
        },
    },
    Builder {
        BuilderName = 'LV4Kbot',
        PlatoonTemplate = 'T4ExperimentalSCTA',
        PriorityFunction = TAPrior.GantryProduction,
        Priority = 10000,
        InstanceCount = 4,
        BuilderType = 'Other',
        BuilderConditions = {
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', {1, categories.EXPERIMENTAL * categories.MOBILE - categories.ENGINEER } },
         },
        BuilderData = {
            ThreatWeights = {
                TargetThreatType = 'Commander',
            },
            UseMoveOrder = true,
            PrioritizedCategories = { 'COMMAND', 'FACTORY -NAVAL', 'EXPERIMENTAL', 'MASSPRODUCTION', 'STRUCTURE -NAVAL' },
        },
    },
    Builder {
        BuilderName = 'SCTANukeAI',
        PlatoonTemplate = 'NuclearMissileSCTA',
        PriorityFunction = TAPrior.GantryProduction,
        Priority = 300,
        BuilderConditions = {
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', {1, categories.NUKE * categories.STRUCTURE * categories.TECH3} },
            },
        BuilderType = 'Other',
    },
    Builder {
        BuilderName = 'SCTAAntiNukeAI',
        PlatoonTemplate = 'AntiNuclearMissileSCTA',
        PriorityFunction = TAPrior.GantryProduction,
        Priority = 300,
        BuilderConditions = {
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', {1, categories.ANTIMISSILE * categories.STRUCTURE * categories.TECH3} },
            },
        BuilderType = 'Other',
    },
}

