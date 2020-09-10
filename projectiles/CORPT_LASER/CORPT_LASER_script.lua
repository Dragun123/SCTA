#CORE Searcher Laser
#CORPT_LASER
#
#Script created by Raevn

local TALaserProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TALaserProjectile

CORPT_LASER = Class(TALaserProjectile) 
{
	PolyTrail = '/mods/SCTAFix/effects/emitters/YELLOW_LASER_emit.bp',
}

TypeClass = CORPT_LASER

