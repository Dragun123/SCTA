local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local TAutils = '/mods/SCTA-master/lua/AI/TAEditors/TAAIInstantConditions.lua'
local MIBC = '/lua/editor/MiscBuildConditions.lua'
local TAPrior = import('/mods/SCTA-master/lua/AI/TAEditors/TAPriorityManager.lua')
local TASlow = '/mods/SCTA-master/lua/AI/TAEditors/TAAIUtils.lua'
STRUCTURE1 = (categories.STRUCTURE * categories.TECH1)
STRUCTURE2 = (categories.STRUCTURE * categories.TECH2)
STRUCTURE3 = (categories.STRUCTURE * categories.TECH3)

BuilderGroup {
    BuilderGroupName = 'SCTAAIEngineerMiscBuilder',
    BuildersType = 'EngineerBuilder',
    Builder {
        BuilderName = 'SCTAMissileTower',
        PlatoonTemplate = 'EngineerBuilderSCTA',
        PriorityFunction = TAPrior.HighTechEnergyProduction,
        Priority = 75,
        InstanceCount = 2,
        BuilderConditions = {
            { TASlow, 'HaveLessThanUnitsWithCategoryTA', { 10, categories.ANTIAIR * STRUCTURE1} }, 
            { TAutils, 'GreaterTAStorageRatio', { 0.2, 0.5}}, 
            --{ TAutils, 'EcoManagementTA', { 0.8, 0.8, } },
        },
        BuilderType = 'LandTA',
        BuilderData = {
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T1AADefense',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAMissileDefense',
        PlatoonTemplate = 'EngineerBuilderSCTA',
        PriorityFunction = TAPrior.UnitProduction,
        Priority = 75,
        InstanceCount = 1,
        BuilderConditions = {
            { TASlow, 'HaveLessThanUnitsWithCategoryTA', { 1, categories.ANTIMISSILE * STRUCTURE2} },
            { TAutils, 'GreaterThanEconEnergyTAEfficiency', {1.05 }},
        },
        BuilderType = 'LandTA',
        BuilderData = {
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T2MissileDefense',
                },
                Location = 'LocationType',
            }
        }
    },
    Builder {
        BuilderName = 'SCTAMissileDefense2',
        PlatoonTemplate = 'EngineerBuilderSCTA3',
        PriorityFunction = TAPrior.TechEnergyExist,
        Priority = 100,
        InstanceCount = 1,
        BuilderConditions = {
            { MIBC, 'GreaterThanGameTime', {1500} },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.ANTIMISSILE * STRUCTURE3} },
            { TAutils, 'GreaterThanEconEnergyTAEfficiency', {1.05 }},
        },
        BuilderType = 'T3TA',
        BuilderData = {
            ---NeedGuard = false,
            DesiresAssist = true,
            NumAssistees = 2,
            Construction = {
                BuildStructures = {
                    'T3StrategicMissileDefense',
                },
            }
        }
    },
    Builder {
        BuilderName = 'SCTALaser3Tower',
        PlatoonTemplate = 'EngineerBuilderSCTA23All',
        PriorityFunction = TAPrior.ProductionT3,
        Priority = 81,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 4, categories.DIRECTFIRE * STRUCTURE3} }, 
            { TAutils, 'GreaterTAStorageRatio', { 0.2, 0.5}}, 
            --{ TAutils, 'EcoManagementTA', { 0.8, 0.8, } },
        },
        BuilderType = 'NotACU',
        BuilderData = {
            ---NeedGuard = false,
            DesiresAssist = true,
            NumAssistees = 2,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T3GroundDefense',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAANTIAIR3Tower',
        PlatoonTemplate = 'EngineerBuilderSCTA23All',
        PriorityFunction = TAPrior.ProductionT3,
        Priority = 84,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 6, categories.ANTIAIR * STRUCTURE3} }, 
            { TAutils, 'GreaterTAStorageRatio', { 0.2, 0.5}}, 
            --{ TAutils, 'EcoManagementTA', { 0.8, 0.8, } },
        },
        BuilderType = 'NotACU',
        BuilderData = {
            ---NeedGuard = false,
            DesiresAssist = true,
            NumAssistees = 2,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T3AADefense',
                }
            }
        }
    },   
    Builder {
        BuilderName = 'SCTAStaging',
        PlatoonTemplate = 'EngineerBuilderSCTA',
        Priority = 52,
        PriorityFunction = TAPrior.UnitProduction,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.AIRSTAGINGPLATFORM} },
            { TAutils, 'GreaterTAStorageRatio', { 0.2, 0.5}}, 
        },
        BuilderType = 'LandTA',
        BuilderData = {
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T2AirStagingPlatform',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTA Defense Point 1',
        PlatoonTemplate = 'EngineerBuilderSCTAALL',
        Priority = 50,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 4, categories.ANTISHIELD * STRUCTURE1} }, 
            { MIBC, 'GreaterThanGameTime', {240} },
            { TAutils, 'GreaterTAStorageRatio', { 0.2, 0.5}}, 
        },
        BuilderType = 'NotACU',
        BuilderData = {
            Construction = {
                OrderedTemplate = true,
                NearBasePatrolPoints = false,
                BaseTemplateFile = '/mods/SCTA-master/lua/AI/TAMiscBaseTemplates/TATowerTemplates.lua',
                BaseTemplate = 'T1TowerTemplate',
                BuildClose = true,
                BuildStructures = {
                    'T1GroundDefense',
                    'Wall',
                    'Wall',
                    'Wall',
                    'Wall',
                    'Wall',
                    'Wall',
                    'Wall',
                    'Wall',
                },
            },
        }
    },
    Builder {
        BuilderName = 'SCTA Defensive Point 2',
        PlatoonTemplate = 'EngineerBuilderSCTA23All',
        Priority = 76,
        InstanceCount = 2,
        PriorityFunction = TAPrior.TechEnergyExist,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 8, categories.ANTISHIELD * STRUCTURE2} }, 
            { TAutils, 'GreaterTAStorageRatio', { 0.2, 0.5}}, 
        },
        BuilderType = 'NotACU',
        BuilderData = {
            Construction = {
                OrderedTemplate = true,
                NearBasePatrolPoints = false,
                BaseTemplateFile = '/mods/SCTA-master/lua/AI/TAMiscBaseTemplates/TA2TowerTemplates.lua',
                BaseTemplate = 'T2TowerTemplate',
                BuildClose = true,
                BuildStructures = {
                    'T2GroundDefense',
                    'Wall2',
                    'Wall2',
                    'Wall2',
                    'Wall2',
                    'Wall2',
                    'Wall2',
                    'Wall2',
                    'Wall2',
                },
            },
        }
    },
    Builder {
        BuilderName = 'SCTA Defensive Point 3',
        PlatoonTemplate = 'CommanderBuilderSCTADecoy',
        PlatoonAddBehaviors = { 'CommanderBehaviorSCTADecoy' },
        Priority = 125,
        InstanceCount = 2,
        PriorityFunction = TAPrior.GantryProduction,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 8, categories.ANTISHIELD * STRUCTURE3} }, 
            { TAutils, 'GreaterTAStorageRatio', { 0.2, 0.5}}, 
        },
        BuilderType = 'T3TA',
        BuilderData = {
            Construction = {
                NearBasePatrolPoints = false,
                BuildClose = true,
                BuildStructures = {
                    'T3RapidArtillery',
                },
            },
        }
    },
}