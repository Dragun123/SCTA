local TAutils = import('/mods/SCTA/lua/TAutils.lua')
local oldCORARAD = CORARAD

CORARAD = Class(oldCORARAD) {
	OnStopBuild = function(self, unitBuilding)
		 oldCORARAD.OnStopBuild(self, unitBuilding)
		 if unitBuilding:GetFractionComplete() == 1 and unitBuilding:GetUnitId() == self:GetBlueprint().General.UpgradesTo then
			 NotifyUpgrade(self, unitBuilding)
			 self:Destroy()
		 end
	 end,

	 OnFailedToBuild = function(self)
        oldCORARAD.OnFailedToBuild(self)
		self:SetMaintenanceConsumptionActive()
		self:PlayUnitSound('Activate')
		ChangeState(self, self.OpeningState)
	end,
		
	OnStopBeingBuilt = function(self,builder,layer)
		oldCORARAD.OnStopBeingBuilt(self,builder,layer)
		self:PlayUnitSound('Activate')
		TAutils.registerTargetingFacility(self:GetArmy())
	end,

	OnScriptBitSet = function(self, bit)
		if bit == 3 then
			self:PlayUnitSound('Deactivate')
			TAutils.unregisterTargetingFacility(self:GetArmy())
		end
		oldCORARAD.OnScriptBitSet(self, bit)
	end,
}

TypeClass = CORARAD