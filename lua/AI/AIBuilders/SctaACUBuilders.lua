local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local IBC = '/lua/editor/InstantBuildConditions.lua'
local SAI = '/lua/ScenarioPlatoonAI.lua'
local TAutils = '/mods/SCTA-master/lua/AI/TAEditors/TAAIInstantConditions.lua'
local TASlow = '/mods/SCTA-master/lua/AI/TAEditors/TAAIUtils.lua'
local MIBC = '/lua/editor/MiscBuildConditions.lua'
local MABC = '/lua/editor/MarkerBuildConditions.lua'
PLANT = (categories.FACTORY * categories.TECH1)
LAB = (categories.FACTORY * categories.TECH2)
PLATFORM = (categories.FACTORY * categories.TECH3)
ENGINEERLAND = (categories.ENGINEER * categories.LAND - categories.COMMAND)
local TAPrior = import('/mods/SCTA-master/lua/AI/TAEditors/TAPriorityManager.lua')


BuilderGroup {
    BuilderGroupName = 'SCTAAICommanderBuilder', -- Globally unique key that the AI base template file uses to add the contained builders to your AI.	
    BuildersType = 'EngineerBuilder',-- The kind of builder this is.  One of 'EngineerBuilder', 'PlatoonFormBuilder', or 'FactoryBuilder'.
    -- The initial build order
    Builder {
        BuilderName = 'SCTAAI Initial Commander BO', -- Names need to be GLOBALLY unique.  Prefixing the AI name will help avoid name collisions with other AIs.	
        PlatoonTemplate = 'CommanderBuilderSCTA', -- Specify what platoon template to use, see the PlatoonTemplates folder.	
        Priority = 1000, -- Make this super high priority.  The AI chooses the highest priority builder currently available.	
        --PriorityFunction = TAPrior.EarlyBO,
        BuilderConditions = { -- The build conditions determine if this builder is available to be used or not.	
                { IBC, 'NotPreBuilt', {}},
            },	
        InstantCheck = true,	
        BuilderType = 'Command',	
        PlatoonAddBehaviors = { 'CommanderBehaviorSCTA' }, -- Add a behaviour to the Commander unit once its done with it's BO.	
        PlatoonAddFunctions = { {SAI, 'BuildOnce'}, }, -- Flag this builder to be only run once.	
        BuilderData = {	
            Construction = {
                BaseTemplateFile = '/mods/SCTA-master/lua/AI/TAMiscBaseTemplates/CommanderBaseTemplate.lua',
                BaseTemplate = 'CommanderBaseTemplate',
                BuildStructures = { -- The buildings to make	
                'T1LandFactory',	
                'T1EnergyProduction',
                'T1EnergyProduction',
                }	
            }	
        }	
    },
    Builder {
        BuilderName = 'SCTA AI ACU Alternate Factory',
        PlatoonTemplate = 'CommanderBuilderSCTA',
        Priority = 950,
        InstanceCount = 1, -- The max number concurrent instances of this builder.
        --PriorityFunction = TAPrior.EarlyBO,
        BuilderConditions = {
            { MIBC, 'LessThanGameTime', {360} }, -- Don't make tanks if we have lots of them.
            { MIBC, 'GreaterThanGameTime', {90} },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, PLANT * ((categories.CORE * categories.BOT) + (categories.ARM * categories.TANK))} },
            { TAutils, 'EcoManagementTA', { 0.75, 0.75, } },
        },
        BuilderType = 'Command',
        BuilderData = {
            ---NeedGuard = false,
            ---DesiresAssist = false,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T1LandFactory2',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTA AI ACU Main Factory',
        PlatoonTemplate = 'CommanderBuilderSCTA',
        Priority = 960,
        InstanceCount = 1, -- The max number concurrent instances of this builder.
        --PriorityFunction = TAPrior.EarlyBO,
        BuilderConditions = {
            { MIBC, 'LessThanGameTime', {300} }, -- Don't make tanks if we have lots of them.
            { MIBC, 'GreaterThanGameTime', {90} },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, PLANT * ((categories.CORE * categories.TANK) + (categories.ARM * categories.BOT))} },
            { TAutils, 'EcoManagementTA', { 0.75, 0.75, } },
        },
        BuilderType = 'Command',
        BuilderData = {
            ---NeedGuard = false,
            ---DesiresAssist = false,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T1LandFactory',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTA  ACU Energy',
        PlatoonTemplate = 'CommanderBuilderSCTA',
        Priority = 965,
        InstanceCount = 1, -- The max number concurrent instances of this builder.
        --PriorityFunction = TAPrior.EarlyBO,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.STRUCTURE} },
            { MIBC, 'LessThanGameTime', {240} }, -- Don't make tanks if we have lots of them.
        },
        BuilderType = 'Command',
        BuilderData = {
            ---NeedGuard = false,
            ---DesiresAssist = false,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T1EnergyProduction',
                }
            }
        }
    },   
    Builder {
        BuilderName = 'SCTA AI ACU Mex',
        PlatoonTemplate = 'CommanderBuilderSCTA',
        Priority = 975,
        --PriorityFunction = TAPrior.EarlyBO,
        InstanceCount = 1, -- The max number concurrent instances of this builder.
        BuilderConditions = {
            { MIBC, 'LessThanGameTime', {240} }, -- Don't make tanks if we have lots of them.
            { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 25, -500, 100, 0, 'AntiSurface', 1 }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 4, categories.MASSEXTRACTION} },
        },
        BuilderType = 'Command',
        BuilderData = {
            ---NeedGuard = false,
            ---DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAAI T1Commander AirFac',
        PlatoonTemplate = 'CommanderBuilderSCTA',
        PriorityFunction = TAPrior.UnitProductionT1Fac,
        Priority = 945,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.FACTORY * categories.AIR } }, -- Stop after 10 facs have been built.
            { TAutils, 'EcoManagementTA', { 0.75, 0.75, } },
        },
        BuilderType = 'Command',
        BuilderData = {
            DesiresAssist = true,
            NumAssistees = 2,
            ---NeedGuard = false,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T1AirFactory',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTAAI T1ACU Pgen2',
        PlatoonTemplate = 'CommanderBuilderSCTA',
        Priority = 50,
        PriorityFunction = TAPrior.HighTechEnergyProduction,
        InstanceCount = 1,
        BuilderConditions = {
            { TAutils , 'LessThanEconEnergyTAEfficiency', {0.9 }},
        },
        BuilderType = 'Command',
        BuilderData = {
            ---NeedGuard = false,
            ---DesiresAssist = false,
            Construction = {
                --BuildClose = true,
                BuildStructures = {
                    'T1EnergyProduction2',
                }
            }
        }
    },  
    Builder {
        BuilderName = 'SCTAAI T1Commander LandFac',
        PlatoonTemplate = 'CommanderBuilderSCTA',
       PriorityFunction = TAPrior.UnitProductionT1Fac,
        Priority = 60,
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'Factory', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'Factory' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 6, categories.FACTORY} },
            { TAutils, 'EcoManagementTA', { 0.75, 0.75, } },
        },
        BuilderType = 'Command',
        BuilderData = {
            ---DesiresAssist = false,
            ---NeedGuard = false,
            Construction = {
                BuildStructures = {
                    'T1LandFactory2',
                }
            }
        }
    }, 
    Builder {
        BuilderName = 'SCTA AI ACU T1Engineer Mex',
        PlatoonTemplate = 'CommanderBuilderSCTA',
        Priority = 101,
        --PriorityFunction = TAPrior.UnitProductionT1,
        InstanceCount = 1, -- The max number concurrent instances of this builder.
        DelayEqualBuildPlattons = {'MexLand2', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'MexLand2' }},
            { MIBC, 'LessThanGameTime', {600} }, -- Don't make tanks if we have lots of them.
            { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 125, -500, 100, 0, 'StructuresNotMex', 1 }},
        },
        BuilderType = 'Command',
        BuilderData = {
            ---NeedGuard = false,
            ---DesiresAssist = false,
            Construction = {
                BuildStructures = {
                    'T1Resource',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTA Engineer Reclaim Excess',
        PlatoonTemplate = 'EngineerBuilderSCTA',
        PlatoonAIPlan = 'SCTAReclaimAI',
        --PriorityFunction = TAPrior.TALowEco,
        Priority = 120,
        InstanceCount = 2,
        BuilderConditions = {
            { MIBC, 'GreaterThanGameTime', { 120 } }, 
            { UCBC, 'EngineerGreaterAtLocation', { 'LocationType', 2, ENGINEERLAND}},
            { TASlow, 'TAReclaimablesInArea', { 'LocationType', 0.2}},
            --{ TAutils, 'LessMassStorageMaxTA',  { 0.2}},   
        },
        BuilderData = {
            TAEscort = true,
            Reclaimer = true,
            Layer = 'Land', 
            LocationType = 'LocationType',
            ReclaimTime = 60,
        },
        BuilderType = 'LandTA',
    },
    Builder {
        BuilderName = 'SCTA Engineer Factory Assist',
        PlatoonTemplate = 'EngineerBuilderSCTAALL',
        PlatoonAIPlan = 'ManagerEngineerAssistAISCTA',
        PriorityFunction = TAPrior.AssistProduction,
        Priority = 50,
        InstanceCount = 4,
        BuilderConditions = {
            { TASlow, 'TAFindAssistUnits', { 'LocationType', ENGINEERLAND, 60}},
            ---{ UCBC, 'EngineerGreaterAtLocation', { 'LocationType', 2, ENGINEERLAND}},
            { UCBC, 'LocationEngineersBuildingGreater', { 'LocationType', 0, categories.FACTORY}},
            ---{ TAutils, 'HaveGreaterThanUnitsInCategoryBeingBuiltSCTA', { 1, categories.FACTORY}},
            ---{ TASlow, 'TALocationEngineersBuildingAssistanceGreater', { 'LocationType', 0, 'STRUCTURE TECH2, STRUCTURE TECH3, EXPERIMENTAL' }},
            ---{ TAutils, 'EcoManagementTA', { 0.75, 0.75} },
        },
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                BeingBuiltCategories = categories.FACTORY,
                Time = 60,
                AssistUntilFinished = true,
                AssistRange = 40,
            },
        },
        BuilderType = 'NotACU',
    },
    Builder {
        BuilderName = 'SCTA Assist Unit Production Idle',
        PlatoonTemplate = 'EngineerBuilderSCTA',
        PlatoonAIPlan = 'ManagerFactoryAssistAISCTA',
        PriorityFunction = TAPrior.AssistProduction,
        Priority = 50,
        InstanceCount = 4,
        BuilderConditions = {
            { TASlow, 'TAFindAssistUnits', { 'LocationType', categories.FACTORY - categories.TECH1, 60}},
            --{ UCBC, 'EngineerGreaterAtLocation', { 'LocationType', 2, ENGINEERLAND}},
            { UCBC, 'LocationFactoriesBuildingGreater', { 'LocationType', 2, categories.MOBILE - categories.TECH1} },
            --{ UCBC, 'HaveGreaterThanUnitsInCategoryBeingBuilt', { 0, categories.MOBILE, 'LocationType', }},
            --{ UCBC, 'LocationFactoriesBuildingGreater', { 'LocationType', 0, 'MOBILE' }},
            --{ TAutils, 'EcoManagementTA', { 0.75, 0.75} },
        },
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Factory',
                AssistUntilFinished = true,
                BeingBuiltCategories = categories.FACTORY - categories.TECH1,
                Time = 30,
                AssistRange = 40,
            },
        },
        BuilderType = 'NotACU',
    },
}

--{ SIBC, 'EngineerNeedsAssistance', { false, 'LocationType', {'STRUCTURE'} }},
