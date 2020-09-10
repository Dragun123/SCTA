#CORE Avenger Missile
#CORVTOL_MISSILE
#
#Script created by Raevn

local TAMissileProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TAMissileProjectile

CORVTOL_MISSILE = Class(TAMissileProjectile) 
{
	TrackTime = 5,
}

TypeClass = CORVTOL_MISSILE
