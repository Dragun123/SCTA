local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local TASlow = '/mods/SCTA-master/lua/AI/TAEditors/TAAIUtils.lua'
local MIBC = '/lua/editor/MiscBuildConditions.lua'
local TAutils = '/mods/SCTA-master/lua/AI/TAEditors/TAAIInstantConditions.lua'
local TAPrior = import('/mods/SCTA-master/lua/AI/TAEditors/TAPriorityManager.lua')

BuilderGroup {
    BuilderGroupName = 'SCTAAIT3Builder',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SCTAAi FactoryT3 HoverTank',
        PlatoonTemplate = 'T3LandHOVERSCTA',
        Priority = 125,
        PriorityFunction = TAPrior.ProductionT3,
        DelayEqualBuildPlattons = {'FactoryProductionSCTA', 1},
        BuilderConditions = {
        { UCBC, 'CheckBuildPlattonDelay', { 'FactoryProductionSCTA' }},
            { TAutils, 'EcoManagementTA', { 0.75, 0.5, } },
        },
        BuilderType = 'Hover',
    },
    Builder {
        BuilderName = 'SCTAAi FactoryT3 Hover Artillery',
        PlatoonTemplate = 'T3HOVERMISSILESCTA', 
        Priority = 140,
        PriorityFunction = TAPrior.ProductionT3,
        InstanceCount = 1,
        --DelayEqualBuildPlattons = 3,
        DelayEqualBuildPlattons = {'ArtillerySCTA', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'ArtillerySCTA' }},
            { TASlow, 'TAHaveUnitRatioGreaterThanLand', {categories.SILO - categories.ANTIAIR} },
            { TAutils, 'EcoManagementTA', { 0.75, 0.5} },
    },
        BuilderType = 'Hover',
    },
    Builder {
        BuilderName = 'SCTAAi FactoryT3 Hover AntiAir',
        PlatoonTemplate = 'T3HOVERAASCTA',
        Priority = 145,
        PriorityFunction = TAPrior.ProductionT3,
        InstanceCount = 2,
        DelayEqualBuildPlattons = {'AntiAirSCTA', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'AntiAirSCTA' }},
            { TASlow, 'TAHaveUnitRatioGreaterThanLand', {categories.ANTIAIR} },
            { TAutils, 'EcoManagementTA', { 0.75, 0.5} },
        },
        BuilderType = 'Hover',
    },
    --[[Builder {
        BuilderName = 'SCTAAi FactoryT3 Hover Transport',
        PlatoonTemplate = 'T3HOVERTransportSCTA',
        Priority = 50,
        PriorityFunction = TAPrior.ProductionT3,
        BuilderConditions = {
            { MIBC, 'ArmyNeedsTransports', {} },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 6, categories.TRANSPORTFOCUS} },
            { TAutils, 'EcoManagementTA', { 0.75, 0.5} },
        },
        BuilderType = 'Hover',
    },]]
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