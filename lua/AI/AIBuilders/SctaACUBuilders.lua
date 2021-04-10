local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local EBC = '/lua/editor/EconomyBuildConditions.lua'
local IBC = '/lua/editor/InstantBuildConditions.lua'
local SAI = '/lua/ScenarioPlatoonAI.lua'
local MIBC = '/lua/editor/MiscBuildConditions.lua'
local MABC = '/lua/editor/MarkerBuildConditions.lua'
local PLANT = (categories.FACTORY * categories.TECH1)
local LAB = (categories.FACTORY * categories.TECH2)
local FUSION = (categories.ENERGYPRODUCTION * (categories.TECH2 + categories.TECH3)) * categories.STRUCTURE


BuilderGroup {
    BuilderGroupName = 'SCTAAICommanderBuilder', -- Globally unique key that the AI base template file uses to add the contained builders to your AI.	
    BuildersType = 'EngineerBuilder',-- The kind of builder this is.  One of 'EngineerBuilder', 'PlatoonFormBuilder', or 'FactoryBuilder'.
    -- The initial build order
    Builder {
        BuilderName = 'SCTAAI Initial Commander BO', -- Names need to be GLOBALLY unique.  Prefixing the AI name will help avoid name collisions with other AIs.	
        PlatoonTemplate = 'CommanderBuilderSCTA', -- Specify what platoon template to use, see the PlatoonTemplates folder.	
        Priority = 1000, -- Make this super high priority.  The AI chooses the highest priority builder currently available.	
        BuilderConditions = { -- The build conditions determine if this builder is available to be used or not.	
                { IBC, 'NotPreBuilt', {}},
            },	
        InstantCheck = true,	
        BuilderType = 'Any',	
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
        BuilderName = 'SCTA AI ACU Factory',
        PlatoonTemplate = 'CommanderBuilderSCTA',
        Priority = 950,
        InstanceCount = 2, -- The max number concurrent instances of this builder.
        BuilderConditions = {
            { MIBC, 'LessThanGameTime', {240} }, -- Don't make tanks if we have lots of them.
            { MIBC, 'GreaterThanGameTime', {90} },
            { UCBC, 'HaveLessThanUnitsWithCategory', { 4, PLANT} },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.5 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.2, 0.1}},
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = false,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T1LandFactory2',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTA  ACU Energy',
        PlatoonTemplate = 'CommanderBuilderSCTA',
        Priority = 960,
        InstanceCount = 2, -- The max number concurrent instances of this builder.
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 3, categories.ENERGYPRODUCTION * categories.STRUCTURE} },
            { MIBC, 'LessThanGameTime', {180} }, -- Don't make tanks if we have lots of them.
        },
        BuilderType = 'Any',
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
        BuilderName = 'SCTA AI ACU Mex',
        PlatoonTemplate = 'CommanderBuilderSCTA',
        Priority = 975,
        InstanceCount = 2, -- The max number concurrent instances of this builder.
        BuilderConditions = {
            { MIBC, 'LessThanGameTime', {180} }, -- Don't make tanks if we have lots of them.
            { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 25, -500, 100, 0, 'AntiSurface', 1 }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.MASSEXTRACTION} },
        },
        BuilderType = 'Any',
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
        BuilderName = 'SCTA AI ACU T1Engineer Mex',
        PlatoonTemplate = 'CommanderBuilderSCTA',
        Priority = 101,
        InstanceCount = 1, -- The max number concurrent instances of this builder.
        BuilderConditions = {
            { MIBC, 'LessThanGameTime', {600} }, -- Don't make tanks if we have lots of them.
            { MABC, 'CanBuildOnMassLessThanDistance', { 'LocationType', 125, -500, 25, 0, 'AntiSurface', 1 }},
        },
        BuilderType = 'Any',
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
        BuilderName = 'SCTAAI T1Commander LandFac',
        PlatoonTemplate = 'CommanderBuilderSCTA',
        Priority = 91,
        InstanceCount = 1,
        BuilderConditions = {
            { MIBC, 'LessThanGameTime', {900} }, 
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, LAB } }, -- Stop after 10 facs have been built.
            { UCBC, 'HaveLessThanUnitsWithCategory', { 12, PLANT} },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 0.5 } },
            { EBC, 'GreaterThanEconStorageRatio', { 0.2, 0.25}},
        },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = false,
            NeedGuard = false,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T1LandFactory2',
                }
            }
        }
    },    
    Builder {
        BuilderName = 'SCTAAI T1Commander AirFac',
        PlatoonTemplate = 'CommanderBuilderSCTA',
        Priority = 96,
        InstanceCount = 1,
        BuilderConditions = {
            { MIBC, 'LessThanGameTime', {480} }, 
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.FACTORY * categories.AIR } }, -- Stop after 10 facs have been built.
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 0.5 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            DesiresAssist = true,
            NumAssistees = 2,
            NeedGuard = false,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T1AirFactory',
                }
            }
        }
    },
    Builder {
        BuilderName = 'SCTA Commander Assist Gantry Construction',
        PlatoonTemplate = 'CommanderSCTAAssist',
        Priority = 126,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'LocationEngineersBuildingAssistanceGreater', { 'LocationType', 0, categories.GATE }},
        },
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                AssistRange = 120,
                BeingBuiltCategories = {'GATE'},                                                   
                AssistUntilFinished = true,
            },
        },
        BuilderType = 'Any',
    },
    Builder {
        BuilderName = 'SCTA CDR Assist Structure',
        PlatoonTemplate = 'CommanderSCTAAssist',
        Priority = 111,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'LocationEngineersBuildingAssistanceGreater', { 'LocationType', 0, categories.STRUCTURE }},
            { MIBC, 'GreaterThanGameTime', {600} },
        },
        BuilderType = 'Any',
        BuilderData = {
            Assist = {
                AssisteeType = 'Engineer',
                AssistLocation = 'LocationType',
                BeingBuiltCategories = {'STRUCTURE'},
                AssistUntilFinished = true,
            },
        }
    },
}
