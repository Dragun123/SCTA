
local SCTABrainClass = AIBrain
---@class AIBrain: AIBrainHQComponent, AIBrainStatisticsComponent, AIBrainJammerComponent, AIBrainEnergyComponent, moho.aibrain_methods
---@field AI boolean
---@field Status BrainState
---@field Human boolean
---@field Civilian boolean
---@field Trash TrashBag
---@field BrainType 'Human' | 'AI'

AIBrain = Class(SCTABrainClass) {

    VOSounds = {
        -- {timeout delay, default cue, observers}
        NuclearLaunchDetected =        {timeout = 1, bank = nil, obs = true},
        OnTransportFull =              {timeout = 1, bank = nil},
        OnFailedUnitTransfer =         {timeout = 10, bank = 'Computer_Computer_CommandCap_01298'},
        OnPlayNoStagingPlatformsVO =   {timeout = 5, bank = 'XGG_Computer_CV01_04756'},
        OnPlayBusyStagingPlatformsVO = {timeout = 5, bank = 'XGG_Computer_CV01_04755'},
        OnPlayCommanderUnderAttackVO = {timeout = 15, bank = 'Computer_Computer_Commanders_01314'},
        TECHAchievedTA = {timeout = 15,  bank = 'Computer_Computer_UnitRevalation_01370'},
    },

    ---base game unlock
    ---Computer_Computer_UnitRevalation_01370
    ---Computer_Computer_UnitRevalation_01372
    TECHTAchieve = function(self)
        self:PlayVOSound('TECHAchievedTA')
    --self:PlayVOSound('TECH3TAchieve', Sound {Bank = 'TA_Sound', Cue = 'VICTORY4'})
    end,

}
