local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local TAutils = '/mods/SCTA-master/lua/AI/TAEditors/TAAIInstantConditions.lua'
local TASlow = '/mods/SCTA-master/lua/AI/TAEditors/TAAIUtils.lua'
local TAPrior = import('/mods/SCTA-master/lua/AI/TAEditors/TAPriorityManager.lua')

BuilderGroup {
    BuilderGroupName = 'SCTAAINavalBuilder',
    BuildersType = 'FactoryBuilder',
    Builder {
        BuilderName = 'SCTAAi Factory Naval Engineer',
        PlatoonTemplate = 'T1EngineerSCTANaval',
       ---PriorityFunction = TAPrior.UnitProductionT1,
        Priority = 140, -- Top factory priority
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.NAVAL * categories.ENGINEER * categories.TECH1} }, -- Build engies until we have 4 of them.
        },
        BuilderType = 'Sea',
    },
    Builder {
        BuilderName = 'SCTAAi Factory Naval2 Engineer',
        PlatoonTemplate = 'T2EngineerSCTANaval',
        Priority = 145, -- Top factory priority
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.NAVAL * categories.ENGINEER * categories.TECH2} }, -- Build engies until we have 4 of them.
        },
        BuilderType = 'Sea',
    },
    --[[Builder {
        BuilderName = 'SCTAAI Factory AirCarrier Bomber',
        PlatoonTemplate = 'T3AirBomberSCTA',
        Priority = 150,
        InstanceCount = 1,
        PriorityFunction = TAPrior.AirCarrierExist,
        BuilderConditions = {
            { TASlow, 'TAHaveUnitsWithCategoryAndAllianceFalse', {0, categories.MOBILE * categories.AIR - categories.SCOUT - categories.BOMBER, 'Enemy'}},
            { TAutils, 'EcoManagementTA', { 0.75, 0.9} },
        },
        BuilderType = 'Air',
    },
    Builder {
        BuilderName = 'SCTAAI Factory AirCarrier Fighter',
        PlatoonTemplate = 'T2AirFighterSCTA',
        Priority = 150,
        InstanceCount = 1,
        PriorityFunction = TAPrior.AirCarrierExist,
        BuilderConditions = {
            { TAutils, 'EcoManagementTA', { 0.75, 0.9} },
        },
        BuilderType = 'Air',
    },]]
    Builder {
        BuilderName = 'SCTAAi Factory ScoutShip',
        PlatoonTemplate = 'T1ScoutShipSCTA',
        PriorityFunction = TAPrior.ScoutShipProduction,
        Priority = 110,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 4, categories.SCOUT * categories.NAVAL } },
            { TAutils, 'EcoManagementTA', { 0.75, 0.75} },
        },
        BuilderType = 'Sea',
    },
    Builder {
        BuilderName = 'SCTAAi Factory Hover',
        PlatoonTemplate = 'T1ScoutShipSCTA',
        PriorityFunction = TAPrior.ScoutShipProduction,
        Priority = 115,
        BuilderConditions = {
            { TASlow,   'TAAttackNaval', {true}},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 10, categories.SCOUT * categories.NAVAL } },
            { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 0, categories.xsl0103 + categories.ual0201, 'Enemy'}},	
            { TAutils, 'EcoManagementTA', { 0.75, 0.75} },
        },
        BuilderType = 'Sea',
    },
    Builder {
        BuilderName = 'SCTAAi FactoryT1 AntiSub',
        PlatoonTemplate = 'T1SubSCTA',
        PriorityFunction = TAPrior.NavalProduction,
       ---PriorityFunction = TAPrior.UnitProductionT1,
        Priority = 120,
        BuilderConditions = {
            { TASlow,   'TAAttackNaval', {true}},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 6, categories.SUBMERSIBLE  * categories.MOBILE - categories.ENGINEER} },
            { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 0, categories.SUBMERSIBLE * categories.MOBILE, 'Enemy'}},	
            { TAutils, 'EcoManagementTA', { 0.75, 0.75} },
        },
        BuilderType = 'Sea',
    },
    Builder {
        BuilderName = 'SCTAAi FactoryT2 AntiSub',
        PlatoonTemplate = 'T2SubSCTA',
        PriorityFunction = TAPrior.NavalProductionT2,
        Priority = 115,
        BuilderConditions = {
            { TASlow,   'TAAttackNaval', {true}},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 6, categories.SUBMERSIBLE * categories.MOBILE - categories.ENGINEER} },
            { UCBC, 'HaveUnitsWithCategoryAndAlliance', { true, 0, categories.SUBMERSIBLE * categories.MOBILE, 'Enemy'}},
            { TAutils, 'EcoManagementTA', { 0.9, 0.9} },
        },
        BuilderType = 'Sea',
    },
    Builder {
        BuilderName = 'SCTAAi Frigate Naval',
        PlatoonTemplate = 'T1FrigateSCTA',
        PriorityFunction = TAPrior.NavalProduction,
        Priority = 130,
        BuilderConditions = {
            { TASlow,   'TAAttackNaval', {true}},	
            { TASlow, 'TAHaveUnitRatioGreaterThanNavalT1', {categories.FRIGATE} }, 
            { TAutils, 'EcoManagementTA', { 0.9, 0.9} }, -- Stop after 10 facs have been built.
        },
        BuilderType = 'Sea',
    },
    Builder {
        BuilderName = 'SCTAAi Scout Naval',
        PlatoonTemplate = 'T1ScoutShipSCTA',
        PriorityFunction = TAPrior.NavalProduction,
        Priority = 120,
        ---InstanceCount = 3,
        BuilderConditions = {
            { TASlow,   'TAAttackNaval', {true}},	
            { TAutils, 'EcoManagementTA', { 0.9, 0.9} }, -- Stop after 10 facs have been built.
        },
        BuilderType = 'Sea',
    },
    Builder {
        BuilderName = 'SCTAAi Destroyer Naval',
        PlatoonTemplate = 'T2DestroyerSCTA',
        PriorityFunction = TAPrior.NavalProductionT2,
        Priority = 130,
        ------InstanceCount = 1,
        BuilderConditions = {
            { TASlow,   'TAAttackNaval', {true}},		
            { TASlow, 'TAHaveUnitRatioGreaterThanNaval', {categories.DESTROYER} }, -- Build engies until we have 4 of them.
            { TAutils, 'EcoManagementTA', { 0.9, 0.9} },
        },
        BuilderType = 'Sea',
    },
    Builder {
        BuilderName = 'SCTAAi AntiAir Naval',
        PlatoonTemplate = 'T2CrusSCTA',
        PriorityFunction = TAPrior.NavalProductionT2,
        Priority = 120,
        ---InstanceCount = 1,
        BuilderConditions = {
            { TASlow,    'TAAttackNaval', {true}},	
            { TASlow, 'TAHaveUnitRatioGreaterThanNaval', {categories.CRUISER} },
            { TAutils, 'EcoManagementTA', { 0.9, 0.9} },
        },
        BuilderType = 'Sea',
    },
    Builder {
        BuilderName = 'SCTAAi Battleship',
        PlatoonTemplate = 'BattleshipSCTA',
        PriorityFunction = TAPrior.ProductionT3,
        Priority = 150,
        BuilderConditions = {
            { TASlow,    'TAAttackNaval', {true}},
            { TASlow, 'TAHaveUnitRatioGreaterThanNavalT3', {categories.BATTLESHIP - categories.SILO} }, -- Stop after 10 facs have been built.
            { TAutils, 'EcoManagementTA', { 0.9, 0.9} },
        },
        BuilderType = 'Sea',
    },
    Builder {
        BuilderName = 'SCTAAi MissileShip',
        PlatoonTemplate = 'MissileshipSCTA',
        PriorityFunction = TAPrior.ProductionT3,
        Priority = 140,
        BuilderConditions = {
            { TASlow,    'TAAttackNaval', {true}},
            { TASlow, 'TAHaveUnitRatioGreaterThanNavalT3', {categories.BATTLESHIP * categories.SILO} }, -- Stop after 10 facs have been built.
            { TAutils, 'EcoManagementTA', { 0.9, 0.9} },
        },
        BuilderType = 'Sea',
    },
    Builder {
        BuilderName = 'SCTAAi Carrier',
        PlatoonTemplate = 'CarrySCTA',
        PriorityFunction = TAPrior.ProductionT3,
        Priority = 125,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.NAVALCARRIER } },
            { TAutils, 'EcoManagementTA', { 0.9, 0.9} },
        },
        BuilderType = 'Sea',
    },
}
