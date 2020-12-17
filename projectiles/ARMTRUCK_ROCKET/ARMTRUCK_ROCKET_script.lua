#ARM Merl Rocket
#ARMTRUCK_ROCKET
#
#Script created by Raevn

local TAMissileProjectile = import('/mods/SCTA-master/lua/TAProjectiles.lua').TAMissileProjectile

ARMTRUCK_ROCKET = Class(TAMissileProjectile) {
	OnCreate = function(self)
		TAMissileProjectile.OnCreate(self)
		self:ForkThread( self.MovementThread )
		self.TrackTime = 5
	end,

	MovementThread = function(self)
		WaitSeconds(1)
		self:TrackTarget(true)
		WaitSeconds(1)
	end,
}

TypeClass = ARMTRUCK_ROCKET