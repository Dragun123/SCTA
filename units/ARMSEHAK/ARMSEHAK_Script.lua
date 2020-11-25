#ARM Eagle - Radar Plane
#ARMSEHAK
#
#Script created by Raevn

local TASeaair = import('/mods/SCTA-master/lua/TAair.lua').TASeaair

ARMSEHAK = Class(TASeaair) {

	OnCreate = function(self)
		TASeaair.OnCreate(self)
		self.Spinners = {
			radar1 = CreateRotator(self, 'Sonarholder1', 'y', nil, 0, 0, 0),
			radar2 = CreateRotator(self, 'Sonarholder2', 'y', nil, 0, 0, 0),
		}
		self.Sliders = {
			chassis = CreateSlider(self, 0),
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
		TASeaair.OnStopBeingBuilt(self,builder,layer)
		self.Spinners.radar1:SetSpeed(90)
		self.Spinners.radar2:SetSpeed(90)
	end,

	OpenWings = function(self)

		--MOVE Rwing to x-axis <4.45> SPEED <3.00>;
		self.Sliders.Rwing:SetGoal(-4.45,0,0)
		self.Sliders.Rwing:SetSpeed(3)

		--MOVE Lwing to x-axis <-4.45> SPEED <3.00>;
		self.Sliders.Lwing:SetGoal(4.45,0,0)
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

TypeClass = ARMSEHAK