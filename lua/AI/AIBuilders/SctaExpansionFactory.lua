
local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local MIBC = '/lua/editor/MiscBuildConditions.lua'
local TASlow = '/mods/SCTA-master/lua/AI/TAEditors/TAAIUtils.lua'
local TAutils = '/mods/SCTA-master/lua/AI/TAEditors/TAAIInstantConditions.lua'
LAB = (categories.FACTORY * categories.TECH2)
PLATFORM = (categories.FACTORY * categories.TECH3)
local TAPrior = import('/mods/SCTA-master/lua/AI/TAEditors/TAPriorityManager.lua')
  

BuilderGroup {
    BuilderGroupName = 'SCTAAIFactoryExpansions',
    BuildersType = 'EngineerBuilder',
    ----BotsFacts
    Builder {
        BuilderName = 'SCTAAI Expansion LandFac',
        PlatoonTemplate = 'EngineerBuilderSCTA',
        Priority = 110,
        PriorityFunction = TAPrior.UnitProductionT1Fac,
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'Factory', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'Factory' }},
            { TASlow, 'TAFactoryCapCheckT1', {}},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 2, categories.FACTORY} },
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
                    'T1LandFactory',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAAI Expansion Vehicle LandFac',
        PlatoonTemplate = 'EngineerBuilderSCTA',
        Priority = 100,
        PriorityFunction = TAPrior.UnitProductionT1Fac,
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'Factory', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'Factory' }},
            { TASlow, 'TAFactoryCapCheckT1', {}},
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 2, categories.FACTORY} },
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
                    'T1LandFactory2',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAAI T2LAND Expansion',
        PlatoonTemplate = 'EngineerBuilderSCTA123',
        PriorityFunction = TAPrior.UnitProduction,
        Priority = 120,
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
            NumAssistees = 2,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T2LandFactory',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAAI T2LAND Vehicle Expansion',
        PlatoonTemplate = 'EngineerBuilderSCTA123',
        PriorityFunction = TAPrior.UnitProduction,
        Priority = 110,
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
            NumAssistees = 2,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T2LandFactory',
                }
            }
        }
    },
    ---VEHICLEFact
    ---AirFacts
    Builder {
        BuilderName = 'SCTAAI T1Expansion AirFac',
        PlatoonTemplate = 'EngineerBuilderSCTA',
        Priority = 91,
        PriorityFunction = TAPrior.UnitProductionT1,
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'Factory', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'Factory' }},
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Air' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 2, categories.FACTORY} },
            { TAutils, 'EcoManagementTA', { 0.75, 0.75} },
        },
        BuilderType = 'AirTA',
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
        BuilderName = 'SCTAAI T2Air Expansion',
        PlatoonTemplate = 'EngineerBuilderSCTAEco123',
        PriorityFunction = TAPrior.UnitProduction,
        Priority = 120,
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'Factory2', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'Factory2' }},
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Air' } },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, LAB * categories.AIR} },
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
        BuilderName = 'T2ArtillerySCTA', -- Names need to be GLOBALLY unique.  Prefixing the AI name will help avoid name collisions with other AIs.	
        PlatoonTemplate = 'EngineerBuilderSCTA23All',
        Priority = 50,
        PriorityFunction = TAPrior.StructureProductionT2,
        InstanceCount = 2,
        DelayEqualBuildPlattons = {'Artillery', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'Artillery' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.ARTILLERY * categories.STRUCTURE * categories.TECH2} },
            { TAutils, 'EcoManagementTA', { 0.75, 0.75} },
        },
        BuilderType = 'NotACU',
        BuilderData = {
            ---NeedGuard = false,
            DesiresAssist = true,
            NumAssistees = 2,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T2Artillery',
                }
            }
        }
    },
    Builder {
        BuilderName = 'Mini Nuke Launcher SCTA', -- Names need to be GLOBALLY unique.  Prefixing the AI name will help avoid name collisions with other AIs.	
        PlatoonTemplate = 'EngineerBuilderSCTA23All',
        PriorityFunction = TAPrior.StructureProductionT2,
        Priority = 60,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.TACTICALMISSILEPLATFORM} },
            { TAutils, 'EcoManagementTA', { 0.75, 0.75} },
        },
        BuilderType = 'NotACU',
        BuilderData = {
            ---NeedGuard = false,
            DesiresAssist = true,
            NumAssistees = 2,
            Construction = {
                BuildStructures = {
                    'T2StrategicMissile',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAAI T3LAND Hover Factory T2 Expansion',
        PlatoonTemplate = 'EngineerBuilderSCTA23',
        PriorityFunction = TAPrior.ProductionT3,
        Priority = 143,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, PLATFORM * categories.LAND} },
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
        BuilderName = 'SCTAAI T3AirFactory T2 Expansion',
        PlatoonTemplate = 'EngineerBuilderSCTAEco23',
        PriorityFunction = TAPrior.ProductionT3Air,
        Priority = 140,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, PLATFORM * categories.AIR} },
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
}