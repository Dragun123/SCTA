#CORE Snake Torpedo Weapon
#CORE_TORPEDO
#
#Script created by Raevn

local TAUnderWaterProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TAUnderWaterProjectile

CORE_TORPEDO = Class(TAUnderWaterProjectile) {
	TrackTime = 3,
}

TypeClass = CORE_TORPEDO