local TAunit = import('/mods/SCTA-master/lua/TAunit.lua').TAunit

CORASON = Class(TAunit) {
	damageReduction = 1,

	OnDamage = function(self, instigator, amount, vector, damageType)
		#Apply Damage Reduction
		TAunit.OnDamage(self, instigator, self.damageReduction * amount, vector, damageType) 
	end,

	OnCreate = function(self)
		TAunit.OnCreate(self)
		self.Spinners = {
		
			dish = CreateRotator(self, 'dish', 'y', nil, 0, 0, 0),
			
		}
		
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
		
	end,

	OnIntelDisabled = function(self)

		--STOP-SPIN dish around y-axis;
		self.Spinners.dish:SetSpeed(0)

		self:SetMaintenanceConsumptionInactive()
		
		TAunit.OnIntelDisabled(self)
		self:PlayUnitSound('Deactivate')
		self.damageReduction = 0.46
	end,

	OnIntelEnabled = function(self)
		

		--SPIN dish around y-axis  SPEED <60.01>;
		self.Spinners.dish:SetSpeed(60)

		self:SetMaintenanceConsumptionActive()
		
		TAunit.OnIntelEnabled(self)
		self:PlayUnitSound('Activate')
		self.damageReduction = 1
	end,

	OnKilled = function(self, instigator, type, overkillRatio)
		TAunit.OnKilled(self, instigator, type, overkillRatio)
		
	end,
}

TypeClass = CORASON
