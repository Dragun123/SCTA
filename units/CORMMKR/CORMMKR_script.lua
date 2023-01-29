local TACloser = import('/mods/SCTA-master/lua/TAStructure.lua').TACloser

CORMMKR = Class(TACloser) {
	OnCreate = function(self)
		TACloser.OnCreate(self)
		self.Spinners = {
			lid1 = CreateRotator(self, 'flap1', 'x', nil, 0, 0, 0),
			lid2 = CreateRotator(self, 'flap2', 'z', nil, 0, 0, 0),
			lid3 = CreateRotator(self, 'flap3', 'z', nil, 0, 0, 0),
			lid4 = CreateRotator(self, 'flap4', 'x', nil, 0, 0, 0),	
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
	end,

	OnStopBeingBuilt = function(self,builder,layer)
        TACloser.OnStopBeingBuilt(self,builder,layer)
        -- for auto fabricator behavior
        self.Brain:AddEnabledEnergyExcessUnit(self)
    end,

    -- for auto fabricator behavior
    OnExcessEnergy = function(self)
        self:OnProductionUnpaused()
    end,

    -- for auto fabricator behavior
    OnNoExcessEnergy = function(self)
        self:OnProductionPaused()
    end,


	OpeningState = State {
		Main = function(self)
			self:SetProductionActive(true)
			--[[if not self.TAAnimating then
				self.TAAnimating = true]]
			--TURN lid1 to x-axis <35.26> SPEED <45.57>;
			self.Spinners.lid1:SetGoal(30.40)
			self.Spinners.lid1:SetSpeed(45.57)

			--TURN lid4 to x-axis <-30.40> SPEED <39.29>;
			self.Spinners.lid4:SetGoal(-30.40)
			self.Spinners.lid4:SetSpeed(45.57)

			--TURN lid2 to x-axis <60.80> SPEED <39.29>;
			self.Spinners.lid2:SetGoal(-30.40)
			self.Spinners.lid2:SetSpeed(39.29)

			--TURN lid3 to x-axis <-74.18> SPEED <61.29>;
			self.Spinners.lid3:SetGoal(30.40)
			self.Spinners.lid3:SetSpeed(39.29)
			--end
			TACloser.OpeningState.Main(self)
		end,
	},


	ClosingState = State {
		Main = function(self)
			self:SetProductionActive(false)
			--[[if not self.TAAnimating then
				self.TAAnimating = true]]
			self.Spinners.lid1:SetGoal(0)
			self.Spinners.lid1:SetSpeed(51.35)

			--TURN lid4 to x-axis <0> SPEED <44.26>;
			self.Spinners.lid4:SetGoal(0)
			self.Spinners.lid4:SetSpeed(51.35)

			--TURN lid2 to x-axis <30.40> SPEED <44.26>;
			self.Spinners.lid2:SetGoal(0.0)
			self.Spinners.lid2:SetSpeed(69.05)

			--TURN lid3 to x-axis <-26.75> SPEED <69.05>;
			self.Spinners.lid3:SetGoal(0)
			self.Spinners.lid3:SetSpeed(69.05)
			--end
			TACloser.ClosingState.Main(self)	
		end,

	},
}

TypeClass = CORMMKR