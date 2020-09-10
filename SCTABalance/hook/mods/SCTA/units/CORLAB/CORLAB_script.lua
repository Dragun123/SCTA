local oldCORLAB = CORLAB
CORLAB = Class(oldCORLAB) {
       OnStopBuild = function(self, unitBuilding)
            oldCORLAB.OnStopBuild(self, unitBuilding)
            if unitBuilding:GetFractionComplete() == 1 and unitBuilding:GetUnitId() == self:GetBlueprint().General.UpgradesTo then
                NotifyUpgrade(self, unitBuilding)
                self:Destroy()
            end
        end,
}

TypeClass = CORLAB