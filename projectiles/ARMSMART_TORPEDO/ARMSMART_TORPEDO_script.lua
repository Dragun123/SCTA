#ARM Pirahna Torpedo Weapon
#ARMSMART_TORPEDO
#
#Script created by Raevn

local TAUnderWaterProjectile = import('/mods/SCTA-master/lua/TAProjectiles.lua').TAUnderWaterProjectile

ARMSMART_TORPEDO = Class(TAUnderWaterProjectile) {
	TrackTime = 3,
}

TypeClass = ARMSMART_TORPEDO