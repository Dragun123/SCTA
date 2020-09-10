#ARM Archer Missile
#ARMAAS_WEAPON1
#
#Script created by Raevn

local TAMissileProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TAMissileProjectile

ARMAAS_WEAPON1 = Class(TAMissileProjectile) 
{
	TrackTime = 5,
}

TypeClass = ARMAAS_WEAPON1
