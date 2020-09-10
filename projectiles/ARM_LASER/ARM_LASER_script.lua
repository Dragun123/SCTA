#ARM Jeffy Laser
#ARM_LASER
#
#Script created by Raevn

local TALaserProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TALaserProjectile

ARM_LASER = Class(TALaserProjectile) 
{
	PolyTrail = '/mods/SCTAFix/effects/emitters/YELLOW_LASER_emit.bp',
}

TypeClass = ARM_LASER

