#ARM Hawk Missile 2
#ARMVTOL_ADVMISSILE2
#
#Script created by Raevn

local TAMissileProjectile = import('/mods/SCTA-master/lua/TAProjectiles.lua').TAMissileProjectile

ARMVTOL_ADVMISSILE2 = Class(TAMissileProjectile) 
{
	TrackTime = 7,
}

TypeClass = ARMVTOL_ADVMISSILE2
