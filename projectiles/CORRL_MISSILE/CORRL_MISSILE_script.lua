#CORE Pulverizer Missile
#CORRL_MISSILE
#
#Script created by Raevn

local TAMissileProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TAMissileProjectile

CORRL_MISSILE = Class(TAMissileProjectile) 
{
	TrackTime = 5,
}

TypeClass = CORRL_MISSILE
