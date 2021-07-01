local taUnitClass = Unit
local TADeath = import('/mods/SCTA-master/lua/TADeath.lua')
Unit = Class(taUnitClass) {
    OnStopBeingCaptured = function(self, captor)
        taUnitClass.OnStopBeingCaptured(self, captor)
        local aiBrain = self:GetAIBrain()
        if aiBrain.SCTAAI then
            self:Kill()
        end
    end,

    CreateWreckage = function (self, overkillRatio)
        if self.Necro then
            TADeath.CreateHeapProp(self, overkillRatio)
        else
            taUnitClass.CreateWreckage(self, overkillRatio)
        end
    end,

}