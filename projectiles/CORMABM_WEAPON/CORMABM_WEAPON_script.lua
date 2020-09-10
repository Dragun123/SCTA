

local TAMissileProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TAMissileProjectile

CORMABM_WEAPON = Class(TAMissileProjectile) 
{
	TrackTime = 2,
}

TypeClass = CORMABM_WEAPON
