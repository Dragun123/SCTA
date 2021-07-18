local WeaponFile = import('/lua/sim/DefaultWeapons.lua')
local TIFArtilleryWeapon = import('/lua/terranweapons.lua').TIFArtilleryWeapon
local DefaultWeapon = WeaponFile.DefaultProjectileWeapon
local KamikazeWeapon = WeaponFile.KamikazeWeapon
local BareBonesWeapon = WeaponFile.BareBonesWeapon
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')

TAweapon = Class(DefaultWeapon) {
    OnCreate = function(self)
        DefaultWeapon.OnCreate(self)
        self.TAArmy = self.unit:GetArmy()
    end,
    
        OnGotTargetCheck = function(self)
        if (self.unit:IsUnitState('Patrolling') or self.unit:IsUnitState('MakingAttackRun')) then
            --LOG('*AIBrain', self.unit:GetAIBrain().SCTAAI)
            return true
        else
            local canSee = true
            local target = self:GetCurrentTarget()
        if (target) then
            if (IsUnit(target)) then
                if target:GetBlip(self.TAArmy) ~= nil and target:GetBlip(self.TAArmy):IsSeenNow(self.TAArmy) then 
                canSee = target:GetBlip(self.TAArmy):IsSeenNow(self.TAArmy)
                else 
                canSee = false
                end
            end
            if (IsBlip(target)) then
                target = target:GetSource()
            end
        end

        local currentTarget = self.unit:GetTargetEntity()
        if (currentTarget and IsBlip(currentTarget)) then
            currentTarget = currentTarget:GetSource()
        end

        if (canSee == true or 
        currentTarget == target or
        (target and IsProp(target))) then
             return true
        else
            self:ResetTarget()
            return false
        end
    end
    end,

    IdleState = State(DefaultWeapon.IdleState) {
        OnGotTarget = function(self) 
            if (self.unit.SCTAAIBrain or
            TAutils.ArmyHasTargetingFacility(self.TAArmy) or 
            self:OnGotTargetCheck() == true) then
                DefaultWeapon.IdleState.OnGotTarget(self)
            end
        end,
    },

    WeaponUnpackingState = State(DefaultWeapon.WeaponUnpackingState) {
        Main = function(self)          
            ---LOG('Resulting Table'..repr(TAutils.targetingFacilityData))
            if (self.unit.SCTAAIBrain or
            TAutils.ArmyHasTargetingFacility(self.TAArmy) or 
            self:OnGotTargetCheck() == true) then
                if not self.unit.Dead and not IsDestroyed(self.unit) then
                    DefaultWeapon.WeaponUnpackingState.Main(self)
                end
            end
        end,

        OnGotTarget = function(self)
            if (self.unit.SCTAAIBrain or
            TAutils.ArmyHasTargetingFacility(self.TAArmy) or 
            self:OnGotTargetCheck() == true) then
                DefaultWeapon.WeaponUnpackingState.OnGotTarget(self)
            end
        end,
    },

    RackSalvoFireReadyState = State(DefaultWeapon.RackSalvoFireReadyState) {
        OnGotTarget = function(self)      
            if (self.unit.SCTAAIBrain or
            TAutils.ArmyHasTargetingFacility(self.TAArmy) or 
            self:OnGotTargetCheck() == true) then
                DefaultWeapon.RackSalvoFireReadyState.OnGotTarget(self)
            end
        end,

    },

    WeaponPackingState = State(DefaultWeapon.WeaponPackingState) {        
        OnGotTarget = function(self)
            if (self.unit:GetAIBrain().SCTAAI or
            TAutils.ArmyHasTargetingFacility(self.TAArmy) or 
            self:OnGotTargetCheck() == true) then
                if not self.unit.Dead and not IsDestroyed(self.unit) then
                DefaultWeapon.WeaponPackingState.OnGotTarget(self)
                end
            end
        end,
    },
}

TAHide = Class(TAweapon) {
    OnCreate = function(self)
        TAweapon.OnCreate(self)
        self.bp = self.unit:GetBlueprint()
        self.scale = 0.5
    end,

    PlayFxWeaponUnpackSequence = function(self)
        self.unit.Pack = 1
        self.unit:DisableUnitIntel('RadarStealth')
        TAweapon.PlayFxWeaponUnpackSequence(self)
        self.unit:SetCollisionShape( 'Box', self.bp.CollisionOffsetX or 0, self.bp.CollisionOffsetY + 0.5, self.bp.CollisionOffsetZ or 0, self.bp.SizeX * self.scale, self.bp.SizeY * self.scale, self.bp.SizeZ * self.scale)
    end,

    PlayFxWeaponPackSequence = function(self)
        self.unit:EnableUnitIntel('RadarStealth')
        TAweapon.PlayFxWeaponPackSequence(self)
        self.unit:SetCollisionShape( 'Box',  self.bp.CollisionOffsetX or 0, self.bp.CollisionOffsetY or 0, self.bp.CollisionOffsetZ or 0, self.bp.SizeX * self.scale, ((self.bp.SizeY/self.bp.SizeY) * self.scale), self.bp.SizeZ * self.scale)
    end,
}

