#CORE Titan - Torpedo Bomber
#CORSEAP
#
#Script created by Raevn

local TASeaair = import('/mods/SCTA-master/lua/TAair.lua').TASeaair
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon

CORSEAP = Class(TASeaair) {

	OnCreate = function(self)
		TASeaair.OnCreate(self)
		self.Sliders = {
			chassis = CreateSlider(self, 0),
			wing1 = CreateSlider(self, 'wing1L'),
			wing2 = CreateSlider(self, 'wing2L'),
			wing3 = CreateSlider(self, 'wing1R'),
			wing4 = CreateSlider(self, 'wing2R'),
		}
		for k, v in self.Sliders do
			self.Trash:Add(v)
		end
	end,

	OpenWings = function(self)
		--MOVE wing1 to x-axis <5.59> SPEED <5.00>;
		self.Sliders.wing1:SetGoal(-5.59,0,0)
		self.Sliders.wing1:SetSpeed(5)

		--MOVE wing2 to x-axis <-5.65> SPEED <5.00>;
		self.Sliders.wing2:SetGoal(-5.65,0,0)
		self.Sliders.wing2:SetSpeed(5)

		--MOVE wing1 to x-axis <5.59> SPEED <5.00>;
		self.Sliders.wing3:SetGoal(5.59,0,0)
		self.Sliders.wing3:SetSpeed(5)
		
		--MOVE wing2 to x-axis <-5.65> SPEED <5.00>;
		self.Sliders.wing4:SetGoal(5.65,0,0)
		self.Sliders.wing4:SetSpeed(5)
	end,

	CloseWings = function(self)
		--MOVE wing1 to x-axis <0> SPEED <5.00>;
		self.Sliders.wing1:SetGoal(0,0,0)
		self.Sliders.wing1:SetSpeed(5)

		--MOVE wing2 to x-axis <0> SPEED <5.00>;
		self.Sliders.wing2:SetGoal(0,0,0)
		self.Sliders.wing2:SetSpeed(5)

		--MOVE wing1 to x-axis <5.59> SPEED <5.00>;
		self.Sliders.wing3:SetGoal(0,0,0)
		self.Sliders.wing3:SetSpeed(5)
				
		--MOVE wing2 to x-axis <-5.65> SPEED <5.00>;
		self.Sliders.wing4:SetGoal(0,0,0)
		self.Sliders.wing4:SetSpeed(5)
	end,

	Weapons = {
		CORAIR_TORPEDO = Class(TAweapon) {},
		ARMVTOL_MISSILE = Class(TAweapon) {},
	},
}

TypeClass = CORSEAP