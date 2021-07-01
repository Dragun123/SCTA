local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local EBC = '/lua/editor/EconomyBuildConditions.lua'
local IBC = '/lua/editor/InstantBuildConditions.lua'
local TAutils = '/mods/SCTA-master/lua/AI/TAEditors/TAAIInstantConditions.lua'
local TASlow = '/mods/SCTA-master/lua/AI/TAEditors/TAAIUtils.lua'
local SAI = '/lua/ScenarioPlatoonAI.lua'
local MIBC = '/lua/editor/MiscBuildConditions.lua'
local FUSION = (categories.ENERGYPRODUCTION * (categories.TECH2 + categories.TECH3)) * categories.STRUCTURE
local TAPrior = import('/mods/SCTA-master/lua/AI/TAEditors/TAPriorityManager.lua')

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
            { UCBC, 'HaveLessThanUnitsWithCategory', { 10, categories.ANTIAIR * categories.TECH1 - categories.MOBILE} }, 
            { EBC, 'GreaterThanEconStorageRatio', { 0.5, 0.5}},
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
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.ANTIMISSILE * categories.TECH2} },
            { EBC, 'GreaterThanEconStorageRatio', { 0.35, 0.35}},
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
        Priority = 74,
        InstanceCount = 1,
        BuilderConditions = {
            { MIBC, 'GreaterThanGameTime', {1500} },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.ANTIMISSILE * categories.TECH3} },
            { TAutils, 'GreaterThanEconEnergyTAEfficiency', {1.05 }},
        },
        BuilderType = 'T3TA',
        BuilderData = {
            NeedGuard = false,
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
            { UCBC, 'HaveLessThanUnitsWithCategory', { 4, categories.DIRECTFIRE * categories.TECH3 - categories.MOBILE - categories.ANTIAIR} }, 
            { EBC, 'GreaterThanEconStorageRatio', { 0.15, 0.25}}, 
        },
        BuilderType = 'NotACU',
        BuilderData = {
            NeedGuard = false,
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
            { UCBC, 'HaveLessThanUnitsWithCategory', { 6, categories.ANTIAIR * categories.TECH3 - categories.MOBILE} }, 
            { EBC, 'GreaterThanEconStorageRatio', { 0.15, 0.25}}, 
        },
        BuilderType = 'NotACU',
        BuilderData = {
            NeedGuard = false,
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
        Priority = 57,
        PriorityFunction = TAPrior.UnitProduction,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.AIRSTAGINGPLATFORM} },
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
            { UCBC, 'HaveLessThanUnitsWithCategory', { 4, categories.ANTISHIELD * categories.TECH1 - categories.MOBILE } }, 
            { MIBC, 'GreaterThanGameTime', {240} },
            { EBC, 'GreaterThanEconStorageRatio', { 0.25, 0.5}},
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
            { UCBC, 'HaveLessThanUnitsWithCategory', { 8, categories.ANTISHIELD * categories.TECH2 - categories.MOBILE} }, 
            { EBC, 'GreaterThanEconStorageRatio', { 0.2, 0.5}}, 
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
            { UCBC, 'HaveLessThanUnitsWithCategory', { 8, categories.ANTISHIELD * categories.TECH3 - categories.MOBILE} }, 
            { EBC, 'GreaterThanEconStorageRatio', { 0.2, 0.5}}, 
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