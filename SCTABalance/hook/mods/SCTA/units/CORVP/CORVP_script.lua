local oldCORVP = CORVP

CORVP = Class(oldCORVP) {
       OnStopBuild = function(self, unitBuilding)
            oldCORVP.OnStopBuild(self, unitBuilding)
            if unitBuilding:GetFractionComplete() == 1 and unitBuilding:GetUnitId() == self:GetBlueprint().General.UpgradesTo then
                NotifyUpgrade(self, unitBuilding)
                self:Destroy()
            end
        end,
}

TypeClass = CORVP