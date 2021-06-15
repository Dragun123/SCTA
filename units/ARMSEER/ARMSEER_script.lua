#ARM Seer - Mobile Radar
#ARMSEER
#
#Script created by Raevn

local TACounter = import('/mods/SCTA-master/lua/TAMotion.lua').TACounter

ARMSEER = Class(TACounter) {
	OnCreate = function(self)
		TACounter.OnCreate(self)
		self.Spinners = {
			fork = CreateRotator(self, 'Radar', 'y', nil, 100, 50, 0),
		}
		self.Trash:Add(self.Spinners.fork)
	end,
}
TypeClass = ARMSEER