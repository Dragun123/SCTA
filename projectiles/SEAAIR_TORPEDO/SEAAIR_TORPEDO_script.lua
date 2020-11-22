#CORE Titan Torpedo Weapon
#CORAIR_TORPEDO
#
#Script created by Raevn

local TAUnderWaterProjectile = import('/mods/SCTA-master/lua/TAProjectiles.lua').TAUnderWaterProjectile

SEAAIR_TORPEDO = Class(TAUnderWaterProjectile) {
	TrackTime = 10,

	PassDamageThread = function(self)
		local bp = self:GetLauncher():GetBlueprint().Weapon
		WaitSeconds(0.1)
		self.DamageData.DamageAmount = bp.DamageWater or 2500
		self.DamageData.DamageRadius = bp.DamageRadiusWater or 0.2
	end,
}

TypeClass = SEAAIR_TORPEDO