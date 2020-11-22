#ARM Advanced Torpedo Launcher Torpedo Weapon
#ARMATL_TORPEDO
#
#Script created by Raevn

local TAUnderWaterProjectile = import('/mods/SCTA-master/lua/TAProjectiles.lua').TAUnderWaterProjectile

ARMATL_TORPEDO = Class(TAUnderWaterProjectile) {
	TrackTime = 3,

	PassDamageThread = function(self)
		local bp = self:GetLauncher():GetBlueprint().Weapon
		WaitSeconds(0.1)
		self.DamageData.DamageAmount = bp.DamageWater or 1200
		self.DamageData.DamageRadius = bp.DamageRadiusWater or 1
	end,
}

TypeClass = ARMATL_TORPEDO