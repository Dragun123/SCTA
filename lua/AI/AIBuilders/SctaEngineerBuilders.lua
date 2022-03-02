local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local MIBC = '/lua/editor/MiscBuildConditions.lua'
local TAutils = '/mods/SCTA-master/lua/AI/TAEditors/TAAIInstantConditions.lua'
local TASlow = '/mods/SCTA-master/lua/AI/TAEditors/TAAIUtils.lua'
local TAPrior = import('/mods/SCTA-master/lua/AI/TAEditors/TAPriorityManager.lua')
SCOUTING = (categories.SCOUT * categories.MOBILE)
ENGINEER1 = (categories.ENGINEER * categories.TECH1)
ENGINEER2 = (categories.ENGINEER * categories.TECH2)
ENGINEER3 = (categories.ENGINEER * categories.TECH3)


BuilderGroup {
    BuilderGroupName = 'SCTAAIEngineerBuilder',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SCTAAi Factory Scout',
        PlatoonTemplate = 'T1LandScoutSCTA',
        Priority = 100,
        PriorityFunction = TAPrior.UnitProductionT1,
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'Scout', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'Scout' }},
            { TASlow, 'HaveLessThanUnitsWithCategoryTA', { 2, SCOUTING * categories.LAND} },
            { TAutils, 'EcoManagementTA', { 0.9, 0.5, } },
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SCTAAI T1 Air Scouts',
        PlatoonTemplate = 'T1AirScoutSCTA',
        PriorityFunction = TAPrior.UnitProductionT1,
        Priority = 110,
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'Scout', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'Scout' }},
            { TASlow, 'HaveLessThanUnitsWithCategoryTA', { 2, SCOUTING *  categories.AIR} },
            { TAutils, 'EcoManagementTA', { 0.75, 1.05, } },
        },
        BuilderType = 'Air',
    }, 
    Builder {
        BuilderName = 'SCTAAI T2 Air Scouts',
        PlatoonTemplate = 'T2AirScoutSCTA',
        Priority = 110,
        InstanceCount = 1,
        PriorityFunction = TAPrior.ProductionT3,
        DelayEqualBuildPlattons = {'Scout', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'Scout' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.TECH3 * categories.AIR * SCOUTING } },
            { TAutils, 'EcoManagementTA', { 0.75, 1.05, } },
        },
        BuilderType = 'Air',
    },
    Builder {
        BuilderName = 'SCTAAi Field Engineer',
        PlatoonTemplate = 'T2BuildFieldEngineerSCTA',
        Priority = 125, -- Top factory priority
        DelayEqualBuildPlattons = {'Field', 1},
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'Field' }},
            { TASlow, 'HaveLessThanUnitsWithCategoryTA', { 2, categories.FIELDENGINEER * categories.TECH2} }, -- Build engies until we have 4 of them.
        },
        BuilderType =  'KBot',
    },
    Builder {
        BuilderName = 'SCTAAi Factory Engineer',
        PlatoonTemplate = 'T1BuildEngineerSCTA',
        Priority = 150, -- Top factory priority
        PriorityFunction = TAPrior.UnitProductionT1,
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'Field', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'Field' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.LAND * ENGINEER1} }, -- Don't make tanks if we have lots of them.
        },
        BuilderType =  'Field',
    },
    Builder {
        BuilderName = 'SCTAAi Factory Engineer Early',
        PlatoonTemplate = 'T1BuildEngineerSCTAEarly',
        Priority = 450, -- Top factory priority
        --PriorityFunction = TAPrior.EarlyBO,
        BuilderConditions = {
            { MIBC, 'LessThanGameTime', {60} }, -- Don't make tanks if we have lots of them.
        },
        BuilderType =  'Land',
    },
    Builder {
        BuilderName = 'SCTAAi FactoryT2 Engineer',
        PlatoonTemplate = 'T2BuildEngineerSCTA',
        Priority = 180, -- Top factory priority
        PriorityFunction = TAPrior.UnitProduction,
        --DelayEqualBuildPlattons = {'T2Engineer', 1},
        InstanceCount = 2,
        BuilderConditions = {
            --{ UCBC, 'CheckBuildPlattonDelay', { 'T2Engineer' }},
            { TASlow, 'HaveLessThanUnitsWithCategoryTA', { 1, ENGINEER2 * categories.LAND - categories.FIELDENGINEER } }, -- Build engies until we have 4 of them.
        },
        BuilderType =  'Land',
    },
    Builder {
        BuilderName = 'SCTAAi AirFactory Engineer',
        PlatoonTemplate = 'T1BuildEngineerAirSCTA',
        Priority = 150,
        PriorityFunction = TAPrior.AirProduction,
        DelayEqualBuildPlattons = {'AirEngineer', 1},
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'AirEngineer' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 4, categories.AIR * ENGINEER1} }, -- Build engies until we have 4 of them.
        },
        BuilderType = 'Air',
    },
    Builder {
        BuilderName = 'SCTAAi AirFactoryT2 Engineer',
        PlatoonTemplate = 'T2BuildEngineerAirSCTA',
        Priority = 180,
        PriorityFunction = TAPrior.UnitProduction,
        --DelayEqualBuildPlattons = {'T2AirEngineer', 1},
        InstanceCount = 2,
        BuilderConditions = {
            --{ UCBC, 'CheckBuildPlattonDelay', { 'T2AirEngineer' }},
            { TASlow, 'HaveLessThanUnitsWithCategoryTA', { 1, categories.AIR * ENGINEER2} }, -- Build engies until we have 4 of them.
        },
        BuilderType = 'Air',
    }, 
----TECH3 Engineers
    Builder {
        BuilderName = 'SCTAAi FactoryT3 Engineer',
        PlatoonTemplate = 'T3BuildEngineerSCTA',
        Priority = 200, -- Top factory priority
        PriorityFunction = TAPrior.ProductionT3,
        DelayEqualBuildPlattons = {'T3Engineer', 1},
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'T3Engineer' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, ENGINEER3 * categories.HOVER} }, -- Build engies until we have 4 of them.
        },
        BuilderType = 'SpecHover',
    },
    Builder {
        BuilderName = 'SCTAAi FactoryT3 Engineer Air',
        PlatoonTemplate = 'T3BuildEngineerAirSCTA',
        Priority = 200, -- Top factory priority
        PriorityFunction = TAPrior.ProductionT3,
        DelayEqualBuildPlattons = {'T3Engineer', 1},
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'T3Engineer' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, ENGINEER3 * categories.AIR} }, -- Build engies until we have 4 of them.
        },
        BuilderType = 'SpecAir',
    },
---GANTRIES
    Builder {
        BuilderName = 'SCTAAi T2 Experimental',
        PlatoonTemplate = 'SCTAExperimental',
        Priority = 175,
        PriorityFunction = TAPrior.GantryProduction,
        InstanceCount = 2,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.GATE}},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.EXPERIMENTAL * categories.MOBILE} },
            { TAutils, 'EcoManagementTA', { 0.9, 0.75} },
        },
        BuilderType = 'Gate',
    },
    Builder {
        BuilderName = 'SCTA Decoy Commander',
        PlatoonTemplate = 'SCTADecoyCommander',
        PriorityFunction = TAPrior.GantryProduction,
        Priority = 150,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, categories.EXPERIMENTAL * categories.MOBILE}},
            { TAutils, 'EcoManagementTA', { 0.9, 0.75} },
        },
        BuilderType = 'Gate',
    },
}

----needFigureOutMassEco and KnowingHowPauseFactoriesForAi