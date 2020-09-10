local oldCORSONAR = CORSONAR
local TAutils = import('/mods/SCTA/lua/TAutils.lua')

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
}

TypeClass = CORSONAR