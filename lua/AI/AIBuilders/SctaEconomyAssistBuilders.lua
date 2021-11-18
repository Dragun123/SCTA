
local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local MIBC = '/lua/editor/MiscBuildConditions.lua'
local TAutils = '/mods/SCTA-master/lua/AI/TAEditors/TAAIInstantConditions.lua'
local TASlow = '/mods/SCTA-master/lua/AI/TAEditors/TAAIUtils.lua'
PLANT = (categories.FACTORY * categories.TECH1)
LAB = (categories.FACTORY * categories.TECH2)
FUSION = (categories.ENERGYPRODUCTION - categories.TECH1)
WIND = (categories.armwin + categories.corwin)
SOLAR = (categories.armsolar + categories.corsolar)
ENGINEERLAND = (categories.ENGINEER * categories.LAND - categories.COMMAND)
local TAPrior = import('/mods/SCTA-master/lua/AI/TAEditors/TAPriorityManager.lua')

BuilderGroup {
    BuilderGroupName = 'SCTAAssisters',
    BuildersType = 'EngineerBuilder',
    ----Building Reclaim
    Builder {
        BuilderName = 'SCTA Engineer Reclaim Excess PLANTS',
        PlatoonTemplate = 'EngineerBuilderSCTAALL',
        PlatoonAIPlan = 'ReclaimStructuresAITA',
        PriorityFunction = TAPrior.FactoryReclaim,
        Priority = 100,
        InstanceCount = 5,
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 0, PLANT * (categories.LAND + categories.AIR)}},
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 4, LAB} },
            { UCBC, 'HaveGreaterThanUnitsWithCategory', { 0, LAB * categories.AIR} },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, PLANT * (categories.LAND + categories.AIR)} },
            { TAutils, 'LessMassStorageMaxTA', { 0.05}},    
            },
        BuilderData = {
            Location = 'LocationType',
            ReclaimTime = 30,
            Reclaim = {'TECH1 FACTORY AIR, TECH1 FACTORY LAND,'},
        },
        BuilderType = 'NotACU',
    },
    Builder {
        BuilderName = 'SCTA Engineer Reclaim Energy',
        PlatoonTemplate = 'EngineerBuilderSCTAALL',
        PlatoonAIPlan = 'ReclaimStructuresAITA',
        PriorityFunction = TAPrior.TechEnergyExist,
        Priority = 85,
        InstanceCount = 4,
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 0, WIND + SOLAR}},
            { TAutils, 'GreaterThanEconEnergyTAEfficiency', {1.05 }},
            { TAutils, 'LessMassStorageMaxTA',  { 0.2}},
            { TAutils, 'GreaterEnergyStorageMaxTA',  { 0.75}},
            },
        BuilderData = {
            Location = 'LocationType',
            Reclaim = {'armsolar, corsolar, armwin, corwin,'},
            ReclaimTime = 30,
        },
        BuilderType = 'NotACU',
    },
    Builder {
        BuilderName = 'SCTA Engineer Reclaim Idle',
        PlatoonTemplate = 'EngineerBuilderSCTA123',
        PlatoonAIPlan = 'SCTAReclaimAI',
        Priority = 75,
        --PriorityFunction = TAPrior.TALowEco,
        InstanceCount = 5,
        BuilderConditions = {
            { MIBC, 'GreaterThanGameTime', { 240 } },
            { UCBC, 'EngineerGreaterAtLocation', { 'LocationType', 2, ENGINEERLAND}},
            { TASlow, 'TAReclaimablesInArea', { 'LocationType', 0.05}},  
            --{ TAutils, 'LessMassStorageMaxTA',  { 0.2}},
        },
        BuilderData = {
            Reclaimer = true,
            Layer = 'Land', 
            LocationType = 'LocationType',
            ReclaimTime = 60,
        },
        BuilderType = 'OmniLand',
    },
    Builder {
        BuilderName = 'SCTA Engineer Reclaim Idle Air',
        PlatoonTemplate = 'EngineerBuilderSCTAEco123',
        PlatoonAIPlan = 'SCTAReclaimAI',
        --PriorityFunction = TAPrior.TALowEco,
        Priority = 75,
        InstanceCount = 5,
        BuilderConditions = {
            { MIBC, 'GreaterThanGameTime', { 240 } },
            { UCBC, 'EngineerGreaterAtLocation', { 'LocationType', 2, categories.ENGINEER * categories.AIR}},
            { TASlow, 'TAReclaimablesInArea', { 'LocationType', 0.2}},  
            --{ TAutils, 'LessMassStorageMaxTA',  { 0.2}},
        },
        BuilderData = {
            Reclaimer = true,
            LocationType = 'LocationType',
            ReclaimTime = 30,
        },
        BuilderType = 'OmniAir',
    },
    Builder {
        BuilderName = 'SCTA Engineer Finish',
        PlatoonTemplate = 'EngineerBuilderSCTAALL',
        PlatoonAIPlan = 'ManagerEngineerFindUnfinishedSCTA',
        Priority = 150,
        InstanceCount = 5,
        DelayEqualBuildPlattons = {'Unfinished', 1},
        BuilderConditions = {
            { UCBC, 'CheckBuildPlattonDelay', { 'Unfinished' }},
            { UCBC, 'EngineerGreaterAtLocation', { 'LocationType', 2, ENGINEERLAND}},
            { UCBC, 'UnfinishedUnits', { 'LocationType', categories.STRUCTURE}},
        },
        BuilderData = {
            Assist = {
                AssistRange = 20,
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                BeingBuiltCategories = {'STRUCTURE'},
                Time = 120,
                AssistUntilFinished = true,
            },
        },
        BuilderType = 'NotACU',
    },
    Builder {
        BuilderName = 'SCTA Economy Assist',
        PlatoonTemplate = 'EngineerBuilderSCTA',
        PlatoonAIPlan = 'ManagerEngineerAssistAISCTA',
        PriorityFunction = TAPrior.AssistProduction,
        Priority = 75,
        InstanceCount = 5,
        BuilderConditions = {
            { TASlow, 'TAFindAssistUnits', { 'LocationType', categories.ECONOMIC, 40}},
            { TAutils, 'HaveGreaterThanUnitsInCategoryBeingBuiltSCTA', { 0, categories.ECONOMIC}},
            { UCBC, 'EngineerGreaterAtLocation', { 'LocationType', 2, categories.ENGINEER - categories.COMMAND}},
            { TAutils, 'EcoManagementTA', { 0.75, 0.75, } },
        },
        BuilderType = 'NotACU',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                BeingBuiltCategories = categories.ECONOMIC,
                Time = 60,
                AssistUntilFinished = true,
                AssistRange = 20,
            },
        }
    },
    Builder {
        BuilderName = 'SCTA PGen Field Assist',
        PlatoonTemplate = 'EngineerBuilderSCTAField',
        PlatoonAIPlan = 'ManagerEngineerAssistAISCTA',
        PriorityFunction = TAPrior.UnitProductionField,
        Priority = 100,
        InstanceCount = 2,
        BuilderConditions = {
            { TASlow, 'TAFindAssistUnits', { 'LocationType', ENGINEERLAND, 40}},
            { TAutils, 'HaveGreaterThanUnitsInCategoryBeingBuiltSCTA', { 0, FUSION}},
            { UCBC, 'EngineerGreaterAtLocation', { 'LocationType', 0, categories.FIELDENGINEER}},
            { TAutils, 'EcoManagementTA', { 0.75, 0.75, } },
        },
        BuilderType = 'FieldTA',
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                BeingBuiltCategories = categories.ENERGYPRODUCTION - categories.TECH1,
                Time = 60,
                AssistUntilFinished = true,
                AssistRange = 20,
            },
        }
    },
    Builder {
        BuilderName = 'SCTA Engineer Reclaim Field',
        PlatoonTemplate = 'EngineerBuilderSCTAField',
        PriorityFunction = TAPrior.UnitProductionFieldReclaim,
        --DelayEqualBuildPlattons = 10,
        PlatoonAIPlan = 'SCTAReclaimAI',
        Priority = 200,
        --FormRadius = 100,
        InstanceCount = 5,
        BuilderConditions = {
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', {1,  categories.FIELDENGINEER}},
            { TASlow, 'TAReclaimablesInArea', { 'LocationType', 0.2}},
        },
        BuilderData = {
            Reclaimer = true,
            ReclaimTime = 30, 
            LocationType = 'LocationType',
        },
        BuilderType = 'FieldTA',
    },
    Builder {
        BuilderName = 'SCTA Engineer Field Finish',
        PlatoonTemplate = 'EngineerBuilderSCTAField',
        PriorityFunction = TAPrior.UnitProductionField,
        --DelayEqualBuildPlattons = 3,
        PlatoonAIPlan = 'ManagerEngineerFindUnfinishedSCTA',
        Priority = 125,
        InstanceCount = 2,
        DelayEqualBuildPlattons = {'Unfinished', 2},
        BuilderConditions = {
            { TASlow, 'CheckBuildPlatoonDelaySCTA', { 'Unfinished' }},
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', {1,  categories.FIELDENGINEER}},
            { UCBC, 'UnfinishedUnits', { 'LocationType', categories.STRUCTURE}},
            { TAutils, 'EcoManagementTA', { 0.5, 0.5, } },
        },
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                BeingBuiltCategories = {'STRUCTURE'},
                AssistRange = 60,
                Time = 30,
                AssistUntilFinished = true,
            },
        },
        BuilderType = 'FieldTA',
    },
    Builder {
        BuilderName = 'SCTA Assist Production Field',
        PlatoonTemplate = 'EngineerBuilderSCTAField',
        PlatoonAIPlan = 'ManagerFactoryAssistAISCTA',
        PriorityFunction = TAPrior.UnitProductionField,
        --DelayEqualBuildPlattons = 2,
        Priority = 100,
        InstanceCount = 5,
        BuilderConditions = {
            { TASlow, 'TAFindAssistUnits', { 'LocationType', categories.FACTORY - categories.TECH1, 80}},
            { UCBC, 'FactoryGreaterAtLocation', { 'LocationType', 1, categories.FACTORY - categories.TECH1} },
            --{ TASlow, 'TALocationEngineersBuildingAssistanceGreater', { 'LocationType', 0, 'STRUCTURE TECH2, STRUCTURE TECH3, EXPERIMENTAL' }},
            { UCBC, 'EngineerGreaterAtLocation', { 'LocationType', 0, categories.FIELDENGINEER}},
            { TAutils, 'EcoManagementTA', { 0.75, 0.75, } },
            ---{ TAutils, 'GreaterTAStorageRatio', { 0.5, 0.5}},
        },
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Factory',
                AssistUntilFinished = true,
                BeingBuiltCategories = categories.FACTORY - categories.TECH1,
                Time = 30,
                AssistRange = 60,
            },
        },
        BuilderType = 'FieldTA',
    },
}