#CORE Shark Torpedo Weapon
#CORSMART_TORPEDO
#
#Script created by Raevn

local TAUnderWaterProjectile = import('/mods/SCTA-master/lua/TAProjectiles.lua').TAUnderWaterProjectile

CORSMART_TORPEDO = Class(TAUnderWaterProjectile) {
	TrackTime = 3,

	PassDamageThread = function(self)
		local bp = self:GetLauncher():GetBlueprint().Weapon
		WaitSeconds(0.1)
		self.DamageData.DamageAmount = bp.DamageWater or 1500
		self.DamageData.DamageRadius = bp.DamageRadiusWater or 0.5
	end,
}

TypeClass = CORSMART_TORPEDO