TAPopLaser = Class(TAweapon) {

    PlayFxWeaponUnpackSequence = function(self)
        self.unit.Pack = 1
        TAweapon.PlayFxWeaponUnpackSequence(self)
    end,

    PlayFxWeaponPackSequence = function(self)
        self.unit.Pack = 0.5
        TAweapon.PlayFxWeaponPackSequence(self)
    end,
}

TARotatingWeapon = Class(TAweapon) {
    OnCreate = function(self)
        TAweapon.OnCreate(self)
        self.CurrentRound = 0
    end,

    PlayRackRecoil = function(self, rackList)  
    TAweapon.PlayRackRecoil(self, rackList) 
    self.CurrentRound = self.CurrentRound + 1
    --LOG('*RoundCount', self.CurrentRound)
    self.Rotator:SetSpeed(self.Speed)
    self.Goal = (self.CurrentRound + 1)
    self.Rotator:SetGoal(self.Goal * self.Rotation)
    if self.Rotator2 then
        self.Rotator2:SetSpeed(self.Speed)
        self.Goal2 = (self.CurrentRound + 1)
        self.Rotator2:SetGoal(self.Goal2 * self.Rotation)
    end
    if self.CurrentRound == self.MaxRound then
        self.CurrentRound = 0
    end 
end, 
}


TALightLaser = Class(TAweapon) {
    OnCreate = function(self)
        TAweapon.OnCreate(self)
        self.EconDrain = true
    end,

    OnWeaponFired = function(self)
        TAweapon.OnWeaponFired(self)
        self:ForkThread(self.StartEconomyDrain)
    end,

    StartEconomyDrain = function(self)
        if self.EconDrain then
        self.LLT = self:GetWeaponEnergyRequired()
        self.Eco = CreateEconomyEvent(self.unit, self.LLT, 0, 1)
        WaitTicks(1)
        RemoveEconomyEvent(self.unit, self.Eco)
        end
    end,

    RackSalvoFireReadyState = State(TAweapon.RackSalvoFireReadyState) {
    WeaponWantEnabled = true,
    WeaponAimWantEnabled = true,

    Main = function(self)
        self.unit:SetBusy(false)
        self.WeaponCanFire = true

        -- To prevent weapon getting stuck targeting something out of fire range but withing tracking radius
        WaitSeconds(2)
        -- Check if there is a better target nearby
        self:ResetTarget()
    end,

    },
}


TAKami = Class(KamikazeWeapon){
    FxDeath = {
        '/effects/emitters/napalm_fire_emit_2.bp',
    },


    OnFire = function(self)
        self.unit:SetDeathWeaponEnabled(false)
        for k, v in self.FxDeath do
            CreateEmitterAtBone(self.unit,-2,self.unit:GetArmy(),v):ScaleEmitter(0.5)
        end 
        self.unit.attacked = true
		KamikazeWeapon.OnFire(self)
    end,
}

TABomb = Class(BareBonesWeapon) {
    FxDeath = {
        '/effects/emitters/napalm_fire_emit_2.bp',
    },


    OnCreate = function(self)
        BareBonesWeapon.OnCreate(self)
        self:SetWeaponEnabled(false)   
    end,
    

    OnFire = function(self)
    end,
    
    Fire = function(self)
        for k, v in self.FxDeath do
            CreateEmitterAtBone(self.unit,-2, self.unit:GetArmy(), v):ScaleEmitter(1)
        end 
		local myBlueprint = self:GetBlueprint()
        DamageArea(self.unit, self.unit:GetPosition(), myBlueprint.DamageRadius, myBlueprint.Damage, myBlueprint.DamageType or 'Normal', myBlueprint.DamageFriendly or false)
    end,    

}

