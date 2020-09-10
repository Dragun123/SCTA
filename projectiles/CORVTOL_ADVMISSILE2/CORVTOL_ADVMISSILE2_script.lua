#CORE Vamp Missile
#CORVTOL_ADVMISSILE2
#
#Script created by Raevn

local TAMissileProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TAMissileProjectile

CORVTOL_ADVMISSILE2 = Class(TAMissileProjectile) 
{
	TrackTime = 7,
}

TypeClass = CORVTOL_ADVMISSILE2
