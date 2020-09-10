#CORE Slasher Missile
#CORTRUCK_MISSILE
#
#Script created by Raevn

local TAMissileProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TAMissileProjectile

CORTRUCK_MISSILE = Class(TAMissileProjectile) 
{
	TrackTime = 5,
}

TypeClass = CORTRUCK_MISSILE
