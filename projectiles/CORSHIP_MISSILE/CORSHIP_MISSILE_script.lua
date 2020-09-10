#CORE Hydra Missile
#CORSHIP_MISSILE
#
#Script created by Raevn

local TAMissileProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TAMissileProjectile

CORSHIP_MISSILE = Class(TAMissileProjectile) 
{
	TrackTime = 5,
}

TypeClass = CORSHIP_MISSILE
