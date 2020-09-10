#ARM Zeus Lightning Weapon
#LIGHTNING
#
#Script created by Raevn

local TALaserProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TALaserProjectile

LIGHTNING = Class(TALaserProjectile) 
{
	PolyTrail = '/mods/SCTAFix/effects/emitters/LIGHTNING_emit.bp',
}

TypeClass = LIGHTNING

