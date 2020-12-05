local oldCORCS = CORCS
CORCS = Class(oldCORCS) {
    OnCreate = function(self)
        oldCORCS.OnCreate(self)
        self:AddBuildRestriction( categories.CORE)
    end,
}

TypeClass = CORCS