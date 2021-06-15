local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local EBC = '/lua/editor/EconomyBuildConditions.lua'
local TAutils = '/mods/SCTA-master/lua/AI/TAEditors/TAAIInstantConditions.lua'
local TASlow = '/mods/SCTA-master/lua/AI/TAEditors/TAAIUtils.lua'
local TBC = '/lua/editor/ThreatBuildConditions.lua'
local SAI = '/lua/ScenarioPlatoonAI.lua'
local MABC = '/lua/editor/MarkerBuildConditions.lua'
local MIBC = '/lua/editor/MiscBuildConditions.lua'
local PLANT = (categories.FACTORY * categories.TECH1)
local LAB = (categories.FACTORY * categories.TECH2)
local PLATFORM = (categories.FACTORY * categories.TECH3)
local FUSION = ((categories.ENERGYPRODUCTION * (categories.TECH2 + categories.TECH3)) * categories.STRUCTURE)
local CLOAKREACT = (categories.ENERGYPRODUCTION * categories.TECH3 * categories.STRUCTURE)
local WIND = (categories.armwin + categories.corwin)
local SOLAR = (categories.armsolar + categories.corsolar)
local TAPrior = import('/mods/SCTA-master/lua/AI/TAEditors/TAPriorityManager.lua')

BuilderGroup {
    BuilderGroupName = 'SCTAAIEngineerEcoBuilder',
    BuildersType = 'EngineerBuilder',
    ---LandEco
    Builder {
        BuilderName = 'SCTAAI T1Engineer Mex 25',
        PlatoonTemplate = 'EngineerBuilderSCTA',
        Priority = 105,
        InstanceCount = 1, -- The max number concurrent instances of this builder.
        DelayEqualBuildPlattons = {'MexLand2', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'MexLand2' }},
            { TASlow, 'TACanBuildOnMassLessThanDistanceLand', { 'LocationType', 25, -500, 1000, 0, 'StructuresNotMex', 1 }},
        },
        BuilderType = 'LandTA',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAAI T1Engineer Mex 150',
        PlatoonTemplate = 'EngineerBuilderSCTA',
        Priority = 150,
        InstanceCount = 1, -- The max number concurrent instances of this builder.
        DelayEqualBuildPlattons = {'MexLand2', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'MexLand2' }},
            { TASlow, 'TACanBuildOnMassLessThanDistanceLand', { 'LocationType', 150, -500, 1000, 0, 'StructuresNotMex', 1 }},
        },
        BuilderType = 'LandTA',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAAI T1Engineer 300 Mex',
        PlatoonTemplate = 'EngineerBuilderSCTA',
        Priority = 125,
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'MexLand2', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'MexLand2' }},
            { TASlow, 'TACanBuildOnMassLessThanDistanceLand', { 'LocationType', 300, -500, 500, 0, 'StructuresNotMex', 1 }},
        },
        BuilderType = 'LandTA',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAAI T1Engineer 450 Mex',
        PlatoonTemplate = 'EngineerBuilderSCTA',
        Priority = 100,
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'MexLand2', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'MexLand2' }},
            { TASlow, 'TACanBuildOnMassLessThanDistanceLand', { 'LocationType', 450, -500, 250, 0, 'StructuresNotMex', 1 }},
        },
        BuilderType = 'LandTA',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },  
    Builder {
        BuilderName = 'SCTAAI T2Engineer Mex',
        PlatoonTemplate = 'EngineerBuilderSCTA23All',
        Priority = 200,
        InstanceCount = 1, -- The max number concurrent instances of this builder.
        DelayEqualBuildPlattons = {'Mex2', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'Mex2' }},
            { TASlow, 'TACanBuildOnMassLessThanDistanceLand', { 'LocationType', 100, -500, 500, 0, 'StructuresNotMex', 1 }},
            { EBC, 'GreaterThanEconStorageCurrent', { 300, 500 } },
        },
        BuilderType = 'NotACU',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T2Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAAI T2Engineer 250 Mex',
        PlatoonTemplate = 'EngineerBuilderSCTAEco23',
        Priority = 200,
        InstanceCount = 1, -- The max number concurrent instances of this builder.
        DelayEqualBuildPlattons = {'Mex2', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'Mex2' }},
            { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 250, -500, 500, 0, 'AntiAir', 1 }},
            { EBC, 'GreaterThanEconStorageCurrent', { 300, 500 } },
        },
        BuilderType = 'OmniAir',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T2Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAAI T1Engineer Hydro',
        PlatoonTemplate = 'EngineerBuilderSCTAALL',
        Priority = 500,
        InstanceCount = 1, -- The max number concurrent instances of this builder.
        DelayEqualBuildPlattons = {'Hydro', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'Hydro' }},
            { MIBC, 'LessThanGameTime', {120} }, 
            { MABC, 'MarkerLessThanDistance',  { 'Hydrocarbon', 50}},
        },
        BuilderType = 'NotACU',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = true,
            NumAssistees = 2,
            Construction = {
                BuildStructures = {
                    'T1HydroCarbon',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAAI T1Engineer Hydro Far',
        PlatoonTemplate = 'EngineerBuilderSCTAEco',
        Priority = 175,
        InstanceCount = 1, -- The max number concurrent instances of this builder.
        DelayEqualBuildPlattons = {'Hydro', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'Hydro' }},
            { MABC, 'MarkerLessThanDistance',  { 'Hydrocarbon', 500}},
        },
        BuilderType = 'AirTA',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1HydroCarbon',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAAI T1Engineer Pgen',
        PlatoonTemplate = 'EngineerBuilderSCTA',
        Priority = 50,
        PriorityFunction = TAPrior.HighTechEnergyProduction,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 10, SOLAR} },
            { TAutils , 'LessThanEconEnergyTAEfficiency', {1.05}},
        },
        BuilderType = 'LandTA',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = false,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T1EnergyProduction',
                }
            }
        }
    },  
    Builder {
        BuilderName = 'SCTAAI T1Engineer Pgen2',
        PlatoonTemplate = 'EngineerBuilderSCTA',
        Priority = 50,
        PriorityFunction = TAPrior.HighTechEnergyProduction,
        InstanceCount = 1,
        BuilderConditions = {
            { TAutils , 'LessThanEconEnergyTAEfficiency', {1.05}},
        },
        BuilderType = 'LandTA',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = false,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T1EnergyProduction2',
                }
            }
        }
    },  
    Builder {
        BuilderName = 'SCTAAI T2Engineer Pgen',
        PlatoonTemplate = 'EngineerBuilderSCTA23All',
        PriorityFunction = TAPrior.StructureProductionT2Energy,
        Priority = 500,
        InstanceCount = 2,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, FUSION} },
            { TAutils , 'LessThanEconEnergyTAEfficiency', {1.05}},
        },
        BuilderType = 'NotACU',
        BuilderData = {
            DesiresAssist = true,
            NumAssistees = 6,
            NeedGuard = false,
            Construction = {
                BuildStructures = {
                    'T2EnergyProduction',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAAI T3Engineer Pgen',
        PlatoonTemplate = 'EngineerBuilderSCTA3',
        Priority = 500,
        PriorityFunction = TAPrior.GantryConstruction,
        InstanceCount = 2,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, CLOAKREACT} },
            { TAutils , 'LessThanEconEnergyTAEfficiency', {1.05}},
        },
        BuilderType = 'T3TA',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = true,
            NumAssistees = 6,
            Construction = {
                BuildStructures = {
                    'T3EnergyProduction',
                }
            }
        }
    },
    ---AIREco
    Builder {
        BuilderName = 'SCTAAI T1Engineer Air 850 Mex',
        PlatoonTemplate = 'EngineerBuilderSCTAEco',
        Priority = 105,
        InstanceCount = 2,
        DelayEqualBuildPlattons = {'MexLand2', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'MexLand2' }},
                { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 1000, -500, 500, 0, 'AntiAir', 1 }},
            },
        BuilderType = 'AirTA',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAAI T1Engineer Air Pgen',
        PlatoonTemplate = 'EngineerBuilderSCTAEco',
        PriorityFunction = TAPrior.HighTechEnergyProduction,
        Priority = 150,
        InstanceCount = 2,
        BuilderConditions = {
            { TAutils , 'LessThanEconEnergyTAEfficiency', {1.05}},
        },
        BuilderType = 'AirTA',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = false,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T1EnergyProduction2',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAAI MetalMaker',
        PlatoonTemplate = 'EngineerBuilderSCTAALL',
        PriorityFunction = TAPrior.TechEnergyExist,
        Priority = 120,
        InstanceCount = 2,
        BuilderConditions = {
            { TAutils, 'GreaterThanEconEnergyTAEfficiency', {1.05 }},
            { TAutils, 'LessMassStorageMaxTA',  { 0.3}},
        },
        BuilderType = 'NotACU',
        BuilderData = {
            DesiresAssist = true,
            NeedGuard = false,
            NumAssistees = 2,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T2MassCreation',
                }
            }
        }
    },
}