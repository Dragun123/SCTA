#ARM Swatter Missile
#ARMAH_WEAPON
#
#Script created by Raevn

local TAMissileProjectile = import('/mods/SCTA-master/lua/TAProjectiles.lua').TAMissileProjectile

ARMAH_WEAPON = Class(TAMissileProjectile) 
{
	TrackTime = 5,
}

TypeClass = ARMAH_WEAPON
