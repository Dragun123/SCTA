local oldCORMEX = CORMEX
CORMEX = Class(oldCORMEX) {
       OnStopBuild = function(self, unitBuilding)
            oldCORMEX.OnStopBuild(self, unitBuilding)
            if unitBuilding:GetFractionComplete() == 1 and unitBuilding:GetUnitId() == self:GetBlueprint().General.UpgradesTo then
                NotifyUpgrade(self, unitBuilding)
                self:Destroy()
            end
        end,
}

TypeClass = CORMEX