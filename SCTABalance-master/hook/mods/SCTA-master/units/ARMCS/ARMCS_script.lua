local oldARMCS = ARMCS
ARMCS = Class(oldARMCS) {
    OnCreate = function(self)
        oldARMCS.OnCreate(self)
        self:AddBuildRestriction( categories.ARM)
    end,
}

TypeClass = ARMCS