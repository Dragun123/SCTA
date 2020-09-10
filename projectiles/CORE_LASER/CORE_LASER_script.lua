#CORE Weasel Laser
#CORE_LASER
#
#Script created by Raevn

local TALaserProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TALaserProjectile

CORE_LASER = Class(TALaserProjectile) 
{
	PolyTrail = '/mods/SCTAFix/effects/emitters/YELLOW_LASER_emit.bp',
}

TypeClass = CORE_LASER

