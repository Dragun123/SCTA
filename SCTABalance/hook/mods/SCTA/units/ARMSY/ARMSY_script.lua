local oldARMSY = ARMSY
ARMSY = Class(oldARMSY) {
       OnStopBuild = function(self, unitBuilding)
            oldARMSY.OnStopBuild(self, unitBuilding)
            if unitBuilding:GetFractionComplete() == 1 and unitBuilding:GetUnitId() == self:GetBlueprint().General.UpgradesTo then
                NotifyUpgrade(self, unitBuilding)
                self:Destroy()
            end
        end,
}

TypeClass = ARMSY