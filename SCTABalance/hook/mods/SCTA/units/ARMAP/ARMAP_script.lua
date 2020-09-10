local oldARMAP = ARMAP
ARMAP = Class(oldARMAP) {
       OnStopBuild = function(self, unitBuilding)
            oldARMAP.OnStopBuild(self, unitBuilding)
            if unitBuilding:GetFractionComplete() == 1 and unitBuilding:GetUnitId() == self:GetBlueprint().General.UpgradesTo then
                NotifyUpgrade(self, unitBuilding)
                self:Destroy()
            end
        end,
}

TypeClass = ARMAP