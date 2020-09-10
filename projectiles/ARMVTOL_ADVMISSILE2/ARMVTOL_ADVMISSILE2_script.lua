#ARM Hawk Missile 2
#ARMVTOL_ADVMISSILE2
#
#Script created by Raevn

local TAMissileProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TAMissileProjectile

ARMVTOL_ADVMISSILE2 = Class(TAMissileProjectile) 
{
	TrackTime = 7,
}

TypeClass = ARMVTOL_ADVMISSILE2
