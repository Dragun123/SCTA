#ARM Wombat Rocket
#ARMMH_WEAPON
#
#Script created by Raevn

local TAMissileProjectile = import('/mods/SCTA-master/lua/TAProjectiles.lua').TAMissileProjectile

ARMTRUCK_ROCKET = Class(TAMissileProjectile) {

	OnCreate = function(self)
		TAMissileProjectile.OnCreate(self)
		self.TrackTime = 3
		self:ForkThread( self.MovementThread )
	end,

	MovementThread = function(self)
		WaitSeconds(1)
		self:TrackTarget(true)
		WaitSeconds(1)
	end,
}

TypeClass = ARMTRUCK_ROCKET