local taUnitClass = Unit
local TADeath = import('/mods/SCTA-master/lua/TADeath.lua')
Unit = Class(taUnitClass) {
    CreateWreckage = function (self, overkillRatio)
        if self.Necro then
            TADeath.CreateHeapProp(self, overkillRatio)
        else
            taUnitClass.CreateWreckage(self, overkillRatio)
        end
    end,

}