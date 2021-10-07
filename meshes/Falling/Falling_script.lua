--------------------------------------------------------------------------------
--  Original Code/Unit/Dummy from BrewLan/Balthazar
--------------------------------------------------------------------------------
local StructureUnit = import('/lua/defaultunits.lua').StructureUnit

Falling = Class(StructureUnit) {

    OnDamage = function(self, instigator, amount, vector, damageType)
        if self.Parent then
            self.Parent:OnDamage(instigator, amount, vector, damageType)
        end
    end,
}

TypeClass = Falling
