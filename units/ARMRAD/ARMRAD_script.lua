#ARM Radar Tower - Radar Tower
#ARMRAD
#
#Script created by Raevn

local TAunit = import('/mods/SCTA-master/lua/TAunit.lua').TAunit

ARMRAD = Class(TAunit) {
	OnCreate = function(self)
		TAunit.OnCreate(self)
		self.Spinners = {
			ear1 = CreateRotator(self, 'dish1', 'x', nil, 0, 0, 0),
			ear2 = CreateRotator(self, 'dish2', 'x', nil, 0, 0, 0),
			dish = CreateRotator(self, 'radar', 'y', nil, 0, 0, 0),
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
		self.intelIsActive = true
	end,

	OnStopBeingBuilt = function(self,builder,layer)
		TAunit.OnStopBeingBuilt(self,builder,layer)
		self.intelIsActive = true
		self.StartSpin(self)
		self:PlayUnitSound('Activate')
	end,

	OnScriptBitSet = function(self, bit)
		if bit == 3 then
			self:PlayUnitSound('Deactivate')
			self.StopSpin(self)
		end
		TAunit.OnScriptBitSet(self, bit)
	end,


	OnScriptBitClear = function(self, bit)
		if bit == 3 then
			self:PlayUnitSound('Activate')
			self.StartSpin(self)
		end
		TAunit.OnScriptBitClear(self, bit)
	end,

	StartSpin = function(self)
		--SPIN dish around y-axis SPEED <60>
		self.Spinners.dish:SetSpeed(60)

		--SPIN ear1 around y-axis SPEED <120>
		self.Spinners.ear1:SetSpeed(120)

		--SPIN ear2 around y-axis SPEED <-120>
		self.Spinners.ear2:SetSpeed(-120)

		self:SetMaintenanceConsumptionActive()
	end,

	StopSpin = function(self)
		--SPIN dish around y-axis SPEED <0>
		self.Spinners.dish:SetSpeed(0)

		--SPIN ear1 around y-axis SPEED <0>
		self.Spinners.ear1:SetSpeed(0)

		--SPIN ear2 around y-axis SPEED <0>
		self.Spinners.ear2:SetSpeed(0)

		self:SetMaintenanceConsumptionInactive()
	end,
}

TypeClass = ARMRAD