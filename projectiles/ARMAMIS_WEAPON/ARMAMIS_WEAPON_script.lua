

local TAMissileProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TAMissileProjectile

ARMAMIS_WEAPON = Class(TAMissileProjectile) 
{
	TrackTime = 2,
}

TypeClass = ARMAMIS_WEAPON
