#ARM Flea - Fast Light Scout Kbot
#CORVOYR
#
#Script created by Raevn

local TACounter = import('/mods/SCTA-master/lua/TAMotion.lua').TACounter


CORVOYR = Class(TACounter) {
	
	OnCreate = function(self)
		TACounter.OnCreate(self)
		self.Spinners = {
			fork = CreateRotator(self, 'dish1', 'y', nil, 100, 50, 0),
		}
		self.Trash:Add(self.Spinners.fork)
	end,
}

TypeClass = CORVOYR
