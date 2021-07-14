#***************************************************************************
#*
#**  File     :  /lua/ai/AIEconomyUpgradeBuilders.lua
#**
#**  Summary  : Default economic builders for skirmish
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local MIBC = '/lua/editor/MiscBuildConditions.lua'
local EBC = '/lua/editor/EconomyBuildConditions.lua'
local TAutils = '/mods/SCTA-master/lua/AI/TAEditors/TAAIInstantConditions.lua'
local TASlow = '/mods/SCTA-master/lua/AI/TAEditors/TAAIUtils.lua'
local TAPrior = import('/mods/SCTA-master/lua/AI/TAEditors/TAPriorityManager.lua')

BuilderGroup {
    BuilderGroupName = 'SCTAUpgrades',
    BuildersType = 'PlatoonFormBuilder',
    Builder {
        BuilderName = 'TAExtractorUpgrade',
        PlatoonTemplate = 'SctaExtractorUpgrades',
        DelayEqualBuildPlattons = {'TAExtractorUpgrade', 1},
        PriorityFunction = TAPrior.UnitProduction,
        InstanceCount = 1,
        Priority = 150,
        BuilderConditions = {
            { TASlow, 'CheckBuildPlatoonDelaySCTA', { 'TAExtractors' }},
            { UCBC, 'PoolGreaterAtLocation', { 'LocationType', 0, categories.MASSEXTRACTION * categories.TECH1 } },
            { TASlow, 'HaveLessThanUnitsInCategoryBeingUpgradeSCTA', { 1, categories.MASSEXTRACTION * categories.TECH1 } },  
            { TAutils, 'EcoManagementTA', { 0.75, 0.75} },
        },
        BuilderType = 'StructureForm',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = false,
        }
    },
    Builder {
        BuilderName = 'SCTAExtractorUpgradeTime',
        PlatoonTemplate = 'SctaExtractorUpgrades',
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'TAExtractorUpgrade', 1},
        PriorityFunction = TAPrior.UnitProduction,
        Priority = 100,
        BuilderConditions = {
            { TASlow, 'CheckBuildPlatoonDelaySCTA',  { 'TAExtractors' }},
            { TASlow, 'HaveLessThanUnitsInCategoryBeingUpgradeSCTA', { 2, categories.MASSEXTRACTION * categories.TECH1 } },  
            { EBC, 'GreaterThanEconIncome',  { 8, 70}},
            { TAutils, 'EcoManagementTA', { 0.75, 0.75} },
        },
        BuilderType = 'StructureForm',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = false,
        }
    },
    Builder {
        BuilderName = 'SCTA Extractor Emergency Upgrade',
        PlatoonTemplate = 'SctaExtractorUpgrades',
        DelayEqualBuildPlattons = {'TAExtractorUpgrade', 1},
        PriorityFunction = TAPrior.UnitProduction,
        InstanceCount = 2,
        Priority = 150,
        BuilderConditions = {
            { TASlow, 'CheckBuildPlatoonDelaySCTA',  { 'TAExtractors' }},
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', {1, categories.MASSEXTRACTION * categories.TECH1 } },
            { TASlow, 'HaveLessThanUnitsInCategoryBeingUpgradeSCTA', { 2, categories.MASSEXTRACTION * categories.TECH1 } },  
            { TAutils, 'EcoManagementTA', { 0.9, 0.9} },
            { EBC, 'GreaterThanEconStorageCurrent', { 800, 1000 } },
        },
        BuilderType = 'StructureForm',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = false,
        }
    },
    Builder {
        BuilderName = 'SCTAUpgradeIntel',
        PlatoonTemplate = 'SctaIntelUpgrades',
        PriorityFunction = TAPrior.TechEnergyExist,
        Priority = 50,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'HaveLessThanUnitsWithCategory', { 1, categories.OPTICS} },
            { UCBC, 'HaveLessThanUnitsInCategoryBeingBuilt', { 1, categories.RADAR * categories.STRUCTURE * categories.TECH2 - categories.FACTORY} },
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', {1, categories.RADAR * categories.STRUCTURE * categories.TECH1 - categories.FACTORY} },
            { TAutils, 'EcoManagementTA', { 0.75, 1.05} },
        },
        BuilderType = 'StructureForm',
    },
    Builder {
        BuilderName = 'SCTAMetalMakr',
        PlatoonTemplate = 'FabricationSCTA',
        Priority = 300,
        FormRadius = 1000,
        PriorityFunction = TAPrior.TechEnergyExist,
        BuilderConditions = {
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', {1, categories.MASSFABRICATION} },
            },
        BuilderType = 'StructureForm',
    },
    Builder {
        BuilderName = 'SCTAArtilleryAI',
        PlatoonTemplate = 'ArtillerySCTA',
        Priority = 300,
        FormRadius = 1000,
        PriorityFunction = TAPrior.TechEnergyExist,
        BuilderConditions = {
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', {1, categories.ARTILLERY * categories.STRUCTURE} },
            },
        BuilderType = 'StructureForm',
    },
    Builder {
        BuilderName = 'SCTAMiniNukeAI',
        PlatoonTemplate = 'TacticalMissileSCTA',
        Priority = 300,
        BuilderConditions = {
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', {1, categories.TACTICALMISSILEPLATFORM * categories.STRUCTURE} },
            },
        BuilderType = 'StructureForm',
    },
}