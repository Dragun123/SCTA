#ARM SPY - Fast Light Scout Kbot
#CORSPY
#
#Script created by Raevn

local TACounter = import('/mods/SCTA-master/lua/TAMotion.lua').TACounter 

CORSPY = Class(TACounter) {
	OnCreate = function(self)
		TACounter.OnCreate(self)
		self.Disc = {
			fork = CreateRotator(self, 'jam', 'y', nil, 25, 25, 25),
		}
		self.Trash:Add(self.Disc.fork)
    end,

}

TypeClass = CORSPY
