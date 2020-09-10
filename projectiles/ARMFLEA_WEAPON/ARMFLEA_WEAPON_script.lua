#ARM Flea Laser
#ARMFLEA_WEAPON
#
#Script created by Raevn

local TALaserProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TALaserProjectile

ARMFLEA_WEAPON = Class(TALaserProjectile) 
{
	PolyTrail = '/mods/SCTAFix/effects/emitters/GREEN_LASER_emit.bp',
}

TypeClass = ARMFLEA_WEAPON

