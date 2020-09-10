local oldARMRAD = ARMRAD
ARMRAD = Class(oldARMRAD) {
	OnStopBuild = function(self, unitBuilding)
		 oldARMRAD.OnStopBuild(self, unitBuilding)
		 if unitBuilding:GetFractionComplete() == 1 and unitBuilding:GetUnitId() == self:GetBlueprint().General.UpgradesTo then
			 NotifyUpgrade(self, unitBuilding)
			 self:Destroy()
		 end
	 end,
}

TypeClass = ARMRAD