TAEndGameWeapon = Class(TIFArtilleryWeapon) {
    FxMuzzleFlashScale = 3,
    OnCreate = function(self)
        TIFArtilleryWeapon.OnCreate(self)
        self.CurrentRound = 0
        self.EconDrain = true
    end,

    OnWeaponFired = function(self)
        TIFArtilleryWeapon.OnWeaponFired(self)
        self:ForkThread(self.StartEconomyDrain)
    end,

    StartEconomyDrain = function(self)
        if self.EconDrain then
        self.Eco = CreateEconomyEvent(self.unit, 2000, 0, 1)
        WaitTicks(1)
        RemoveEconomyEvent(self.unit, self.Eco)
        end
    end,

    PlayRackRecoil = function(self, rackList)   
        TIFArtilleryWeapon.PlayRackRecoil(self, rackList)
        self.CurrentRound = self.CurrentRound + 1
    --LOG('*RoundCount', self.CurrentRound)
        self.Rotator:SetSpeed(self.Speed)
        self.Goal = (self.CurrentRound + 1)
        self.Rotator:SetGoal(self.Goal * self.Rotation)
    if self.CurrentRound == self.MaxRound then
        self.CurrentRound = 0
    end 
end, 

    RackSalvoFireReadyState = State(TIFArtilleryWeapon.RackSalvoFireReadyState) {
    WeaponWantEnabled = true,
    WeaponAimWantEnabled = true,

    Main = function(self)
        self.unit:SetBusy(false)
        self.WeaponCanFire = true

        -- To prevent weapon getting stuck targeting something out of fire range but withing tracking radius
        WaitSeconds(2)
        -- Check if there is a better target nearby
        self:ResetTarget()
    end,

    },
}

TADGun = Class(DefaultWeapon) {
    AutoMode = false,
    AutoThread = nil,
    EnergyRequired = nil,

    HasEnergy = function(self)
        return self.unit:GetAIBrain():GetEconomyStored('ENERGY') >= self.EnergyRequired
    end,

    -- Can we use the OC weapon?
    CanOvercharge = function(self)
        return not self.unit:IsOverchargePaused() and self:HasEnergy() and not
            self:UnitOccupied() 
    end,

    UnitOccupied = function(self)
        return self.unit:IsUnitState('Building') or
            self.unit:IsUnitState('Repairing') or
            self.unit:IsUnitState('Reclaiming')
    end,

    PauseOvercharge = function(self)
        if not self.unit:IsOverchargePaused() then
            self.unit:SetOverchargePaused(true)
            WaitSeconds(1 / self:GetBlueprint().RateOfFire)
            self.unit:SetOverchargePaused(false)
        end
        if self.AutoMode then
            self.AutoThread = self:ForkThread(self.AutoEnable)
        end
    end,

        AutoEnable = function(self)
            while not self:CanOvercharge() do
                WaitSeconds(1)
            end
            if self.AutoMode then
                self.unit:SetWeaponEnabledByLabel('AutoOverCharge', true)
            end
        end,
    
        
    SetAutoOvercharge = function(self, auto)
            self.AutoMode = auto
    
            if self.AutoMode then
                self.AutoThread = self:ForkThread(self.AutoEnable)
            else
                if self.AutoThread then
                    KillThread(self.AutoThread)
                    self.AutoThread = nil
                end
            end
        end,

        StartEconomyDrain = function(self) -- OverchargeWeapon drains energy on impact
        end,

        OnCreate = function(self)
            DefaultWeapon.OnCreate(self)
            self.EnergyRequired = self:GetBlueprint().EnergyRequired
            self.unit:SetWeaponEnabledByLabel('OverCharge', true)
            self.unit:SetWeaponEnabledByLabel('AutoOverCharge', false)
            self.unit:SetOverchargePaused(false)
        end,

        OnWeaponFired = function(self)
            DefaultWeapon.OnWeaponFired(self)
            self:ForkThread(self.PauseOvercharge)
        end,

        WaitDGUN = function(self)
            WaitSeconds(1 / self:GetBlueprint().RateOfFire)
        end,

        IdleState = State(DefaultWeapon.IdleState) {
            OnGotTarget = function(self)
                if self:CanOvercharge() then
                    DefaultWeapon.IdleState.OnGotTarget(self)
                else
                    self:ForkThread(function()
                        while not self:CanOvercharge() do
                            WaitSeconds(0.1)
                        end
                        DefaultWeapon.IdleState.OnGotTarget(self)
                    end)
                end
            end,
    
            OnFire = function(self)
                if self:CanOvercharge() then
                    ChangeState(self, DefaultWeapon.IdleState.RackSalvoFiringState(self))
                else
                    self:ForkThread(self.WaitDGUN)
                end
            end,
        },
    
        RackSalvoFireReadyState = State(DefaultWeapon.RackSalvoFireReadyState) {
            OnFire = function(self)
                if self:CanOvercharge() then
                    DefaultWeapon.RackSalvoFireReadyState.OnFire(self)
                else
                    self:ForkThread(self.WaitDGUN)
                end
            end,
        }    
}
