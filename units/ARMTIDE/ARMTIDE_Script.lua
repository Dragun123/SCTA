#ARM Tidal Generator - Produces Energy
#ARMTIDE
#
#Script created by Raevn

local TATidal = import('/mods/SCTA-master/lua/TAWeather.lua').TATidal

ARMTIDE = Class(TATidal) {
	OnCreate = function(self)
		TATidal.OnCreate(self)
		self.Spinners = {
			wheel = CreateRotator(self, 'Turbine', 'y', nil, 0, 0, 0),
		}
		self.Trash:Add(self.Spinners.wheel)
	end,
}

TypeClass = ARMTIDE
