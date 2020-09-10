#CORE Gaat Gun Laser
#CORE_LASERH1
#
#Script created by Raevn

local TALaserProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TALaserProjectile

CORE_LASERH1 = Class(TALaserProjectile) 
{
	PolyTrail = '/mods/SCTAFix/effects/emitters/GREEN_LASER_emit.bp',
}

TypeClass = CORE_LASERH1

