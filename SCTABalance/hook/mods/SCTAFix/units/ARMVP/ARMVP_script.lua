local oldARMVP = ARMVP
ARMVP = Class(oldARMVP) {
       OnStopBuild = function(self, unitBuilding)
            oldARMVP.OnStopBuild(self, unitBuilding)
            if unitBuilding:GetFractionComplete() == 1 and unitBuilding:GetUnitId() == self:GetBlueprint().General.UpgradesTo then
                NotifyUpgrade(self, unitBuilding)
                self:Destroy()
            end
        end,
}

TypeClass = ARMVP