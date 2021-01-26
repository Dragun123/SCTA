local WeaponFile = import('/lua/sim/DefaultWeapons.lua')
local DefaultWeapon = WeaponFile.DefaultProjectileWeapon
local KamikazeWeapon = WeaponFile.KamikazeWeapon
local BareBonesWeapon = WeaponFile.BareBonesWeapon
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')
local EffectTemplate = import('/lua/EffectTemplates.lua')

TAweapon = Class(DefaultWeapon) {
    StartEconomyDrain = function(self)
        DefaultWeapon.StartEconomyDrain(self)
    end,
}

TAHide = Class(TAweapon) {

    PlayFxWeaponUnpackSequence = function(self)
        self.unit.Pack = 1
        self.unit:DisableUnitIntel('RadarStealth')
        TAweapon.PlayFxWeaponUnpackSequence(self)
    end,

    PlayFxWeaponPackSequence = function(self)
        self.unit.Pack = 0.28
        self.unit:EnableUnitIntel('RadarStealth')
        TAweapon.PlayFxWeaponPackSequence(self)
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
    
    UnitOccupied = function(self)
        return self.unit:IsUnitState('Building') or
            self.unit:IsUnitState('Repairing') or
            self.unit:IsUnitState('Reclaiming')
    end,

    StartEconomyDrain = function(self) -- OverchargeWeapon drains energy on impact
    end,

    OnWeaponFired = function(self)
        self:ForkThread(self.PauseOvercharge)
    end,

    OnLostTarget = function(self)
        self.unit:SetWeaponEnabledByLabel('DGun', true)
        if self.AutoMode then
            self.AutoThread = self:ForkThread(self.AutoEnable)
        end
        TAweapon.OnLostTarget(self)
    end,


    PauseOvercharge = function(self)
        if not self.unit:IsOverchargePaused() then
            self.unit:SetOverchargePaused(true)
            WaitSeconds(1 / self:GetBlueprint().RateOfFire)
            self.unit:SetOverchargePaused(false)
        end
        self.unit:SetWeaponEnabledByLabel('DGun', true)
        if self.AutoMode then
            self.AutoThread = self:ForkThread(self.AutoEnable)
        end
    end,

        OnCreate = function(self)
            TAweapon.OnCreate(self)
            self.EnergyRequired = self:GetBlueprint().EnergyRequired
            self.unit:SetWeaponEnabledByLabel('DGun', true)
            self.unit:SetWeaponEnabledByLabel('AutoDGun', false)
            self.unit:SetOverchargePaused(false)
        end,

        AutoEnable = function(self)
            while not self:CanOvercharge() do
                WaitSeconds(3)
            end
            if self.AutoMode then
                self.unit:SetWeaponEnabledByLabel('DGun', false)
                self.unit:SetWeaponEnabledByLabel('AutoDGun', true)
            end
        end,
    
        SetAutoOvercharge = function(self, auto)
            self.AutoMode = auto
    
            if self.AutoMode then
                self.AutoThread = self:ForkThread(self.AutoEnable)
            else
                if self.AutoThread then
                    KillThread(self.AutoThread)
                    self.unit:SetWeaponEnabledByLabel('AutoDGun', false)
                    self.unit:SetWeaponEnabledByLabel('DGun', true)
                    self.AutoThread = nil
                end
            end
        end,
    
}
