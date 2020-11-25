#ARM Eagle - Radar Plane
#CORHUNT
#
#Script created by Raevn

local TASeaair = import('/mods/SCTA-master/lua/TAair.lua').TASeaair

CORHUNT = Class(TASeaair) {

	OnCreate = function(self)
		TASeaair.OnCreate(self)
		self.Sliders = {
			chassis = CreateSlider(self, 0),
		}
		for k, v in self.Sliders do
			self.Trash:Add(v)
		end
		self.Spinners = {
			radar1 = CreateRotator(self, 'Lwing', 'z', nil, 0, 0, 0),
			radar2 = CreateRotator(self, 'Rwing', 'z', nil, 0, 0, 0),
			Sonar = CreateRotator(self, 'Lsonar', 'x', nil, 0, 0, 0),
			Sonar2 = CreateRotator(self, 'Rsonar', 'x', nil, 0, 0, 0),
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
	end,


	OpenWings = function(self)

		--MOVE Rwing to x-axis <4.45> SPEED <3.00>;
		self.Spinners.radar1:SetGoal(-90)
		self.Spinners.radar1:SetSpeed(60)

		--MOVE Lwing to x-axis <-4.45> SPEED <3.00>;
		self.Spinners.radar2:SetGoal(90)
		self.Spinners.radar2:SetSpeed(60)
		--WaitSeconds(1)
		self.Spinners.Sonar2:SetSpeed(90)
		self.Spinners.Sonar:SetSpeed(90)
	end,

	CloseWings = function(self)
		self.Spinners.Sonar:SetSpeed(0)
		self.Spinners.Sonar2:SetSpeed(0)
		--WaitSeconds(1)
			--MOVE Rwing to x-axis <4.45> SPEED <3.00>;
			self.Spinners.radar1:SetGoal(0)
			self.Spinners.radar1:SetSpeed(90)
			--MOVE Lwing to x-axis <-4.45> SPEED <3.00>;
			self.Spinners.radar2:SetGoal(0)
			self.Spinners.radar2:SetSpeed(90)
	end,
}

TypeClass = CORHUNT