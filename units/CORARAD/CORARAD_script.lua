#CORE Advanced Radar Tower - Long Range Radar Tower
#CORARAD
#
#Script created by Raevn

local TATarg = import('/mods/SCTA-master/lua/TAStructure.lua').TATarg

CORARAD = Class(TATarg) {
	OnCreate = function(self)
		TATarg.OnCreate(self)
		self.Spinners = {
			dish = CreateRotator(self, 'dish', 'x', nil, 0, 0, 0),
			turret = CreateRotator(self, 'turret', 'y', nil, 0, 0, 0),
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
	end,

	OnStopBeingBuilt = function(self,builder,layer)
		TATarg.OnStopBeingBuilt(self,builder,layer)
		self.StartSpin(self)
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
			self.StartSpin(self)
		end
		TATarg.OnScriptBitClear(self, bit)
	end,

	StartSpin = function(self)
			--SPIN turret around y-axis  SPEED <20.00>;
			self.Spinners.turret:ClearGoal()
			self.Spinners.turret:SetSpeed(20)

			--SPIN dish around x-axis  SPEED <-200.04>;
			self.Spinners.dish:ClearGoal()
			self.Spinners.dish:SetSpeed(-200)
	end,

	StopSpin = function(self)
			--SPIN turret around y-axis  SPEED <0.00>;
			self.Spinners.turret:ClearGoal()
			self.Spinners.turret:SetSpeed(0)

			--SPIN dish around x-axis  SPEED <0.0>;
			self.Spinners.dish:ClearGoal()
			self.Spinners.dish:SetSpeed(0)
	end,
}

TypeClass = CORARAD