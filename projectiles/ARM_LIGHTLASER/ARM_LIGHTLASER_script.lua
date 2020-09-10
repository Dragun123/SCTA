#ARM L.L.T. Laser
#ARM_LIGHTLASER
#
#Script created by Raevn

local TALaserProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TALaserProjectile

ARM_LIGHTLASER = Class(TALaserProjectile) 
{
	PolyTrail = '/mods/SCTAFix/effects/emitters/RED_LASER_emit.bp',
}

TypeClass = ARM_LIGHTLASER
