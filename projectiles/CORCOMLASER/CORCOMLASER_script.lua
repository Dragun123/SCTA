#CORE Commander Laser
#CORCOMLASER
#
#Script created by Raevn

local TALaserProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TALaserProjectile

CORCOMLASER = Class(TALaserProjectile) 
{
	PolyTrail = '/mods/SCTAFix/effects/emitters/RED_LASER_emit.bp',
}

TypeClass = CORCOMLASER
