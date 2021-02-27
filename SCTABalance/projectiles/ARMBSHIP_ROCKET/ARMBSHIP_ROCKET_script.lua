#ARM Ranger Rocket
#ARMMSHIP_ROCKET
#
#Script created by Raevn

local TAMissileProjectile = import('/mods/SCTA-master/lua/TAProjectiles.lua').TAMissileProjectile

ARMBSHIP_ROCKET = Class(TAMissileProjectile) {
	OnCreate = function(self)
		TAMissileProjectile.OnCreate(self)
		self.TrackTime = 5
		self:ForkThread( self.MovementThread )
	end,

	MovementThread = function(self)
		WaitSeconds(2)
		self:TrackTarget(true)
		WaitSeconds(2)
	end,
}
TypeClass = ARMBSHIP_ROCKET