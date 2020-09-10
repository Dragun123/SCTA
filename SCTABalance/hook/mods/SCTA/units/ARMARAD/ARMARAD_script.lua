local TAutils = import('/mods/SCTA/lua/TAutils.lua')
local oldARMARAD = ARMARAD

ARMARAD = Class(oldARMARAD) {
	OnStopBuild = function(self, unitBuilding)
		 oldARMARAD.OnStopBuild(self, unitBuilding)
		 if unitBuilding:GetFractionComplete() == 1 and unitBuilding:GetUnitId() == self:GetBlueprint().General.UpgradesTo then
			 NotifyUpgrade(self, unitBuilding)
			 self:Destroy()
		 end
	 end,

	 OnFailedToBuild = function(self)
        oldARMARAD.OnFailedToBuild(self)
		self:SetMaintenanceConsumptionActive()
		self:PlayUnitSound('Activate')
		ChangeState(self, self.OpeningState)
	end,
	
	OnStopBeingBuilt = function(self,builder,layer)
		oldARMARAD.OnStopBeingBuilt(self,builder,layer)
		self:PlayUnitSound('Activate')
		TAutils.registerTargetingFacility(self:GetArmy())
	end,

	OnScriptBitSet = function(self, bit)
		if bit == 3 then
			self:PlayUnitSound('Deactivate')
    		ForkThread(self.Close, self)
			TAutils.unregisterTargetingFacility(self:GetArmy())
		end
		oldARMARAD.OnScriptBitSet(self, bit)
	end,
}

TypeClass = ARMARAD