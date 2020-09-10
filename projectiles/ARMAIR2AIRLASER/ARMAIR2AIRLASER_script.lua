#ARM Pheonix Laser
#ARMAIR2AIRLASER
#
#Script created by Raevn

local TALaserProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TALaserProjectile

ARMAIR2AIRLASER = Class(TALaserProjectile) {
	PolyTrail = '/mods/SCTAFix/effects/emitters/YELLOW_LASER_emit.bp',
}

TypeClass = ARMAIR2AIRLASER

