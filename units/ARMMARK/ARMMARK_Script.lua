#ARM Flea - Fast Light Scout Kbot
#ARMMARK
#
#Script created by Raevn

local TACounter = import('/mods/SCTA-master/lua/TAMotion.lua').TACounter

ARMMARK = Class(TACounter) {
	
	OnCreate = function(self)
		TACounter.OnCreate(self)
		self.Spinners = {
			fork = CreateRotator(self, 'Ldish', 'x', nil, 50, 100, 0),
			dish2 = CreateRotator(self, 'Rdish', 'x', nil, 50, 100, 0),
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
	end,

	OnIntelDisabled = function(self)
		self.Spinners.dish2:SetTargetSpeed(0)
		TACounter.OnIntelDisabled(self)
	end,


	OnIntelEnabled = function(self)
		self.Spinners.dish2:SetTargetSpeed(-100)
		TACounter.OnIntelEnabled(self)
	end,
}

TypeClass = ARMMARK
