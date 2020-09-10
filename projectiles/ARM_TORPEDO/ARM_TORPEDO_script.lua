#ARM Lurker Torpedo Weapon
#ARM_TORPEDO
#
#Script created by Raevn

local TAUnderWaterProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TAUnderWaterProjectile

ARM_TORPEDO = Class(TAUnderWaterProjectile) {
	TrackTime = 3,
}

TypeClass = ARM_TORPEDO