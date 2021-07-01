
local SCTAProp = Prop
Prop = Class(SCTAProp) {

    GetReclaimCosts = function(self, reclaimer)
        local time = self.TimeReclaim * (math.max(self.MaxMassReclaim, self.MaxEnergyReclaim) / reclaimer:GetBuildRate())
        time = math.max(time / 10, 0.0001)
        if self.NecroingInProgress then
           --LOG('self.NecroingInProgress = true, returning nil eco')
           return time, 1, 1
        end
        --LOG('self.NecroingInProgress = false, returning full eco')
        return time, self.MaxEnergyReclaim, self.MaxMassReclaim
    end,

}
