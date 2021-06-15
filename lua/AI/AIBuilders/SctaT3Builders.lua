local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local EBC = '/lua/editor/EconomyBuildConditions.lua'
local TASlow = '/mods/SCTA-master/lua/AI/TAEditors/TAAIUtils.lua'
local MIBC = '/lua/editor/MiscBuildConditions.lua'
local SAI = '/lua/ScenarioPlatoonAI.lua'
local TBC = '/lua/editor/ThreatBuildConditions.lua'
local TAutils = '/mods/SCTA-master/lua/AI/TAEditors/TAAIInstantConditions.lua'
local TAPrior = import('/mods/SCTA-master/lua/AI/TAEditors/TAPriorityManager.lua')

BuilderGroup {
    BuilderGroupName = 'SCTAAIT3Builder',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SCTAAi FactoryT3 HoverTank',
        PlatoonTemplate = 'T3LandHOVERSCTA',
        Priority = 150,
        PriorityFunction = TAPrior.ProductionT3,
        BuilderConditions = {
            { TAutils, 'EcoManagementTA', { 0.9, 0.5, } },
        },
        BuilderType = 'Hover',
    },
    Builder {
        BuilderName = 'SCTAAi FactoryT3 Hover Artillery',
        PlatoonTemplate = 'T3HOVERMISSILESCTA', 
        Priority = 120,
        PriorityFunction = TAPrior.ProductionT3,
        InstanceCount = 1,
        --DelayEqualBuildPlattons = 3,
        BuilderConditions = {
            { TASlow, 'TAHaveUnitRatioGreaterThanLand', {categories.SILO - categories.ANTIAIR} },
            { TAutils, 'EcoManagementTA', { 0.75, 0.9} },
    },
        BuilderType = 'Hover',
    },
    Builder {
        BuilderName = 'SCTAAi FactoryT3 Hover AntiAir',
        PlatoonTemplate = 'T3HOVERAASCTA',
        Priority = 130,
        PriorityFunction = TAPrior.ProductionT3,
        BuilderConditions = {
            { TASlow, 'TAHaveUnitRatioGreaterThanLand', {categories.ANTIAIR} },
            { TAutils, 'EcoManagementTA', { 0.75, 0.9} },
        },
        BuilderType = 'Hover',
    },
    Builder {
        BuilderName = 'SCTAAi FactoryT3 Hover Transport',
        PlatoonTemplate = 'T3HOVERTransportSCTA',
        Priority = 50,
        PriorityFunction = TAPrior.ProductionT3,
        BuilderConditions = {
            { MIBC, 'ArmyNeedsTransports', {} },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 6, categories.TRANSPORTFOCUS} },
            { TAutils, 'EcoManagementTA', { 0.75, 0.9} },
        },
        BuilderType = 'Hover',
    },
    Builder {
        BuilderName = 'SCTAAI Factory Seaplane Fighter',
        PlatoonTemplate = 'T3AirFighterSCTA',
        PriorityFunction = TAPrior.ProductionT3,
        Priority = 140,
        BuilderConditions = { -- Only make inties if the enemy air is strong.
        { TAutils, 'EcoManagementTA', { 0.75, 0.9} },
        },
        BuilderType = 'Seaplane',
    },
    Builder {
        BuilderName = 'SCTAAI Factory Seaplane Torpedo',
        PlatoonTemplate = 'SCTATorpedosBomberT3',
        PriorityFunction = TAPrior.NavalProductionT2,
        Priority = 140,
        BuilderConditions = { -- Only make inties if the enemy air is strong.
        { TAutils, 'EcoManagementTA', { 0.75, 0.9} },
        },
        BuilderType = 'Seaplane',
    },
}