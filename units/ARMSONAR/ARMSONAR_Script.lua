#ARM Sonar Station - Locates Water Units
#ARMSONAR
#
#Script created by Raevn

local TAStructure = import('/mods/SCTA-master/lua/TAStructure.lua').TAStructure

ARMSONAR = Class(TAStructure) {

	OnCreate = function(self)
		TAStructure.OnCreate(self)
		self.Spinners = {
			base = CreateRotator(self, 'Base', 'y', nil, 0, 0, 0),
		}
		self.Trash:Add(self.Spinners.base)
	end,

	OnIntelDisabled = function(self)
		--SPIN base around y-axis  SPEED <0>;
		self.Spinners.base:SetSpeed(0)
		TAStructure.OnIntelDisabled(self)
	end,

	OnIntelEnabled = function(self)
		--SPIN base around y-axis  SPEED <60.01>;
		self.Spinners.base:SetSpeed(60)
		TAStructure.OnIntelEnabled(self)
	end,

}

TypeClass = ARMSONAR
