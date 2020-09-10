#CORE Krogoth Laser
#CORKROG_HEAD
#
#Script created by Raevn

local TALaserProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TALaserProjectile

CORKROG_HEAD = Class(TALaserProjectile) 
{
	PolyTrail = '/mods/SCTAFix/effects/emitters/BLUE_LASER_emit.bp',
}

TypeClass = CORKROG_HEAD

