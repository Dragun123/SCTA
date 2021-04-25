local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local EBC = '/lua/editor/EconomyBuildConditions.lua'
local SAI = '/lua/ScenarioPlatoonAI.lua'
local MIBC = '/lua/editor/MiscBuildConditions.lua'
local TBC = '/lua/editor/ThreatBuildConditions.lua'
local TAutils = '/mods/SCTA-master/lua/AI/TAEditors/TAAIInstantConditions.lua'
local TASlow = '/mods/SCTA-master/lua/AI/TAEditors/TAAIUtils.lua'
local PLANT = (categories.FACTORY * categories.TECH1)
local LAB = (categories.FACTORY * categories.TECH2)
local PLATFORM = (categories.FACTORY * categories.TECH3)
local FUSION = (categories.ENERGYPRODUCTION * (categories.TECH2 + categories.TECH3)) * categories.STRUCTURE
local TAPrior = import('/mods/SCTA-master/lua/AI/TAEditors/TAPriorityManager.lua')

BuilderGroup {
    BuilderGroupName = 'SCTAAIAirBuilder',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SCTAAI Factory Stealth',
        PlatoonTemplate = 'T2AirFighterSCTA',
        Priority = 115,
        BuilderConditions = { -- Only make inties if the enemy air is strong.
        { TAutils, 'EcoManagementTA', { 0.75, 0.9, 0.5, 0.5, } },
        },
        BuilderType = 'Air',
    },
    Builder {
        BuilderName = 'SCTAAI Factory Gunship',
        PlatoonTemplate = 'T2GunshipSCTA',
        Priority = 115,
        BuilderConditions = {
            { TASlow, 'HaveUnitsWithCategoryAndAllianceFalse', {0, categories.MOBILE * categories.AIR - categories.SCOUT - categories.BOMBER, 'Enemy'}},
            { TAutils, 'EcoManagementTA', { 0.75, 0.9, 0.5, 0.5, } },
        },
        BuilderType = 'Air',
    },
    Builder {
        BuilderName = 'SCTAAI Factory Intie',
        PlatoonTemplate = 'T1AirFighterSCTA',
        PriorityFunction = TAPrior.AirProduction,
        Priority = 95,
        BuilderConditions = { -- Only make inties if the enemy air is strong
        { TAutils, 'EcoManagementTA', { 0.75, 0.9, 0.5, 0.5, } },
        },
        BuilderType = 'Air',
    },  
    Builder {
        BuilderName = 'SCTAAI Factory Strategic',
        PlatoonTemplate = 'T3AirBomberSCTA',
        Priority = 110,
        PriorityFunction = TAPrior.ProductionT3,
        BuilderConditions = {
            { TASlow, 'HaveUnitsWithCategoryAndAllianceFalse', {0, categories.MOBILE * categories.AIR - categories.SCOUT - categories.BOMBER, 'Enemy'}},
            { TAutils, 'EcoManagementTA', { 0.75, 0.9, 0.5, 0.5, } },
        },
        BuilderType = 'Air',
    },
    Builder {
        BuilderName = 'SCTAAI Factory Bomber',
        PlatoonTemplate = 'T1AirBomberSCTA',
        Priority = 85,
        PriorityFunction = TAPrior.AirProduction,
        BuilderConditions = {
            { TASlow, 'HaveUnitsWithCategoryAndAllianceFalse', {0, categories.MOBILE * categories.AIR - categories.SCOUT - categories.BOMBER, 'Enemy'}},
            { TAutils, 'EcoManagementTA', { 0.75, 0.9, 0.5, 0.5, } },
        },
        BuilderType = 'Air',
    },     
    Builder {
        BuilderName = 'SCTAAirTransport',
        PlatoonTemplate = 'SCTATransport',
        Priority = 50,
        InstanceCount = 2,
        BuilderConditions = {
            { MIBC, 'GreaterThanGameTime', {900} },
            { MIBC, 'ArmyNeedsTransports', {} },
            { UCBC, 'LocationFactoriesBuildingLess', { 'LocationType', 2, 'TRANSPORTFOCUS' } },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 6, 'TRANSPORTFOCUS' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 2, 'TRANSPORTFOCUS' } },
            { TAutils, 'EcoManagementTA', { 0.75, 0.75, 0.5, 0.5, } },
        },
        BuilderType = 'Air',
    },     
}