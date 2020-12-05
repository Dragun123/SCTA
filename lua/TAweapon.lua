local WeaponFile = import('/lua/sim/DefaultWeapons.lua')
local DefaultWeapon = WeaponFile.DefaultProjectileWeapon
local KamikazeWeapon = WeaponFile.KamikazeWeapon
local BareBonesWeapon = WeaponFile.BareBonesWeapon
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')

TAweapon = Class(DefaultWeapon) {
    FxRackChargeMuzzleFlash = {},
    FxRackChargeMuzzleFlashScale = 1,
    FxChargeMuzzleFlash = {},
    FxChargeMuzzleFlashScale = 1,
    FxMuzzleFlash = {
        '/effects/emitters/default_muzzle_flash_01_emit.bp',
        '/effects/emitters/default_muzzle_flash_02_emit.bp',
    },

    StartEconomyDrain = function(self)
        DefaultWeapon.StartEconomyDrain(self)
    end,

    OnGotTargetCheck = function(self)
        local army = self.unit:GetArmy()
        local canSee = true

        ###object currently targeting
        local target = self:GetCurrentTarget()
        if (target) then
            if (IsUnit(target)) then
                canSee = target:GetBlip(army):IsSeenNow(army)
            end
            if (IsBlip(target)) then
                target = target:GetSource()
            end
        end

        ###object (if any) currently ordered to target
        local currentTarget = self.unit:GetTargetEntity()
        if (currentTarget and IsBlip(currentTarget)) then
            currentTarget = currentTarget:GetSource()
        end

        if (canSee or TAutils.ArmyHasTargetingFacility(self.unit:GetArmy()) or currentTarget == target or (target and IsProp(target)) or EntityCategoryContains(categories.NOCUSTOMTARGET, self.unit)) then
             return true
        else
            self:ResetTarget()
            return nil
        end
    end,

    IdleState = State(DefaultWeapon.IdleState) {
        OnGotTarget = function(self)
            if (self:OnGotTargetCheck()) then
                DefaultWeapon.IdleState.OnGotTarget(self)
            end
        end,
    },

    WeaponUnpackingState = State(DefaultWeapon.WeaponUnpackingState) {
        Main = function(self)
            if (self:OnGotTargetCheck()) then
                DefaultWeapon.WeaponUnpackingState.Main(self)
            else
                ChangeState(self, self.WeaponPackingState)
            end
        end,

        OnGotTarget = function(self)
            if (self:OnGotTargetCheck()) then
                DefaultWeapon.WeaponUnpackingState.OnGotTarget(self)
            end
        end,
    },

    RackSalvoFireReadyState = State(DefaultWeapon.RackSalvoFireReadyState) {
        WeaponWantEnabled = true,
        WeaponAimWantEnabled = true,

        Main = function(self)
            local bp = self:GetBlueprint()
            if (bp.CountedProjectile and bp.WeaponUnpacks) then
                self.unit:SetBusy(true)
            else
                self.unit:SetBusy(false)
            end
            self.WeaponCanFire = true
            if bp.EnergyRequired and bp.EnergyRequired > 0 then
                self.WeaponCanFire = false
                local aiBrain = self.unit:GetAIBrain()
                while aiBrain:GetEconomyStored('ENERGY') < bp.EnergyRequired do
                        WaitSeconds(1)
                end
                aiBrain:TakeResource('Energy', bp.EnergyRequired)
                self.WeaponCanFire = true
            end
            if bp.CountedProjectile then
                ChangeState(self, self.RackSalvoFiringState)
            end

        end,

        OnGotTarget = function(self)
            if (self:OnGotTargetCheck()) then
                DefaultWeapon.RackSalvoFireReadyState.OnGotTarget(self)
            end
        end,

        OnFire = function(self)
            if self.WeaponCanFire then
                ChangeState(self, self.RackSalvoFiringState)
            end
        end,

        OnLostTarget = function(self)
            local bp = self:GetBlueprint()
            if bp.WeaponUnpacks then
                ChangeState(self, self.WeaponPackingState)
            end
        end,

    },

    WeaponPackingState = State(DefaultWeapon.WeaponPackingState) {
        OnGotTarget = function(self)
            if (self:OnGotTargetCheck()) then
                DefaultWeapon.WeaponPackingState.OnGotTarget(self)
            end
        end,
    },
}

TAHide = Class(TAweapon) {

    PlayFxWeaponUnpackSequence = function(self)
        self.unit.damageReduction = 1
        self.unit:DisableUnitIntel('RadarStealth')
        TAweapon.PlayFxWeaponUnpackSequence(self)
    end,

    PlayFxWeaponPackSequence = function(self)
        self.unit.damageReduction = 0.28
        self.unit:EnableUnitIntel('RadarStealth')
        TAweapon.PlayFxWeaponPackSequence(self)
    end,
}


TABuzz = Class(TAweapon) {
    OnCreate = function(self)
        TAweapon.OnCreate(self)
    end,
}

TAKami = Class(KamikazeWeapon){
    FxMuzzleFlash = {
        '/effects/emitters/default_muzzle_flash_01_emit.bp',
        '/effects/emitters/default_muzzle_flash_02_emit.bp',
    },

    OnFire = function(self)
		local army = self.unit:GetArmy()
		KamikazeWeapon.OnFire(self)
    end,
}

TABomb = Class(BareBonesWeapon) {
    FxMuzzleFlash = {
        '/effects/emitters/default_muzzle_flash_01_emit.bp',
        '/effects/emitters/default_muzzle_flash_02_emit.bp',
    },

    OnCreate = function(self)
        BareBonesWeapon.OnCreate(self)
        self:SetWeaponEnabled(false)   
    end,
    

    OnFire = function(self)
    end,
    
    Fire = function(self)
		local army = self.unit:GetArmy()
		local myBlueprint = self:GetBlueprint()
        DamageArea(self.unit, self.unit:GetPosition(), myBlueprint.DamageRadius, myBlueprint.Damage, myBlueprint.DamageType or 'Normal', myBlueprint.DamageFriendly or false)
    end,    

}


TACommanderDeathWeapon = Class(BareBonesWeapon) {
    OnCreate = function(self)
        BareBonesWeapon.OnCreate(self)
    end,
}

TADGun = Class(TAweapon) {
    EnergyRequired = nil,

    HasEnergy = function(self)
        return self.unit:GetAIBrain():GetEconomyStored('ENERGY') >= self.EnergyRequired
    end,

    -- Can we use the OC weapon?
    CanOvercharge = function(self)
        return not self.unit:IsOverchargePaused() and self:HasEnergy() and not
            self:UnitOccupied() 
    end,

    StartEconomyDrain = function(self) -- OverchargeWeapon drains energy on impact
    end,

    OnWeaponFired = function(self)
        ---TAweapon.OnWeaponFired(self)
        self.unit:SetWeaponEnabledByLabel('DGun', true)
        self:ForkThread(self.PauseOvercharge)
    end,

        OnLostTarget = function(self)
        self.unit:SetWeaponEnabledByLabel('DGun', true)
        TAweapon.OnLostTarget(self)
    end,
        
        PauseOvercharge = function(self)
            if not self.unit:IsOverchargePaused() then
                self.unit:SetOverchargePaused(true)
                WaitSeconds(1/self:GetBlueprint().RateOfFire)
                self.unit:SetOverchargePaused(false)
            end
        end,

        OnCreate = function(self)
            TAweapon.OnCreate(self)
            self.EnergyRequired = self:GetBlueprint().EnergyRequired
            self.unit:SetWeaponEnabledByLabel('DGun', true)
            self.unit:SetOverchargePaused(false)
        end,
}
