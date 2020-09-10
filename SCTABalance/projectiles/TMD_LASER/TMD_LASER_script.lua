local TALaserProjectile = import('/mods/SCTA/lua/TAProjectiles.lua').TALaserProjectile

TMD_LASER = Class(TALaserProjectile) 
{
	PolyTrail = '/mods/SCTA/effects/emitters/GREEN_LASER_emit.bp',
}

TypeClass = TMD_LASER

