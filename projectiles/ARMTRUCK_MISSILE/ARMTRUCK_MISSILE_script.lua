#ARM Samson Missile
#ARMTRUCK_MISSILE
#
#Script created by Raevn

local TAMissileProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TAMissileProjectile

ARMTRUCK_MISSILE = Class(TAMissileProjectile) 
{
	TrackTime = 5,
}

TypeClass = ARMTRUCK_MISSILE
