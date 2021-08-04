#CORE Tidal Generator - Produces Energy
#CORTIDE
#
#Script created by Raevn

local TATidal = import('/mods/SCTA-master/lua/TAWeather.lua').TATidal

CORTIDE = Class(TATidal) {
	OnCreate = function(self)
		TATidal.OnCreate(self)
		self.Spinners = {
			wheel = CreateRotator(self, 'wheel', 'y', nil, 0, 0, 0),
		}
		self.Trash:Add(self.Spinners.wheel)
	end,
}


TypeClass = CORTIDE
