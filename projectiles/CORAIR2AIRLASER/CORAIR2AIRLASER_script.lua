#CORE Hurricane Laser
#CORAIR2AIRLASER
#
#Script created by Raevn

local TALaserProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TALaserProjectile

CORAIR2AIRLASER = Class(TALaserProjectile) {
	PolyTrail = '/mods/SCTAFix/effects/emitters/YELLOW_LASER_emit.bp',
}

TypeClass = CORAIR2AIRLASER

