#CORE Instigator Laser
#GATOR_LASER
#
#Script created by Raevn

local TALaserProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TALaserProjectile

GATOR_LASER = Class(TALaserProjectile) 
{
	PolyTrail = '/mods/SCTAFix/effects/emitters/RED_LASER_emit.bp',
}

TypeClass = GATOR_LASER

