local oldCORRAD = CORRAD
CORRAD = Class(oldCORRAD) {
	OnStopBuild = function(self, unitBuilding)
		 oldCORRAD.OnStopBuild(self, unitBuilding)
		 if unitBuilding:GetFractionComplete() == 1 and unitBuilding:GetUnitId() == self:GetBlueprint().General.UpgradesTo then
			 NotifyUpgrade(self, unitBuilding)
			 self:Destroy()
		 end
	 end,
}

TypeClass = CORRAD