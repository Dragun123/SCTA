local Prop = import('/lua/sim/Prop.lua').Prop

local TAutils = import('/mods/SCTAFix/lua/TAutils.lua')

TAWreckage = Class(Prop) {
	smokeEmitter = nil,
	wreckageDead = false,
	myShield = nil,
	OriginalUnit = nil,

	OnCreate = function(self)
        Prop.OnCreate(self)
        self.IsWreckage = true
        self.OrientationCache = self:GetOrientation()
    end,

    OnDamage = function(self, instigator, amount, vector, damageType)
        if not self.CanTakeDamage then return end
        self:DoTakeDamage(instigator, amount, vector, damageType)
    end,

    DoTakeDamage = function(self, instigator, amount, vector, damageType)
		local maxHealth = self:GetMaxHealth()
		local preHealth = self:GetHealth()
		self:AdjustHealth(instigator, -amount)
		local health = self:GetHealth()
		if health <= 0 and self.wreckageDead == false then
			self.wreckageDead = true
			TAutils.QueueDelayedWreckage(self, amount / maxHealth, self:GetBlueprint(), 1, self:GetPosition(), self:GetOrientation(), self:GetMaxHealth())
            if not self:GetBlueprint().Wreckage then
			end
			self:Destroy()			
		else
            self:UpdateReclaimLeft()
        end
    end,

    OnCollisionCheck = function(self, other)
        if IsUnit(other) then
            return false
        else
            return true
        end
    end,

    --- Create and return an identical wreckage prop. Useful for replacing this one when something
    -- (a stupid engine bug) deleted it when we don't want it to.
    -- This function has the handle the case when *this* unit has already been destroyed. Notably,
    -- this means we have to calculate the health from the reclaim values, instead of going the
    -- other way.
    Clone = function(self)
        local clone = CreateWreckage(__blueprints[self.AssociatedBP], self.CachePosition, self.OrientationCache, self.MaxMassReclaim, self.MaxEnergyReclaim, self.TimeReclaim)

        -- Figure out the health this wreck had before it was deleted. We can't use any native
        -- functions like GetHealth(), so we use the latest known value

        clone:SetHealth(nil, clone:GetMaxHealth() * (self.ReclaimLeft or 1))
        clone:UpdateReclaimLeft()

        return clone
    end,

    Rebuild = function(self, units)
        local rebuilders = {}
        local assisters = {}
        local bpid = self.AssociatedBP

        for _, u in units do
            if u:CanBuild(bpid) then
                table.insert(rebuilders, u)
            else
                table.insert(assisters, u)
            end
        end

        if not rebuilders[1] then return end
        local pos = self:GetPosition()
        for _, u in rebuilders do
            IssueBuildMobile({u}, pos, bpid, {})
        end
        if assisters[1] then
            IssueGuard(assisters, pos)
        end
    end,
}
