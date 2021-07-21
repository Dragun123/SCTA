
local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local TASlow = '/mods/SCTA-master/lua/AI/TAEditors/TAAIUtils.lua'
local TAutils = '/mods/SCTA-master/lua/AI/TAEditors/TAAIInstantConditions.lua'
local MIBC = '/lua/editor/MiscBuildConditions.lua'
LAB = (categories.FACTORY * categories.TECH2)
PLATFORM = (categories.FACTORY * categories.TECH3)
FUSION = (categories.ENERGYPRODUCTION - categories.TECH1)
local TAPrior = import('/mods/SCTA-master/lua/AI/TAEditors/TAPriorityManager.lua')



BuilderGroup {
    BuilderGroupName = 'SCTAAIFactoryBuilders',
    BuildersType = 'EngineerBuilder',
    ----BotsFacts
    Builder {
        BuilderName = 'SCTAAI T1Engineer LandFac',
        PlatoonTemplate = 'EngineerBuilderSCTA',
        PriorityFunction = TAPrior.UnitProductionT1Fac,
        Priority = 110,
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'Factory', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'Factory' }},
            { MIBC, 'GreaterThanGameTime', { 90 } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 2, categories.FACTORY} },
            { TASlow, 'TAFactoryCapCheckT1', {}},
            { TAutils, 'EcoManagementTA', { 0.75, 0.75} },
        },
        BuilderType = 'LandTA',
        BuilderData = {
            ---NeedGuard = false,
            DesiresAssist = true,
            LocationType = 'LocationType',
            NumAssistees = 2,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T1LandFactory',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAAI T1Engineer LandFac2',
        PlatoonTemplate = 'EngineerBuilderSCTA',
        PriorityFunction = TAPrior.UnitProductionT1Fac,
        Priority = 90,
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'Factory', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'Factory' }},
            { MIBC, 'GreaterThanGameTime', { 120 } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 2, categories.FACTORY } },
            { TASlow, 'TAFactoryCapCheckT1', {}},
            { TAutils, 'EcoManagementTA', { 0.75, 0.75} },
        },
        BuilderType = 'LandTA',
        BuilderData = {
            ---NeedGuard = false,
            DesiresAssist = true,
            NumAssistees = 2,
            LocationType = 'LocationType',
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T1LandFactory2',
                }
            }
        }
    },
    ---UPPERTECHLAND
    Builder {
        BuilderName = 'SCTAAI T2LAND Vehicle Factory',
        PlatoonTemplate = 'EngineerBuilderSCTA123',
        Priority = 150,
        PriorityFunction = TAPrior.UnitProduction,
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'Factory2', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'Factory2' }},
            { TASlow, 'TAFactoryCapCheckT2', {}},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 2, LAB} },
            { TAutils, 'EcoManagementTA', { 0.75, 0.75} },
        },
        BuilderType = 'OmniLand',
        BuilderData = {
            ---NeedGuard = false,
            DesiresAssist = true,
            LocationType = 'LocationType',
            NumAssistees = 2,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T2LandFactory2',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAAI T2LAND KBot Factory',
        PlatoonTemplate = 'EngineerBuilderSCTA123',
        Priority = 140,
        PriorityFunction = TAPrior.UnitProduction,
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'Factory2', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'Factory2' }},
            { TASlow, 'TAFactoryCapCheckT2', {} },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 2, LAB} },
            { TAutils, 'EcoManagementTA', { 0.75, 0.75} },
        },
        BuilderType = 'OmniLand',
        BuilderData = {
            ---NeedGuard = false,
            DesiresAssist = true,
            LocationType = 'LocationType',
            NumAssistees = 2,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T2LandFactory',
                }
            }
        }
    },
    ---V
    ---AirFacts
    Builder {
        BuilderName = 'SCTAAI T1Engineer AirFac',
        PlatoonTemplate = 'EngineerBuilderSCTA',
        Priority = 100,
        PriorityFunction = TAPrior.UnitProductionT1,
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'Factory', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'Factory' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 2,  categories.FACTORY } }, -- Don't build air fac immediately.
            { TASlow, 'TAFactoryCapCheckT2', {} },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 2, categories.FACTORY} },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 4,  categories.FACTORY * categories.AIR} },
            { TAutils, 'EcoManagementTA', { 0.75, 0.75} },
        },
        BuilderType = 'LandTA',
        BuilderData = {
            ---NeedGuard = false,
            DesiresAssist = true,
            NumAssistees = 2,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T1AirFactory',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAAI T2AirFactory',
        PlatoonTemplate = 'EngineerBuilderSCTAEco123',
        Priority = 160,
        PriorityFunction = TAPrior.UnitProduction,
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'Factory2', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'Factory2' }},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1,  LAB } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, LAB * categories.AIR} },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 4, LAB * categories.AIR } }, -- Stop after 10 facs have been built.
            { TAutils, 'EcoManagementTA', { 0.75, 0.75} },
        },
        BuilderType = 'OmniAir',
        BuilderData = {
            ---NeedGuard = false,
            DesiresAssist = true,
            NumAssistees = 2,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T2AirFactory',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAAI T3LAND Hover Factory T2',
        PlatoonTemplate = 'EngineerBuilderSCTA23',
        PriorityFunction = TAPrior.ProductionT3,
        Priority = 140,
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'Factory3', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'Factory3' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 4, PLATFORM * categories.LAND } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.LAND * PLATFORM} },
            { TAutils, 'EcoManagementTA', { 0.75, 0.75} },
        },
        BuilderType = 'OmniLand',
        BuilderData = {
            ---NeedGuard = false,
            DesiresAssist = true,
            NumAssistees = 2,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T3LandFactory',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAAI T3AirFactory T2',
        PlatoonTemplate = 'EngineerBuilderSCTAEco23',
        PriorityFunction = TAPrior.ProductionT3Air,
        Priority = 140,
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'Factory3', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'Factory3' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 4, PLATFORM * categories.AIR} },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.AIR * PLATFORM} },
            { TAutils, 'EcoManagementTA', { 0.75, 0.75} },
        },
        BuilderType = 'OmniAir',
        BuilderData = {
            ---NeedGuard = false,
            DesiresAssist = true,
            NumAssistees = 2,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T3AirFactory',
                }
            }
        }
    },
    ---EmergencyFacts
    Builder {
        BuilderName = 'SCTAT3 Artillery',
        PlatoonTemplate = 'EngineerBuilderSCTA3',
        PriorityFunction = TAPrior.GantryConstruction,
        Priority = 160,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.ARTILLERY * categories.STRUCTURE} },
            { TAutils, 'EcoManagementTA', { 0.75, 0.75} },
        },
        BuilderType = 'T3TA',
        BuilderData = {
            ---NeedGuard = false,
            DesiresAssist = true,
            NumAssistees = 4,
            Construction = {
                BuildStructures = {
                    'T3Artillery',
                },
            }
        }
    },
    Builder {
        BuilderName = 'Nuclear Missile SCTA', -- Names need to be GLOBALLY unique.  Prefixing the AI name will help avoid name collisions with other AIs.	
        PlatoonTemplate = 'CommanderBuilderSCTADecoy',
        PriorityFunction = TAPrior.GantryConstruction,
        Priority = 210,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.NUKE * categories.STRUCTURE * categories.TECH3} },
            { TAutils, 'EcoManagementTA', { 0.9, 0.75} },
        },
        BuilderType = 'T3TA',
        BuilderData = {
            ---NeedGuard = false,
            DesiresAssist = true,
            NumAssistees = 4,
            Construction = {
                BuildStructures = {
                    'T3StrategicMissile',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAAI T2Engineer Home Pgen',
        PlatoonTemplate = 'EngineerBuilderSCTA23All',
        PriorityFunction = TAPrior.UnitProduction,
        Priority = 500,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, FUSION} },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, FUSION} },
        },
        BuilderType = 'NotACU',
        BuilderData = {
            DesiresAssist = true,
            NumAssistees = 6,
            ---NeedGuard = false,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T2EnergyProduction',
                }
            }
        }
    },
}