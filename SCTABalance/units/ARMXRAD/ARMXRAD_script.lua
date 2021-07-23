local TATarg = import('/mods/SCTA-master/lua/TAStructure.lua').TATarg

ARMXRAD = Class(TATarg) {
	OnCreate = function(self)
		TATarg.OnCreate(self)
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

	OnStopBeingBuilt = function(self,builder,layer)
		TATarg.OnStopBeingBuilt(self,builder,layer)
		ForkThread(self.StartSpin, self)
		self:PlayUnitSound('Activate')
	end,

	OnScriptBitSet = function(self, bit)
		if bit == 3 then
			self:PlayUnitSound('Deactivate')
			self.StopSpin(self)
		end
		TATarg.OnScriptBitSet(self, bit)
	end,


	OnScriptBitClear = function(self, bit)
		if bit == 3 then
			self:PlayUnitSound('Activate')
			ForkThread(self.StartSpin, self)
		end
		TATarg.OnScriptBitClear(self, bit)
	end,

	StartSpin = function(self)
			--SPIN turret around y-axis  SPEED <20.00>;
			self.Sliders.post:SetGoal(0,0,0)
			self.Sliders.post:SetSpeed(16)

			--WAIT-FOR-MOVE post along y-axis;
			WaitFor(self.Sliders.post)

			--SPIN arm1 around x-axis  SPEED <100.02>;
			self.Spinners.arm1:SetSpeed(45)
			self.Spinners.arm1:ClearGoal()

			--SPIN arm2 around x-axis  SPEED <-100.02>;
			self.Spinners.arm2:SetSpeed(45)
			self.Spinners.arm2:ClearGoal()
	end,

	StopSpin = function(self)
			--SPIN turret around y-axis  SPEED <0.00>;
			self.Spinners.arm1:SetGoal(0)

			--TURN dish2 to z-axis <0> SPEED <178.70>;
			self.Spinners.arm2:SetGoal(0)

			--MOVE post to y-axis <0> SPEED <19.00>;
			self.Sliders.post:SetGoal(0,-9,0)
			self.Sliders.post:SetSpeed(19)
	end,
}

TypeClass = ARMXRAD

	