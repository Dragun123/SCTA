#ARM Annihilator Laser
#ARM_TOTAL_ANNIHILATOR
#
#Script created by Raevn

local TALaserProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TALaserProjectile

ARM_TOTAL_ANNIHILATOR = Class(TALaserProjectile) 
{
	PolyTrail = '/mods/SCTAFix/effects/emitters/BLUE_LASER_emit.bp',
}

TypeClass = ARM_TOTAL_ANNIHILATOR

