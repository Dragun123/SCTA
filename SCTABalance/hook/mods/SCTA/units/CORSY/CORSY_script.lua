local oldCORSY = CORSY
CORSY = Class(oldCORSY) {
       OnStopBuild = function(self, unitBuilding)
            oldCORSY.OnStopBuild(self, unitBuilding)
            if unitBuilding:GetFractionComplete() == 1 and unitBuilding:GetUnitId() == self:GetBlueprint().General.UpgradesTo then
                NotifyUpgrade(self, unitBuilding)
                self:Destroy()
            end
        end,
}

TypeClass = CORSY