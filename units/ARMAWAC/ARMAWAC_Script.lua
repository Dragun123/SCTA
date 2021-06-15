#ARM Eagle - Radar Plane
#ARMAWAC
#
#Script created by Raevn

local TAIntelAir = import('/mods/SCTA-master/lua/TAair.lua').TAIntelAir

ARMAWAC = Class(TAIntelAir) {

	OnCreate = function(self)
		TAIntelAir.OnCreate(self)
		self.Spinners = {
			radar = CreateRotator(self, 'radar', 'y', nil, 0, 0, 0),
		}
		self.Sliders = {
			Rwing = CreateSlider(self, 'Rwing'),
			Lwing = CreateSlider(self, 'Lwing'),
		}
		for k, v in self.Sliders do
			self.Trash:Add(v)
		end
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
	end,

	OnStopBeingBuilt = function(self,builder,layer)
		TAIntelAir.OnStopBeingBuilt(self,builder,layer)
		self.Spinners.radar:SetSpeed(90)
	end,

	OpenWings = function(self)

		--MOVE Rwing to x-axis <4.45> SPEED <3.00>;
		self.Sliders.Rwing:SetGoal(-3,0,0)
		self.Sliders.Rwing:SetSpeed(3)

		--MOVE Lwing to x-axis <-4.45> SPEED <3.00>;
		self.Sliders.Lwing:SetGoal(3,0,0)
		self.Sliders.Lwing:SetSpeed(3)

	end,

	CloseWings = function(self)

		--MOVE Rwing to x-axis <0> SPEED <3.00>;
		self.Sliders.Rwing:SetGoal(0,0,0)
		self.Sliders.Rwing:SetSpeed(3)

		--MOVE Lwing to x-axis <0> SPEED <3.00>;
		self.Sliders.Lwing:SetGoal(0,0,0)
		self.Sliders.Lwing:SetSpeed(3)
	end,
}

TypeClass = ARMAWAC