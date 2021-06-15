#CORE Titan - Torpedo Bomber
#ARMSEAP
#
#Script created by Raevn

local TASeaair = import('/mods/SCTA-master/lua/TAair.lua').TASeaair
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon

ARMSEAP = Class(TASeaair) {

	OnCreate = function(self)
		TASeaair.OnCreate(self)
		self.Sliders = {
			chassis = CreateSlider(self, 0),
		}
		self.Spinners = {
			wing1 = CreateRotator(self, 'rwing', 'z', nil, 0, 0, 0),
			wing2 = CreateRotator(self, 'lwing', 'z', nil, 0, 0, 0),
		}
		for k, v in self.Sliders do
			self.Trash:Add(v)
		end
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
	end,


	OpenWings = function(self)
		--MOVE winga to x-axis <5.59> SPEED <5.00>;
		self.Spinners.wing1:SetGoal(90)
		self.Spinners.wing1:SetSpeed(50)

		--MOVE wing2 to x-axis <-5.65> SPEED <5.00>;
		self.Spinners.wing2:SetGoal(-90)
		self.Spinners.wing2:SetSpeed(50)
	end,

	CloseWings = function(self)

		--MOVE winga to x-axis <5.59> SPEED <5.00>;
		self.Spinners.wing1:SetGoal(0)
		self.Spinners.wing1:SetSpeed(50)

		--MOVE wing2 to x-axis <-5.65> SPEED <5.00>;
		self.Spinners.wing2:SetGoal(0)
		self.Spinners.wing2:SetSpeed(50)
	end,

	Weapons = {
		WEAPON = Class(TAweapon) {},
	},
}

TypeClass = ARMSEAP