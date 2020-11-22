#ARM Lancet Torpedo Weapon
#ARMAIR_TORPEDO
#
#Script created by Raevn

local TAUnderWaterProjectile = import('/mods/SCTA-master/lua/TAProjectiles.lua').TAUnderWaterProjectile

ARMAIR_TORPEDO = Class(TAUnderWaterProjectile) {
	TrackTime = 10,

	PassDamageThread = function(self)
		local bp = self:GetLauncher():GetBlueprint().Weapon
		WaitSeconds(0.1)
		self.DamageData.DamageAmount = bp.DamageWater or 1750
		self.DamageData.DamageRadius = bp.DamageRadiusWater or 0.5
	end,
}

TypeClass = ARMAIR_TORPEDO