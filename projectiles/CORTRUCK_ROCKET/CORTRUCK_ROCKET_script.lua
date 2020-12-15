#CORE Diplomat Rocket
#CORTRUCK_ROCKET
#
#Script created by Raevn

local TAMissileProjectile = import('/mods/SCTA-master/lua/TAProjectiles.lua').TAMissileProjectile

CORTRUCK_ROCKET = Class(TAMissileProjectile) {
	TrackTime = 5,

	OnCreate = function(self)
		TAMissileProjectile.OnCreate(self)
		self:ForkThread( self.MovementThread )
	end,

	MovementThread = function(self)
		WaitSeconds(3)
		self:TrackTarget(true)
		WaitSeconds(1)
	end,
}

TypeClass = CORTRUCK_ROCKET