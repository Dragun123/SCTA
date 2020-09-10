#Nuclear Missile Rocket
#CRBLMSSL
#
#Script created by Raevn

local TANuclearProjectile = import('/mods/SCTA/lua/TAProjectiles.lua').TANuclearProjectile

CRBLMSSL = Class(TANuclearProjectile) {

	OnCreate = function(self)
		TANuclearProjectile.OnCreate(self)
        self:SetCollisionShape('Sphere', 0, 0, 0, 2)
		self:ForkThread( self.MovementThread )
	end,

	MovementThread = function(self)
        local launcher = self:GetLauncher()
		self.Nuke = true
        self:TrackTarget(false)
        WaitSeconds(2.5) -- Height
        self:SetCollision(true)
        WaitSeconds(2.5)
        self:TrackTarget(true) -- Turn ~90 degrees towards target
        self:SetDestroyOnWater(true)
        self:SetTurnRate(45)
        WaitSeconds(2) -- Now set turn rate to zero so nuke flies straight
        self:SetTurnRate(0)
        self:SetAcceleration(0.001)
        self.WaitTime = 0.5
        while not self:BeenDestroyed() do
            self:SetTurnRateByDist()
            WaitSeconds(self.WaitTime)
        end
    end,

    SetTurnRateByDist = function(self)
        local dist = self:GetDistanceToTarget()
        -- Get the nuke as close to 90 deg as possible
        if dist > 150 then
            -- Freeze the turn rate as to prevent steep angles at long distance targets
            self:SetTurnRate(0)
        elseif dist > 75 and dist <= 150 then
            -- Increase check intervals
            self.WaitTime = 0.3
        elseif dist > 32 and dist <= 75 then
            -- Further increase check intervals
            self.WaitTime = 0.1
        elseif dist < 32 then
            -- Turn the missile down
            self:SetTurnRate(50)
        end
    end,

    GetDistanceToTarget = function(self)
        local tpos = self:GetCurrentTargetPosition()
        local mpos = self:GetPosition()
        local dist = VDist2(mpos[1], mpos[3], tpos[1], tpos[3])
        return dist
    end,

    OnImpact = function(self, TargetType, TargetEntity)
        if not TargetEntity or not EntityCategoryContains(categories.PROJECTILE, TargetEntity) then
            local myBlueprint = self:GetBlueprint()
			nukeProjectile = self:CreateProjectile('/effects/Entities/UEFNukeEffectController01/UEFNukeEffectController01_proj.bp', 0, 0, 0, nil, nil, nil):SetCollision(false)
            nukeProjectile:PassDamageData(self.DamageData)
            nukeProjectile:PassData(self.Data)
        end
        TANuclearProjectile.OnImpact(self, TargetType, TargetEntity)
    end,

}

TypeClass = CRBLMSSL