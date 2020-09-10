#ARM Penetrator Laser
#ARMMANNI_WEAPON
#
#Script created by Raevn

local TALaserProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TALaserProjectile

ARMMANNI_WEAPON = Class(TALaserProjectile) 
{
	PolyTrail = '/mods/SCTAFix/effects/emitters/BLUE_LASER_emit.bp',
}

TypeClass = ARMMANNI_WEAPON

