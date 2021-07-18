#ARM Advanced Radar Tower - Long Range Radar Tower
#ARMARAD
#
#Script created by Raevn

local TACloser = import('/mods/SCTA-master/lua/TAStructure.lua').TACloser

ARMARAD = Class(TACloser) {
	OnCreate = function(self)
		TACloser.OnCreate(self)
		self.Spinners = {
			arm1 = CreateRotator(self, 'dish1', 'x', nil, 0, 0, 0),
			arm2 = CreateRotator(self, 'dish2', 'x', nil, 0, 0, 0),
		}
		self.Sliders = {
			post = CreateSlider(self, 'radar'),
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
		for k, v in self.Sliders do
			self.Trash:Add(v)
		end
	end,
	
	OpeningState = State {
		Main = function(self)
			self:EnableIntel('Radar')
			self.Sliders.post:SetGoal(0,0,0)
			self.Sliders.post:SetSpeed(16)

			--SPIN arm1 around x-axis  SPEED <100.02>;
			self.Spinners.arm1:SetSpeed(45)
			self.Spinners.arm1:ClearGoal()

			--SPIN arm2 around x-axis  SPEED <-100.02>;
			self.Spinners.arm2:SetSpeed(45)
			self.Spinners.arm2:ClearGoal()
			TACloser.OpeningState.Main(self)
		end,
	},


	ClosingState = State {
		Main = function(self)
			self:DisableIntel('Radar')
			self.Spinners.arm1:SetGoal(0)
			self.Spinners.arm2:SetGoal(0)

			--MOVE post to y-axis <0> SPEED <19.00>;
			self.Sliders.post:SetGoal(0,-9,0)
			self.Sliders.post:SetSpeed(19)
			TACloser.ClosingState.Main(self)
		end,

	},
}

TypeClass = ARMARAD