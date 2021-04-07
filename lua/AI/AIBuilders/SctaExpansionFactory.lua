
local UCBC = '/lua/editor/UnitCountBuildConditions.lua'
local EBC = '/lua/editor/EconomyBuildConditions.lua'
local SAI = '/lua/ScenarioPlatoonAI.lua'
local MIBC = '/lua/editor/MiscBuildConditions.lua'
local PLANT = (categories.FACTORY * categories.TECH1)
local LAB = (categories.FACTORY * categories.TECH2)
local PLATFORM = (categories.FACTORY * categories.TECH3)
local FUSION = (categories.ENERGYPRODUCTION * (categories.TECH2 + categories.TECH3)) * categories.STRUCTURE

BuilderGroup {
    BuilderGroupName = 'SCTAAIFactoryExpansions',
    BuildersType = 'EngineerBuilder',
    ----BotsFacts
    Builder {
        BuilderName = 'SCTAAI Expansion LandFac',
        PlatoonTemplate = 'EngineerBuilderSCTA',
        Priority = 104,
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'Factories', 3},
        BuilderConditions = {
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Land' } },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.75, 0.5 } },
            { EBC, 'GreaterThanEconStorageCurrent', { 100, 300 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
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
        BuilderName = 'SCTAAI T2LAND Expansion',
        PlatoonTemplate = 'EngineerBuilderSCTA123',
        Priority = 112,
        InstanceCount = 1,
        DelayEqualBuildPlattons = {'Factories', 3},
        BuilderConditions = {
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Land' } },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 0.5 } },
            { EBC, 'GreaterThanEconStorageCurrent', { 100, 300 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
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
    ---VEHICLEFacts
    Builder {
        BuilderName = 'SCTAAI Expansion LandFac2',
        PlatoonTemplate = 'EngineerBuilderSCTA',
        Priority = 98,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Land' } },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.9, 0.5 } },
            { EBC, 'GreaterThanEconStorageCurrent', { 100, 300 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
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
    ---AirFacts
    Builder {
        BuilderName = 'SCTAAI T1Expansion AirFac',
        PlatoonTemplate = 'EngineerBuilderSCTA',
        Priority = 103,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Air' } },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.9 } },
            { EBC, 'GreaterThanEconStorageCurrent', { 100, 1000 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
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
        PlatoonTemplate = 'EngineerBuilderSCTAEco12',
        Priority = 111,
        InstanceCount = 1,
        BuilderConditions = {
            { UCBC, 'FactoryCapCheck', { 'LocationType', 'Air' } },
            { EBC, 'GreaterThanEconEfficiencyOverTime', { 0.5, 0.9 } },
            { EBC, 'GreaterThanEconStorageCurrent', { 100, 300 } },
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = true,
            NumAssistees = 2,
            Construction = {
                BuildStructures = {
                    'T2AirFactory',
                }
            }
        }
    },
    ---EmergencyFacts
    Builder {
        BuilderName = 'SCTAAI LandExpansion Emergency',
        PlatoonTemplate = 'EngineerBuilderSCTA',
        Priority = 41,
        InstanceCount = 1,
        BuilderConditions = {
            { MIBC, 'LessThanGameTime', {900} },
            { EBC, 'GreaterThanEconStorageRatio', { 0.75, 0.5}},
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
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
        BuilderName = 'SCTAAI LandExpansionT2 Emergency2',
        PlatoonTemplate = 'EngineerBuilderSCTA123',
        Priority = 22,
        InstanceCount = 1,
        BuilderConditions = {
            { EBC, 'GreaterThanEconStorageRatio', { 0.75, 0.5}},
        },
        BuilderType = 'Any',
        BuilderData = {
            NeedGuard = false,
            DesiresAssist = true,
            NumAssistees = 2,
            Construction = {
                BuildClose = true,
                BuildStructures = {
                    'T2LandFactory2',
                }
            }
        }
    },
}

--[[Builder {
    BuilderName = 'SCTAAI LandExpansion Emergency2',
    PlatoonTemplate = 'EngineerBuilderSCTA',
    Priority = 511,
    InstanceCount = 1,
    BuilderConditions = {
        { MIBC, 'LessThanGameTime', {1200} },
        { EBC, 'GreaterThanEconStorageRatio', { 0.75, 0.5}},
    },
    BuilderType = 'Any',
    BuilderData = {
        NeedGuard = false,
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
    BuilderName = 'SCTAAI LandExpansionT2 Emergency',
    PlatoonTemplate = 'EngineerBuilderSCTA123',
    Priority = 602,
    InstanceCount = 1,
    BuilderConditions = {
        { MIBC, 'LessThanGameTime', {1500} },
        { EBC, 'GreaterThanEconStorageRatio', { 0.75, 0.5}},
    },
    BuilderType = 'Any',
    BuilderData = {
        NeedGuard = false,
        DesiresAssist = true,
        NumAssistees = 2,
        Construction = {
            BuildClose = true,
            BuildStructures = {
                'T2LandFactory',
            }
        }
    }
},]]