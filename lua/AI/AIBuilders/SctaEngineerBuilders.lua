local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local EBC = '/lua/editor/EconomyBuildConditions.lua'
local SAI = '/lua/ScenarioPlatoonAI.lua'
local MIBC = '/lua/editor/MiscBuildConditions.lua'
local FUSION = (categories.ENERGYPRODUCTION * (categories.TECH2 + categories.TECH3)) * categories.STRUCTURE
local TAutils = '/mods/SCTA-master/lua/AI/TAEditors/TAAIInstantConditions.lua'
local PLANT = (categories.FACTORY * categories.TECH1)
local LAB = (categories.FACTORY * categories.TECH2)
local PLATFORM = (categories.FACTORY * categories.TECH3)
local TAPrior = import('/mods/SCTA-master/lua/AI/TAEditors/TAPriorityManager.lua')


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
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.SCOUT * categories.LAND * categories.MOBILE} },
            { TAutils, 'EcoManagementTA', { 0.9, 0.5, } },
        },
        BuilderType = 'Land',
    },
    Builder {
        BuilderName = 'SCTAAI T1 Scouts',
        PlatoonTemplate = 'T1AirScoutSCTA',
        PriorityFunction = TAPrior.UnitProductionT1,
        Priority = 110,
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'Scout', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'Scout' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.MOBILE * categories.AIR * categories.SCOUT } },
            { TAutils, 'EcoManagementTA', { 0.75, 1.05, } },
        },
        BuilderType = 'Air',
    }, 
    Builder {
        BuilderName = 'SCTAAI T2 Scouts',
        PlatoonTemplate = 'T2AirScoutSCTA',
        Priority = 110,
        InstanceCount = 1,
        PriorityFunction = TAPrior.ProductionT3,
        DelayEqualBuildPlattons = {'Scout', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'Scout' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.MOBILE * categories.AIR * categories.SCOUT } },
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
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.FIELDENGINEER * categories.TECH2} }, -- Build engies until we have 4 of them.
        },
        BuilderType =  'Field',
    },
    Builder {
        BuilderName = 'SCTAAi Factory Engineer',
        PlatoonTemplate = 'T1BuildEngineerSCTA',
        Priority = 150, -- Top factory priority
       ---PriorityFunction = TAPrior.UnitProductionT1,
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'Field', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'Field' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.ENGINEER * categories.LAND * categories.TECH1 - categories.COMMAND } }, -- Don't make tanks if we have lots of them.
        },
        BuilderType =  'Field',
    },
    Builder {
        BuilderName = 'SCTAAi Factory Engineer Early',
        PlatoonTemplate = 'T1BuildEngineerSCTAEarly',
        Priority = 200, -- Top factory priority
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
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.ENGINEER * categories.TECH2 * categories.LAND - categories.FIELDENGINEER } }, -- Build engies until we have 4 of them.
        },
        BuilderType =  'Land',
    },
    Builder {
        BuilderName = 'SCTAAi AirFactory Engineer',
        PlatoonTemplate = 'T1BuildEngineerAirSCTA',
        Priority = 150,
       ---PriorityFunction = TAPrior.UnitProductionT1,
        DelayEqualBuildPlattons = {'AirEngineer', 1},
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'AirEngineer' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 4, categories.ENGINEER * categories.AIR * categories.TECH1} }, -- Build engies until we have 4 of them.
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
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.ENGINEER * categories.AIR * categories.TECH2} }, -- Build engies until we have 4 of them.
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
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.ENGINEER * categories.TECH3 * categories.HOVER} }, -- Build engies until we have 4 of them.
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
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.ENGINEER * categories.TECH3 * categories.AIR} }, -- Build engies until we have 4 of them.
        },
        BuilderType = 'SpecAir',
    },
---GANTRIES
    Builder {
        BuilderName = 'SCTAAi T2 Experimental',
        PlatoonTemplate = 'SCTAExperimental',
        Priority = 175,
        PriorityFunction = TAPrior.GantryUnitBuilding,
        InstanceCount = 1,
        BuilderConditions = {},
        BuilderType = 'Gate',
    },
    Builder {
        BuilderName = 'SCTA Decoy Commander',
        PlatoonTemplate = 'SCTADecoyCommander',
        PriorityFunction = TAPrior.GantryUnitBuildingDecoy,
        Priority = 150,
        InstanceCount = 1,
        BuilderConditions = {},
        BuilderType = 'Gate',
    },
}

----needFigureOutMassEco and KnowingHowPauseFactoriesForAi