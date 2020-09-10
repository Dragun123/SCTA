#CORE Vamp Missile
#CORVTOL_ADVMISSILE
#
#Script created by Raevn

local TAMissileProjectile = import('/mods/SCTA/lua/TAProjectiles.lua').TAMissileProjectile

CORVTOL_ADVMISSILE = Class(TAMissileProjectile) 
{
	TrackTime = 7,
}

TypeClass = CORVTOL_ADVMISSILE
