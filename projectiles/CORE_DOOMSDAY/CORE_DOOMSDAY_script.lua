#CORE Doomsday Machine Laser
#CORE_DOOMSDAY
#
#Script created by Raevn

local TALaserProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TALaserProjectile

CORE_DOOMSDAY = Class(TALaserProjectile) 
{
	PolyTrail = '/mods/SCTAFix/effects/emitters/BLUE_LASER_emit.bp',
}

TypeClass = CORE_DOOMSDAY

