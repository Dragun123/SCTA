#CORE Enforcer, Executioner Depth Charge Weapon
#COREDEPTHCHARGE
#
#Script created by Raevn

local TAUnderWaterProjectile = import('/mods/SCTA-master/lua/TAProjectiles.lua').TAUnderWaterProjectile

COREDEPTHCHARGE = Class(TAUnderWaterProjectile) {
    PassDamageThread = function(self)
        local bp = self:GetLauncher():GetBlueprint().Weapon
        WaitSeconds(0.1)
        self.DamageData.DamageAmount = bp.DamageWater or 250
        self.DamageData.DamageRadius = bp.DamageRadiusWater or 0.5
    end,
}

TypeClass = COREDEPTHCHARGE
