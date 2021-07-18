
local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local TAutils = '/mods/SCTA-master/lua/AI/TAEditors/TAAIInstantConditions.lua'
local TASlow = '/mods/SCTA-master/lua/AI/TAEditors/TAAIUtils.lua'
FUSION = (categories.ENERGYPRODUCTION * categories.STRUCTURE * (categories.TECH2 + categories.TECH3))
local TAPrior = import('/mods/SCTA-master/lua/AI/TAEditors/TAPriorityManager.lua')

BuilderGroup {
    BuilderGroupName = 'SCTAGantryProduction',
    BuildersType = 'EngineerBuilder',
    ----Building Reclaim
    Builder {
        BuilderName = 'SCTA Engineer Assist Gantry Field Production',
        PlatoonTemplate = 'EngineerBuilderSCTAField',
        Plan = 'ManagerEngineerAssistAISCTA',
        PriorityFunction = TAPrior.GateBeingBuilt,
        Priority = 200,
        InstanceCount = 2,
        BuilderConditions = {
            { UCBC, 'LocationEngineersBuildingAssistanceGreater', { 'LocationType', 0, categories.GATE }},
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', {1, categories.FIELDENGINEER} },
            { TAutils, 'EcoManagementTA', { 0.75, 0.75} },
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
        BuilderType = 'FieldTA',
    },
    Builder {
        BuilderName = 'SCTA Engineer Assist Field Gantry',
        PlatoonTemplate = 'EngineerBuilderSCTAField',
        Plan = 'ManagerEngineerAssistAISCTA',
        PriorityFunction = TAPrior.GantryProduction,
        Priority = 200,
        InstanceCount = 4,
        BuilderConditions = {
            { UCBC, 'LocationFactoriesBuildingGreater', { 'LocationType', 0, categories.BUILTBYQUANTUMGATE}},
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', {1, categories.FIELDENGINEER} },
            { TAutils, 'EcoManagementTA', { 0.75, 0.75} },
        },
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Factory',
                PermanentAssist = false,
                BeingBuiltCategories = {'BUILTBYQUANTUMGATE'},                                                       
                Time = 60,
            },
        },
        BuilderType = 'FieldTA',
    },
    Builder {
        BuilderName = 'SCTA Commander Assist Gantry Construction',
        PlatoonTemplate = 'CommanderBuilderSCTA',
        PlatoonAIPlan = 'ManagerEngineerAssistAISCTA',
        PriorityFunction = TAPrior.GateBeingBuilt,
        Priority = 126,
        InstanceCount = 2,
        BuilderConditions = {
            { UCBC, 'LocationEngineersBuildingAssistanceGreater', { 'LocationType', 0, categories.GATE }},
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', {1, categories.ENGINEER * (categories.COMMAND + categories.SUBCOMMANDER)} },
            { TAutils, 'EcoManagementTA', { 0.75, 0.75} },
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
        BuilderType = 'Command',
    },
    Builder {
        BuilderName = 'SCTA CDR Assist Structure',
        PlatoonTemplate = 'CommanderBuilderSCTA',
        PlatoonAIPlan = 'ManagerEngineerAssistAISCTA',
        PriorityFunction = TAPrior.UnitProduction,
        Priority = 111,
        InstanceCount = 2,
        BuilderConditions = {
            { UCBC, 'LocationEngineersBuildingAssistanceGreater', { 'LocationType', 0, categories.STRUCTURE }},
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', {1, categories.ENGINEER * (categories.COMMAND + categories.SUBCOMMANDER)} },
            { TAutils, 'EcoManagementTA', { 0.75, 0.75} },
        },
        BuilderType = 'Command',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                AssisteeCategory = 'Engineer',
                AssistRange = 20,
                BeingBuiltCategories = {'STRUCTURE'},                                        
                AssistUntilFinished = true,
            },
        },
    },
    Builder {
        BuilderName = 'SCTAAI Gantry Factory',
        PlatoonTemplate = 'EngineerBuilderSCTA23',
        Priority = 150,
        InstanceCount = 1,
        PriorityFunction = TAPrior.GantryConstruction,
        DelayEqualBuildPlattons = {'Factory', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'Factory' }},
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.GATE} }, -- Stop after 10 facs have been built.
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.GATE} },
            { TAutils, 'EcoManagementTA', { 0.75, 0.75} },
        },
        BuilderType = 'OmniLand',
        BuilderData = {
            ---NeedGuard = false,
            DesiresAssist = true,
            NumAssistees = 2,
            Construction = {
                BuildStructures = {
                    'T3QuantumGate',
                }
            }
        }
    },
    Builder {
        BuilderName = 'Decoy Commander Gateway', -- Names need to be GLOBALLY unique.  Prefixing the AI name will help avoid name collisions with other AIs.	
        PlatoonTemplate = 'CommanderBuilderSCTADecoy', -- Specify what platoon template to use, see the PlatoonTemplates folder.	
        PlatoonAddBehaviors = { 'CommanderBehaviorSCTADecoy' },
        PriorityFunction = TAPrior.GantryProduction,
        Priority = 150, -- Make this super high priority.  The AI chooses the highest priority builder currently available.	
        InstanceCount = 1,
        BuilderConditions = { 
            { UCBC, 'HaveLessThanUnitsWithCategory', { 2, categories.GATE} },-- The build conditions determine if this builder is available to be used or not.	
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.GATE} },
            { TAutils, 'EcoManagementTA', { 0.75, 0.75} },
            },		
        BuilderType = 'T3TA',	-- Add a behaviour to the Commander unit once its done with it's BO.	 -- Flag this builder to be only run once.	
        BuilderData = {	
            ---NeedGuard = false,
            DesiresAssist = true,
            NumAssistees = 4,
            Construction = {
                BuildStructures = { -- The buildings to make	
                'T3QuantumGate',
                }	
            }	
        }	
    },
    Builder {
        BuilderName = 'Decoy Commander Game Ender SCTA', -- Names need to be GLOBALLY unique.  Prefixing the AI name will help avoid name collisions with other AIs.	
        PlatoonTemplate = 'CommanderBuilderSCTADecoy',
        PriorityFunction = TAPrior.GantryProduction,
        Priority = 210,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 1,  categories.GATE} },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.EXPERIMENTAL * categories.ARTILLERY} },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 3,  FUSION} },
            { TAutils, 'EcoManagementTA', { 0.9, 0.75} },
        },
        BuilderType = 'T3TA',
        BuilderData = {
            ---NeedGuard = false,
            DesiresAssist = true,
            NumAssistees = 4,
            Construction = {
                BuildStructures = {
                    'T4Artillery',
                }
            }
        }
    },
}