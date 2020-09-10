#ARM Stingray Laser
#ARMFHLT_LASER
#
#Script created by Raevn

local TALaserProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TALaserProjectile

ARMFHLT_LASER = Class(TALaserProjectile) 
{
	PolyTrail = '/mods/SCTAFix/effects/emitters/GREEN_LASER_emit.bp',
}

TypeClass = ARMFHLT_LASER

