#ARM Spider Paralyzer Weapon
#ARM_PARALYSER
#
#Script created by Raevn

local TALaserProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TALaserProjectile

ARM_PARALYSER = Class(TALaserProjectile) 
{
	PolyTrail = '/mods/SCTAFix/effects/emitters/RED_LASER_emit.bp',
}

TypeClass = ARM_PARALYSER
