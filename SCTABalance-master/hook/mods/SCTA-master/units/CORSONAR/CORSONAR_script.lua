local oldCORSONAR = CORSONAR

CORSONAR = Class(oldCORSONAR) {
	OnStopBuild = function(self, unitBeingBuilt)
		 oldCORSONAR.OnStopBuild(self, unitBeingBuilt)
		 if unitBeingBuilt:GetFractionComplete() == 1 and unitBeingBuilt:GetUnitId() == self:GetBlueprint().General.UpgradesTo then
			 NotifyUpgrade(self, unitBeingBuilt)
			 self:Destroy()
		 end
	 end,
}

TypeClass = CORSONAR