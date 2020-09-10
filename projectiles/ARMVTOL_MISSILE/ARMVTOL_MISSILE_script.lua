#ARM Freedom Fighter Missile
#ARMVTOL_MISSILE
#
#Script created by Raevn

local TAMissileProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TAMissileProjectile

ARMVTOL_MISSILE = Class(TAMissileProjectile) 
{
	TrackTime = 5,
}

TypeClass = ARMVTOL_MISSILE
