#ARM Defender - NS Missile
#ARMFRT_MISSILE
#
#Script created by Raevn

local TAMissileProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TAMissileProjectile

ARMFRT_MISSILE = Class(TAMissileProjectile) 
{
	TrackTime = 5,
}

TypeClass = ARMFRT_MISSILE
