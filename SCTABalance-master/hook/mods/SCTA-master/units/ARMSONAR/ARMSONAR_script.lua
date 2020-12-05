local oldARMSONAR = ARMSONAR

ARMSONAR = Class(oldARMSONAR) {
	OnStopBuild = function(self, unitBeingBuilt)
		 oldARMSONAR.OnStopBuild(self, unitBeingBuilt)
		 if unitBeingBuilt:GetFractionComplete() == 1 and unitBeingBuilt:GetUnitId() == self:GetBlueprint().General.UpgradesTo then
			 NotifyUpgrade(self, unitBeingBuilt)
			 self:Destroy()
		 end
	 end,
}

TypeClass = ARMSONAR