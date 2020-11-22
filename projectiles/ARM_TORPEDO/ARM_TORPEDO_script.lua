#ARM Lurker Torpedo Weapon
#ARM_TORPEDO
#
#Script created by Raevn

local TAUnderWaterProjectile = import('/mods/SCTA-master/lua/TAProjectiles.lua').TAUnderWaterProjectile

ARM_TORPEDO = Class(TAUnderWaterProjectile) {
	TrackTime = 3,

	PassDamageThread = function(self)
		local bp = self:GetLauncher():GetBlueprint().Weapon
		WaitSeconds(0.1)
		self.DamageData.DamageAmount = bp.DamageWater or 200
		self.DamageData.DamageRadius = bp.DamageRadiusWater or 0.5
	end,
}

TypeClass = ARM_TORPEDO