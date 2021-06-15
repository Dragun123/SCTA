#CORE Deleter - Mobile Radar Jammer
#CORETER
#
#Script created by Raevn

local TASeaCounter = import('/mods/SCTA-master/lua/TAMotion.lua').TASeaCounter
local DefaultWeapon = import('/lua/sim/DefaultWeapons.lua').DefaultProjectileWeapon

CORSJAM = Class(TASeaCounter) {
	OnCreate = function(self)
		TASeaCounter.OnCreate(self)
		self.Spinners = {
			fork = CreateRotator(self, 'fork', 'z', nil, 100, 50, 0),
		}
		self.Trash:Add(self.Spinners.fork)
	end,

Weapons = {
	Turret01 = Class(DefaultWeapon) {
	},
},
}
TypeClass = CORSJAM