#CORE Advanced Radar Tower - Long Range Radar Tower
#CORARAD
#
#Script created by Raevn

local TACloser = import('/mods/SCTA-master/lua/TAStructure.lua').TACloser

CORARAD = Class(TACloser) {
	OnCreate = function(self)
		TACloser.OnCreate(self)
		self.Spinners = {
			dish = CreateRotator(self, 'dish', 'x', nil, 0, 0, 0),
			turret = CreateRotator(self, 'turret', 'y', nil, 0, 0, 0),
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
	end,


	OpeningState = State {
		Main = function(self)
			self:EnableIntel('Radar')
			--SPIN turret around y-axis  SPEED <20.00>;
			self.Spinners.turret:ClearGoal()
			self.Spinners.turret:SetSpeed(20)

			--SPIN dish around x-axis  SPEED <-200.04>;
			self.Spinners.dish:ClearGoal()
			self.Spinners.dish:SetSpeed(-200)
			TACloser.OpeningState.Main(self)
		end,
	},


	ClosingState = State {
		Main = function(self)
			self:DisableIntel('Radar')

			--SPIN turret around y-axis  SPEED <0.00>;
			self.Spinners.turret:ClearGoal()
			self.Spinners.turret:SetSpeed(0)

			--SPIN dish around x-axis  SPEED <0.0>;
			self.Spinners.dish:ClearGoal()
			self.Spinners.dish:SetSpeed(0)

			TACloser.ClosingState.Main(self)
		end,

	},
}

TypeClass = CORARAD