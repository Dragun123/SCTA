#ARM Flea - Fast Light Scout Kbot
#ARMMARK
#
#Script created by Raevn

local TAWalking = import('/mods/SCTA-master/lua/TAMotion.lua').TAWalking
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon


ARMMARK = Class(TAWalking) {
	
	OnCreate = function(self)
		TAWalking.OnCreate(self)
		self.Spinners = {
			dish1 = CreateRotator(self, 'Ldish', 'x', nil, 0, 0, 0),
			dish2 = CreateRotator(self, 'Rdish', 'x', nil, 0, 0, 0),
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
	end,

	OnStopBeingBuilt = function(self,builder,layer)
		TAWalking.OnStopBeingBuilt(self,builder,layer)
		self.Spinners.dish1:SetSpeed(90)
		self.Spinners.dish2:SetSpeed(-90)
	end,
}

TypeClass = ARMMARK
