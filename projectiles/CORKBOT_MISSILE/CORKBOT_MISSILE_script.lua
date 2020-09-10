#CORE Crasher, Searcher Missile
#CORKBOT_MISSILE
#
#Script created by Raevn

local TAMissileProjectile = import('/mods/SCTAFix/lua/TAProjectiles.lua').TAMissileProjectile

CORKBOT_MISSILE = Class(TAMissileProjectile) 
{
	TrackTime = 5,
}

TypeClass = CORKBOT_MISSILE
