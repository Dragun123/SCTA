

local TAunit = import('/mods/SCTA-master/lua/TAunit.lua').TAunit

CORMMKR = Class(TAunit) {
	closeDueToDamage = nil,
	productionIsActive = true,

	OnCreate = function(self)
		TAunit.OnCreate(self)
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
		TAunit.OnStopBeingBuilt(self,builder,layer)
		ChangeState(self, self.OpeningState)
	end,

	OpeningState = State {
		Main = function(self)
			self:PlayUnitSound('Activate')
			


			--SLEEP <772>;
			WaitSeconds(0.75)

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

			--SLEEP <774>;
			WaitSeconds(0.75)
			--SLEEP <775>;
			WaitSeconds(0.75)

			self:SetProductionActive(true)
			self:SetMaintenanceConsumptionActive()

			ChangeState(self, self.IdleOpenState)
		end,
	},


	ClosingState = State {
		Main = function(self)
			self:SetProductionActive(false)
			self:PlayUnitSound('Activate')
			self:SetMaintenanceConsumptionInactive()

			--TURN lid1 to x-axis <0> SPEED <51.35>;
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
			--SLEEP <688>;
			WaitSeconds(0.7)

			ChangeState(self, self.IdleClosedState)
			
		end,

	},

	IdleClosedState = State {
		Main = function(self)
			if self.closeDueToDamage then 
				while self.DamageSeconds > 0 do
					WaitSeconds(1)
					self.DamageSeconds = self.DamageSeconds - 1
				end
				self.closeDueToDamage = nil
				if self.productionIsActive then 
					ChangeState(self, self.OpeningState)
				end
			end
		end,

	},

	IdleOpenState = State {
		Main = function(self)
		end,

		OnDamage = function(self, instigator, amount, vector, damageType)
			TAunit.OnDamage(self, instigator, amount, vector, damageType)
			self.DamageSeconds = 8
			self.closeDueToDamage = true
			ChangeState(self, self.ClosingState)
		end,

	},
		
	OnProductionUnpaused = function(self)
		TAunit.OnProductionUnpaused(self)
		self.productionIsActive = true
		ChangeState(self, self.OpeningState)
	end,

	OnProductionPaused = function(self)
		TAunit.OnProductionPaused(self)
		self.productionIsActive = nil
		ChangeState(self, self.ClosingState)
	end,



	OnDamage = function(self, instigator, amount, vector, damageType)
		TAunit.OnDamage(self, instigator, amount, vector, damageType) 
		self.DamageSeconds = 8
	end,
}

TypeClass = CORMMKR