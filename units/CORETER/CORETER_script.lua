#CORE Deleter - Mobile Radar Jammer
#CORETER
#
#Script created by Raevn

local TACounter = import('/mods/SCTA-master/lua/TAMotion.lua').TACounter

CORETER = Class(TACounter) {
	OnCreate = function(self)
		TACounter.OnCreate(self)
		self.Spinners = {
			fork = CreateRotator(self, 'fork', 'z', nil, 100, 50, 0),
		}
		self.Trash:Add(self.Spinners.fork)
	end,
}
TypeClass = CORETER