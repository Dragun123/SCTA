#CORE Warlord Laser
#COR_BATSLASER
#
#Script created by Raevn

local TALaserProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TALaserProjectile

COR_BATSLASER = Class(TALaserProjectile) 
{
	PolyTrail = '/mods/SCTAFix/effects/emitters/GREEN_LASER_emit.bp',
}

TypeClass = COR_BATSLASER

