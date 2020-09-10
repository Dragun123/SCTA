local oldARMMEX = ARMMEX
ARMMEX = Class(oldARMMEX) {
       OnStopBuild = function(self, unitBuilding)
            oldARMMEX.OnStopBuild(self, unitBuilding)
            if unitBuilding:GetFractionComplete() == 1 and unitBuilding:GetUnitId() == self:GetBlueprint().General.UpgradesTo then
                NotifyUpgrade(self, unitBuilding)
                self:Destroy()
            end
        end,
}

TypeClass = ARMMEX