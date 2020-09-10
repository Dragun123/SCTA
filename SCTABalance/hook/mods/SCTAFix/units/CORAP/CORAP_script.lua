local oldCORAP = CORAP
CORAP = Class(oldCORAP) {
       OnStopBuild = function(self, unitBuilding)
            oldCORAP.OnStopBuild(self, unitBuilding)
            if unitBuilding:GetFractionComplete() == 1 and unitBuilding:GetUnitId() == self:GetBlueprint().General.UpgradesTo then
                NotifyUpgrade(self, unitBuilding)
                self:Destroy()
            end
        end,
}

TypeClass = CORAP