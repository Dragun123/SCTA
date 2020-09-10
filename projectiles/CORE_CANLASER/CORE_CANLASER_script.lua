#CORE The Can Laser
#CORE_CANLASER
#
#Script created by Raevn

local TALaserProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TALaserProjectile

CORE_CANLASER = Class(TALaserProjectile) 
{
	PolyTrail = '/mods/SCTAFix/effects/emitters/GREEN_LASER_emit.bp',
}

TypeClass = CORE_CANLASER

