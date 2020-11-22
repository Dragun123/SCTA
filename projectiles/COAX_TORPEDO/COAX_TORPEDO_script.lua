#ARM Torpedo Launcher Torpedo Weapon
#COAX_TORPEDO
#
#Script created by Raevn

local TAUnderWaterProjectile = import('/mods/SCTA-master/lua/TAProjectiles.lua').TAUnderWaterProjectile

COAX_TORPEDO = Class(TAUnderWaterProjectile) {
	TrackTime = 3,
	
	PassDamageThread = function(self)
		local bp = self:GetLauncher():GetBlueprint().Weapon
		WaitSeconds(0.1)
		self.DamageData.DamageAmount = bp.DamageWater or 300
		self.DamageData.DamageRadius = bp.DamageRadiusWater or 0.5
	end,
}

TypeClass = COAX_TORPEDO
