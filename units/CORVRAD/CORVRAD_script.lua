#CORE Informer - Mobile Radar
#CORVRAD
#
#Script created by Raevn
local TACounter = import('/mods/SCTA-master/lua/TAMotion.lua').TACounter

CORVRAD = Class(TACounter) {
	OnCreate = function(self)
		TACounter.OnCreate(self)
		self.Spinners = {
			fork = CreateRotator(self, 'dish', 'y', nil, 100, 50, 0),
		}
		self.Trash:Add(self.Spinners.fork)
	end,
}
TypeClass = CORVRAD