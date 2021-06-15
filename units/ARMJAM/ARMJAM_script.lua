#ARM Jammer - Mobile Radar Jammer
#ARMJAM
#
#Script created by Raevn

local TACounter = import('/mods/SCTA-master/lua/TAMotion.lua').TACounter

ARMJAM = Class(TACounter) {
	OnCreate = function(self)
		TACounter.OnCreate(self)
		self.Spinners = {
			fork = CreateRotator(self, 'Jammer', 'z', nil, 100, 50, 0),
		}
		self.Trash:Add(self.Spinners.fork)
	end,
}
TypeClass = ARMJAM