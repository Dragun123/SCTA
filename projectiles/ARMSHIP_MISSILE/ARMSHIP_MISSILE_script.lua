#ARM Ranger Missile
#ARMSHIP_MISSILE
#
#Script created by Raevn

local TAMissileProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TAMissileProjectile

ARMSHIP_MISSILE = Class(TAMissileProjectile) 
{
	TrackTime = 5,
}

TypeClass = ARMSHIP_MISSILE
