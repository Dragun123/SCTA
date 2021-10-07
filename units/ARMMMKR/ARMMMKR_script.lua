#ARM Moho Metal Maker - Converts Energy into Metal
#ARMMMKR
#
#Script created by Raevn

local TACloser = import('/mods/SCTA-master/lua/TAStructure.lua').TACloser

ARMMMKR = Class(TACloser) {
	OnCreate = function(self)
		TACloser.OnCreate(self)
		self.Spinners = {
			lid1 = CreateRotator(self, 'lid1', 'x', nil, 0, 0, 0),
			lid2 = CreateRotator(self, 'lid2', 'x', nil, 0, 0, 0),
			lid3 = CreateRotator(self, 'lid3', 'x', nil, 0, 0, 0),
			lid4 = CreateRotator(self, 'lid4', 'x', nil, 0, 0, 0),	
			core = CreateRotator(self, 'Core', 'y', nil, 0, 0, 0),	
			coreS = CreateSlider(self, 'Core'),	
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
	end,

	OpeningState = State {
		Main = function(self)
			self:SetProductionActive(true)

			--TURN mmakercore to y-axis <-30.40> SPEED <39.39>;
			self.Spinners.core:SetGoal(-30.40)
			self.Spinners.core:SetSpeed(39.39)

			--TURN lid1 to x-axis <35.26> SPEED <45.57>;
			self.Spinners.lid1:SetGoal(30.40)
			self.Spinners.lid1:SetSpeed(45.57)

			--TURN lid4 to x-axis <-30.40> SPEED <39.29>;
			self.Spinners.lid4:SetGoal(-30.40)
			self.Spinners.lid4:SetSpeed(45.57)

			--TURN lid2 to x-axis <60.80> SPEED <39.29>;
			self.Spinners.lid2:SetGoal(60.80)
			self.Spinners.lid2:SetSpeed(39.29)

			--TURN lid3 to x-axis <-74.18> SPEED <61.29>;
			self.Spinners.lid3:SetGoal(-60.80)
			self.Spinners.lid3:SetSpeed(39.29)

			--TURN mmakercore to y-axis <-60.80> SPEED <39.29>;
			self.Spinners.core:SetGoal(-60.80)
			self.Spinners.core:SetSpeed(39.39)

			self.Spinners.coreS:SetGoal(0,15,0)
			self.Spinners.coreS:SetSpeed(15)

			--TURN mmakercore to y-axis <-90.00> SPEED <37.67>;
			self.Spinners.core:SetGoal(-90.00)
			self.Spinners.core:SetSpeed(37.67)

			TACloser.OpeningState.Main(self)
		end,
	},


	ClosingState = State {
		Main = function(self)
			self:SetProductionActive(false)

			--TURN mmakercore to y-axis <-60.80> SPEED <42.74>;
			self.Spinners.core:SetGoal(-60.80)
			self.Spinners.core:SetSpeed(42.74)

			--MOVE mmakercore to y-axis <0> SPEED <7.00>;
			self.Spinners.coreS:SetGoal(0,0,0)
			self.Spinners.coreS:SetSpeed(15)

			--TURN lid1 to x-axis <0> SPEED <51.35>;
			self.Spinners.lid1:SetGoal(0)
			self.Spinners.lid1:SetSpeed(51.35)

			--TURN lid4 to x-axis <0> SPEED <44.26>;
			self.Spinners.lid4:SetGoal(0)
			self.Spinners.lid4:SetSpeed(51.35)


			--TURN mmakercore to y-axis <-30.40> SPEED <44.26>;
			self.Spinners.core:SetGoal(-30.40)
			self.Spinners.core:SetSpeed(44.26)

			--TURN lid2 to x-axis <0.60> SPEED <43.57>;
			self.Spinners.lid2:SetGoal(0)
			self.Spinners.lid2:SetSpeed(43.57)

			--TURN lid3 to x-axis <0.60> SPEED <40.01>;
			self.Spinners.lid3:SetGoal(0)
			self.Spinners.lid3:SetSpeed(43.57)

			--TURN mmakercore to y-axis <0> SPEED <44.46>;
			self.Spinners.core:SetGoal(0)
			self.Spinners.core:SetSpeed(30)
			TACloser.ClosingState.Main(self)
			
		end,

	},
}

TypeClass = ARMMMKR