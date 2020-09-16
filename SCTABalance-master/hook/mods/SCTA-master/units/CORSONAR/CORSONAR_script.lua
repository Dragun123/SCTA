local oldCORSONAR = CORSONAR
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')

CORSONAR = Class(oldCORSONAR) {
	OnStopBuild = function(self, unitBuilding)
		 oldCORSONAR.OnStopBuild(self, unitBuilding)
		 if unitBuilding:GetFractionComplete() == 1 and unitBuilding:GetUnitId() == self:GetBlueprint().General.UpgradesTo then
			 NotifyUpgrade(self, unitBuilding)
			 self:Destroy()
		 end
	 end,

	 OnStopBeingBuilt = function(self,builder,layer)
		oldCORSONAR.OnStopBeingBuilt(self,builder,layer)
		self:PlayUnitSound('Activate')
		TAutils.registerTargetingFacility(self:GetArmy())
	end,

	OnScriptBitSet = function(self, bit)
		if bit == 3 then
			self:PlayUnitSound('Deactivate')
			TAutils.unregisterTargetingFacility(self:GetArmy())
		end
		oldCORSONAR.OnScriptBitSet(self, bit)
	end,

	OnScriptBitClear = function(self, bit)
		if bit == 3 then
			self:PlayUnitSound('Activate')
			TAutils.registerTargetingFacility(self:GetArmy())
		end
		oldCORSONAR.OnScriptBitClear(self, bit)
	end,
}

TypeClass = CORSONAR