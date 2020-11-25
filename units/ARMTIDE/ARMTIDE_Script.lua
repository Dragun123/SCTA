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

	OnStopBeingBuilt = function(self,builder,layer)
		TATidal.OnStopBeingBuilt(self,builder,layer)
		--SPIN wheel around y-axis SPEED <35.00>
		self.Spinners.wheel:SetSpeed(35)
	end,



	OnKilled = function(self, instigator, type, overkillRatio)
		self.Spinners.wheel:SetSpeed(0)
		TATidal.OnKilled(self, instigator, type, overkillRatio)
	end,
}

TypeClass = ARMTIDE
