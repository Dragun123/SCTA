
local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local EBC = '/lua/editor/EconomyBuildConditions.lua'
local SAI = '/lua/ScenarioPlatoonAI.lua'
local MIBC = '/lua/editor/MiscBuildConditions.lua'
local TAutils = '/mods/SCTA-master/lua/AI/TAEditors/TAAIInstantConditions.lua'
local TASlow = '/mods/SCTA-master/lua/AI/TAEditors/TAAIUtils.lua'
local PLANT = (categories.FACTORY * categories.TECH1)
local LAB = (categories.FACTORY * categories.TECH2)
local PLATFORM = (categories.FACTORY * categories.TECH3)
local FUSION = (categories.ENERGYPRODUCTION * (categories.TECH2 + categories.TECH3)) * categories.STRUCTURE
local WIND = (categories.armwin + categories.corwin)
local SOLAR = (categories.armsolar + categories.corsolar)
local TAPrior = import('/mods/SCTA-master/lua/AI/TAEditors/TAPriorityManager.lua')

BuilderGroup {
    BuilderGroupName = 'SCTAAssisters',
    BuildersType = 'EngineerBuilder',
    ----Building Reclaim
    Builder {
        BuilderName = 'SCTA Engineer Reclaim Excess PLANTS',
        PlatoonTemplate = 'EngineerBuilderSCTAALL',
        PlatoonAIPlan = 'ReclaimStructuresAI',
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
        PlatoonAIPlan = 'ReclaimStructuresAI',
        PriorityFunction = TAPrior.TechEnergyExist,
        Priority = 85,
        InstanceCount = 4,
        BuilderConditions = {
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 0, WIND + SOLAR}},
            { TAutils, 'GreaterThanEconEnergyTAEfficiency', {1.05 }},
            { TAutils, 'LessMassStorageMaxTA',  { 0.2}},
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
        InstanceCount = 10,
        BuilderConditions = {
            { MIBC, 'GreaterThanGameTime', { 240 } },
            { UCBC, 'EngineerGreaterAtLocation', { 'LocationType', 2, categories.ENGINEER - categories.COMMAND - categories.NAVAL}},
            { TASlow, 'TAReclaimablesInArea', { 'LocationType', }},  
            { TAutils, 'LessMassStorageMaxTA',  { 0.2}},
        },
        BuilderData = {
            Layer = 'Land', 
            LocationType = 'LocationType',
            ReclaimTime = 30,
        },
        BuilderType = 'OmniLand',
    },
    Builder {
        BuilderName = 'SCTA Engineer Reclaim Idle Air',
        PlatoonTemplate = 'EngineerBuilderSCTAEco123',
        PlatoonAIPlan = 'SCTAReclaimAI',
        Priority = 75,
        InstanceCount = 10,
        BuilderConditions = {
            { MIBC, 'GreaterThanGameTime', { 240 } },
            { UCBC, 'EngineerGreaterAtLocation', { 'LocationType', 2, categories.ENGINEER * categories.AIR}},
            { TASlow, 'TAReclaimablesInArea', { 'LocationType', }},  
            { TAutils, 'LessMassStorageMaxTA',  { 0.2}},
        },
        BuilderData = {
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
            { UCBC, 'EngineerGreaterAtLocation', { 'LocationType', 2, (categories.ENGINEER * categories.LAND) - categories.COMMAND}},
            { UCBC, 'UnfinishedUnits', { 'LocationType', categories.STRUCTURE}},
        },
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                BeingBuiltCategories = {'STRUCTURE'},
                Time = 20,
                AssistUntilFinished = true,
            },
        },
        BuilderType = 'NotACU',
    },
    Builder {
        BuilderName = 'SCTA PGen Field Assist',
        PlatoonTemplate = 'EngineerBuilderSCTAField',
        PlatoonAIPlan = 'ManagerEngineerAssistAI',
        PriorityFunction = TAPrior.UnitProductionField,
        Priority = 75,
        InstanceCount = 2,
        BuilderConditions = {
            { UCBC, 'HaveGreaterThanUnitsInCategoryBeingBuilt', { 0, FUSION, 'LocationType', }},
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', {1, categories.FIELDENGINEER}},
            { TAutils, 'EcoManagementTA', { 0.5, 0.5, } },
        },
        BuilderType = 'FieldTA',
        BuilderData = {
            Assist = {
                AssisteeType = 'Engineer',
                AssistLocation = 'LocationType',
                BeingBuiltCategories = {'TECH2 ENERGYPRODUCTION STRUCTURE, TECH3 ENERGYPRODUCTION STRUCTURE,'},
                Time = 20,
                AssistRange = 120,
                AssistUntilFinished = true,
            },
        }
    },
    Builder {
        BuilderName = 'SCTA Engineer Reclaim Field',
        PlatoonTemplate = 'EngineerBuilderSCTAField',
        PriorityFunction = TAPrior.UnitProductionField,
        --DelayEqualBuildPlattons = 10,
        PlatoonAIPlan = 'SCTAReclaimAI',
        Priority = 200,
        --FormRadius = 100,
        InstanceCount = 5,
        BuilderConditions = {
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', {1,  categories.FIELDENGINEER}},
            { TASlow, 'TAReclaimablesInArea', { 'LocationType', }},
            { TAutils, 'LessMassStorageMaxTA',  { 0.2}},
        },
        BuilderData = {
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
        PlatoonAIPlan = 'ManagerEngineerFindUnfinished',
        Priority = 125,
        InstanceCount = 2,
        DelayEqualBuildPlattons = {'Unfinished', 2},
        BuilderConditions = {
            { TASlow, 'CheckBuildPlatoonDelaySCTA', { 'Unfinished' }},
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', {1,  categories.FIELDENGINEER}},
            { UCBC, 'UnfinishedUnits', { 'LocationType', categories.STRUCTURE}},
        },
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                BeingBuiltCategories = {'STRUCTURE STRATEGIC, STRUCTURE ECONOMIC, STRUCTURE'},
                Time = 20,
                AssistUntilFinished = true,
            },
        },
        BuilderType = 'FieldTA',
    },
    Builder {
        BuilderName = 'SCTA Assist Production Field',
        PlatoonTemplate = 'EngineerBuilderSCTAField',
        PlatoonAIPlan = 'ManagerEngineerAssistAI',
        PriorityFunction = TAPrior.UnitProductionField,
        --DelayEqualBuildPlattons = 2,
        Priority = 100,
        InstanceCount = 5,
        BuilderConditions = {
            { UCBC, 'LocationEngineersBuildingAssistanceGreater', { 'LocationType', 0, categories.STRUCTURE * (categories.TECH2 + categories.TECH3)}},
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', {1, categories.FIELDENGINEER}},
            { TAutils, 'GreaterTAStorageRatio', { 0.5, 0.5}},
        },
        BuilderData = {
            Assist = {
                AssistLocation = 'LocationType',
                AssisteeType = 'Engineer',
                AssistRange = 120,
                BeingBuiltCategories = {'STRUCTURE TECH2, STRUCTURE TECH3,'},                                        
                AssistUntilFinished = true,
            },
        },
        BuilderType = 'FieldTA',
    },
}