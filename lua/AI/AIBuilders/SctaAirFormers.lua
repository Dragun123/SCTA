local TAPrior = import('/mods/SCTA-master/lua/AI/TAEditors/TAPriorityManager.lua')
local TASlow = '/mods/SCTA-master/lua/AI/TAEditors/TAAIUtils.lua'
SKY = categories.AIR * categories.MOBILE
STEALTH = categories.armhawk + categories.corvamp


BuilderGroup {
    BuilderGroupName = 'SCTAAIAirFormers',
    BuildersType = 'PlatoonFormBuilder', -- A PlatoonFormBuilder is for builder groups of units.
    Builder {
        BuilderName = 'SCTAAI Air Scout',
        PlatoonTemplate = 'T1AirScoutFormSCTA',
        Priority = 150,
        InstanceCount = 5,
        BuilderType = 'Scout',
        BuilderData = {
        }, 
        BuilderConditions = {
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', { 1, SKY * categories.SCOUT * categories.OVERLAYRADAR} },
         },
    },
    Builder {
        BuilderName = 'SCTAAI Bomber Attack',
        PlatoonTemplate = 'SCTABomberAttack',
        Priority = 200,
        InstanceCount = 50,
        BuilderType = 'AirForm',
        BuilderData = {
        },        
        BuilderConditions = { 
            --{ TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', { 1, SKY * categories.BOMBER} },
            },
        },
    Builder {
        BuilderName = 'SCTAAI Air Intercept',
        PlatoonTemplate = 'IntieAISCTA',
        Priority = 100,
        PlatoonAddBehaviors = { 'SCTAAirUnitRefit' },                              
        InstanceCount = 50,
        BuilderType = 'AirForm', 
        BuilderData = {
        },     
        BuilderConditions = { 
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', { 1, SKY * categories.ANTIAIR * categories.TECH1} },
        },
    },
    Builder {
        BuilderName = 'SCTAAI Air Intercept Stealth',
        PlatoonTemplate = 'IntieAIStealthSCTA',
        PriorityFunction = TAPrior.UnitProduction,
        Priority = 110,
        InstanceCount = 50,                          
        BuilderType = 'AirForm',
        BuilderData = {
            Energy = true,
            Stealth = true,
        },        
        BuilderConditions = { 
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', { 1, (SKY * (categories.GROUNDATTACK + categories.BOMBER)) + STEALTH} },
            },
        },   
    Builder {
        BuilderName = 'SCTAAI Air Intercept Omni',
        PlatoonTemplate = 'IntieAISCTAEnd',
        PriorityFunction = TAPrior.GantryConstruction,
        Priority = 110,
        InstanceCount = 50,
        PlatoonAddBehaviors = { 'SCTAAirUnitRefit' },                              
        BuilderType = 'AirForm',
        BuilderData = {
            Energy = true,
            Interceptor = true,
        },         
        BuilderConditions = { 
            { TASlow, 'TAHaveGreaterThanArmyPoolWithCategory', { 1, SKY * categories.ANTIAIR - categories.BOMBER - categories.GROUNDATTACK} },
        },
    },
}