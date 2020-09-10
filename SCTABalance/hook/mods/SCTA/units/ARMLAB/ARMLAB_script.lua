local oldARMLAB = ARMLAB
ARMLAB = Class(oldARMLAB) {
       OnStopBuild = function(self, unitBuilding)
            oldARMLAB.OnStopBuild(self, unitBuilding)
            if unitBuilding:GetFractionComplete() == 1 and unitBuilding:GetUnitId() == self:GetBlueprint().General.UpgradesTo then
                NotifyUpgrade(self, unitBuilding)
                self:Destroy()
            end
        end,
}

TypeClass = ARMLAB