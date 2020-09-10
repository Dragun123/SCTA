#ARM Commander Laser
#ARMCOMLASER
#
#Script created by Raevn

local TALaserProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TALaserProjectile

ARMCOMLASER = Class(TALaserProjectile) 
{
	PolyTrail = '/mods/SCTAFix/effects/emitters/RED_LASER_emit.bp',
}

TypeClass = ARMCOMLASER
