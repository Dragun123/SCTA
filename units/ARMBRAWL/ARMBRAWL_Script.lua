#ARM Brawler - Gunship
#ARMBRAWL
#
#Script created by Raevn

local TAair = import('/mods/SCTA-master/lua/TAair.lua').TAair
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon

ARMBRAWL = Class(TAair) {

	OnCreate = function(self)
		TAair.OnCreate(self)
		self.Sliders = {
			wing1 = CreateSlider(self, 'wing1'),
			wing2 = CreateSlider(self, 'wing2'),
			weapon1 = CreateSlider(self, 'weapon1'),
			weapon2 = CreateSlider(self, 'weapon2'),
		}
		self.Spinners = {
			tail1 = CreateRotator(self, 'tail1', 'z', nil, 0, 0, 0),
			tail2 = CreateRotator(self, 'tail2', 'z', nil, 0, 0, 0),
		}
		for k, v in self.Sliders do
			self.Trash:Add(v)
		end
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
	end,

	OpenWings = function(self)
		--MOVE wing1 to x-axis <2.89> SPEED <2.00>;
		self.Sliders.wing1:SetGoal(-2.9,0,0)
		self.Sliders.wing1:SetSpeed(2)

		--MOVE wing2 to x-axis <-2.90> SPEED <2.00>;
		self.Sliders.wing2:SetGoal(2.9,0,0)
		self.Sliders.wing2:SetSpeed(2)

		--TURN tail1 to z-axis <55.94> SPEED <56.07>;
		self.Spinners.tail1:SetGoal(-60)
		self.Spinners.tail1:SetSpeed(60)

		--TURN tail2 to z-axis <-65.67> SPEED <65.81>;
		self.Spinners.tail2:SetGoal(60)
		self.Spinners.tail2:SetSpeed(60)

		--SLEEP <998>;

		--MOVE weapon1 to x-axis <-2.84> SPEED <2.00>;
		self.Sliders.weapon1:SetGoal(2.9,0,0)
		self.Sliders.weapon1:SetSpeed(2)

		--MOVE weapon2 to x-axis <2.95> SPEED <2.00>;
		self.Sliders.weapon2:SetGoal(-2.9,0,0)
		self.Sliders.weapon2:SetSpeed(2)
	end,

	CloseWings = function(self)

		--MOVE weapon1 to x-axis <0> SPEED <2.00>;
		self.Sliders.weapon1:SetGoal(0,0,0)
		self.Sliders.weapon1:SetSpeed(2)

		--MOVE weapon2 to x-axis <0> SPEED <2.00>;
		self.Sliders.weapon2:SetGoal(0,0,0)
		self.Sliders.weapon2:SetSpeed(2)

		--SLEEP <998>;

		--MOVE wing1 to x-axis <0> SPEED <2.00>;
		self.Sliders.wing1:SetGoal(0,0,0)
		self.Sliders.wing1:SetSpeed(2)

		--MOVE wing2 to x-axis <0> SPEED <2.00>;
		self.Sliders.wing2:SetGoal(0,0,0)
		self.Sliders.wing2:SetSpeed(2)

		--TURN tail1 to z-axis <0> SPEED <55.53>;
		self.Spinners.tail1:SetGoal(0)
		self.Spinners.tail1:SetSpeed(60)

		--TURN tail2 to z-axis <0> SPEED <65.17>;
		self.Spinners.tail2:SetGoal(0)
		self.Spinners.tail2:SetSpeed(60)
	end,

	Weapons = {
		VTOL_EMG = Class(TAweapon) {},
		
	},
}

TypeClass = ARMBRAWL