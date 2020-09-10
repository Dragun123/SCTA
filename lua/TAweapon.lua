local WeaponFile = import('/lua/sim/DefaultWeapons.lua')
local DefaultWeapon = WeaponFile.DefaultProjectileWeapon
local BareBonesWeapon = WeaponFile.BareBonesWeapon
local TAutils = import('/mods/SCTA/lua/TAutils.lua')


TAweapon = Class(DefaultWeapon) {

    FxRackChargeMuzzleFlash = {},
    FxRackChargeMuzzleFlashScale = 1,
    FxChargeMuzzleFlash = {},
    FxChargeMuzzleFlashScale = 1,
    FxMuzzleFlash = {
        '/effects/emitters/default_muzzle_flash_01_emit.bp',
        '/effects/emitters/default_muzzle_flash_02_emit.bp',
    },

    OnCreate = function(self)
        DefaultWeapon.OnCreate(self)

        local bp = self:GetBlueprint()
        local rof = self:GetWeaponRoF()
        self.WeaponCanFire = true
        if bp.RackRecoilDistance ~= 0 then
            self.RecoilManipulators = {}
        end

        -- Make certain the weapon has essential aspects defined
        if not bp.RackBones then
           local strg = '*ERROR: No RackBones table specified, aborting weapon setup.  Weapon: ' .. bp.DisplayName .. ' on Unit: ' .. self.unit.UnitId
           error(strg, 2)
           return
        end
        if not bp.MuzzleSalvoSize then
           local strg = '*ERROR: No MuzzleSalvoSize specified, aborting weapon setup.  Weapon: ' .. bp.DisplayName .. ' on Unit: ' .. self.unit.UnitId
           error(strg, 2)
           return
        end
        if not bp.MuzzleSalvoDelay then
           local strg = '*ERROR: No MuzzleSalvoDelay specified, aborting weapon setup.  Weapon: ' .. bp.DisplayName .. ' on Unit: ' .. self.unit.UnitId
           error(strg, 2)
           return
        end

        self.CurrentRackSalvoNumber = 1

        -- Calculate recoil speed so that it finishes returning just as the next shot is ready
        if bp.RackRecoilDistance ~= 0 then
            local dist = bp.RackRecoilDistance
            if bp.RackBones[1].TelescopeRecoilDistance then
                local tpDist = bp.RackBones[1].TelescopeRecoilDistance
                if math.abs(tpDist) > math.abs(dist) then
                    dist = tpDist
                end
            end
            self.RackRecoilReturnSpeed = bp.RackRecoilReturnSpeed or math.abs(dist / ((1 / rof) - (bp.MuzzleChargeDelay or 0))) * 1.25
        end

        -- Ensure firing cycle is compatible internally
        self.NumMuzzles = 0
        for rk, rv in bp.RackBones do
            self.NumMuzzles = self.NumMuzzles + table.getn(rv.MuzzleBones or 0)
        end
        self.NumMuzzles = self.NumMuzzles / table.getn(bp.RackBones)
        local totalMuzzleFiringTime = (self.NumMuzzles - 1) * bp.MuzzleSalvoDelay
        if totalMuzzleFiringTime > (1 / rof) then
            local strg = '*ERROR: The total time to fire muzzles is longer than the RateOfFire allows, aborting weapon setup.  Weapon: ' .. bp.DisplayName .. ' on Unit: ' .. self.unit.UnitId
            error(strg, 2)
            return false
        end
        if bp.RackRecoilDistance ~= 0 and bp.MuzzleSalvoDelay ~= 0 then
            local strg = '*ERROR: You can not have a RackRecoilDistance with a MuzzleSalvoDelay not equal to 0, aborting weapon setup.  Weapon: ' .. bp.DisplayName .. ' on Unit: ' .. self.unit.UnitId
            error(strg, 2)
            return false
        end

        if bp.EnergyChargeForFirstShot == false then
            self.FirstShot = true
        end

        -- Set the firing cycle progress bar to full if required
        if bp.RenderFireClock then
            self.unit:SetWorkProgress(1)
        end

        ChangeState(self, self.IdleState)
    end,

    -- This function creates the projectile, and happens when the unit is trying to fire
    -- Called from inside RackSalvoFiringState
    CreateProjectileAtMuzzle = function(self, muzzle)
        local proj = self:CreateProjectileForWeapon(muzzle)
        if not proj or proj:BeenDestroyed() then
            return proj
        end

        local bp = self:GetBlueprint()
        if bp.DetonatesAtTargetHeight == true then
            local pos = self:GetCurrentTargetPos()
            if pos then
                local theight = GetSurfaceHeight(pos[1], pos[3])
                local hght = pos[2] - theight
                proj:ChangeDetonateAboveHeight(hght)
            end
        end
        if bp.Flare then
            proj:AddFlare(bp.Flare)
        end
        if self.unit:GetCurrentLayer() == 'Water' and bp.Audio.FireUnderWater then
            self:PlaySound(bp.Audio.FireUnderWater)
        elseif bp.Audio.Fire then
            self:PlaySound(bp.Audio.Fire)
        end

        self:CheckBallisticAcceleration(proj)  -- Check weapon blueprint for trajectory fix request

        return proj
    end,

    -- Used mainly for Bomb drop physics calculations
    CheckBallisticAcceleration = function(self, proj)
        local bp = self:GetBlueprint()
        if bp.FixBombTrajectory then
            local acc = CalculateBallisticAcceleration(self, proj)
            proj:SetBallisticAcceleration(-acc) -- Change projectile trajectory so it hits the target
        end
    end,

    -- Triggers when the weapon is moved horizontally, usually by owner's motion
    OnMotionHorzEventChange = function(self, new, old)
        DefaultWeapon.OnMotionHorzEventChange(self, new, old)

        -- Handle weapons which must pack before moving
        local bp = self:GetBlueprint()
        if bp.WeaponUnpackLocksMotion == true and old == 'Stopped' then
            self:PackAndMove()
        end

        -- Handle motion-triggered FiringRandomness changes
        if old == 'Stopped' then
            if bp.FiringRandomnessWhileMoving then
                self:SetFiringRandomness(bp.FiringRandomnessWhileMoving)
            end
        elseif new == 'Stopped' and bp.FiringRandomnessWhileMoving then
            self:SetFiringRandomness(bp.FiringRandomness)
        end
    end,

    -- Called on horizontal motion event
    PackAndMove = function(self)
        ChangeState(self, self.WeaponPackingState)
    end,

    -- Create an economy event for those weapons which require Energy to fire
    StartEconomyDrain = function(self)
        if self.FirstShot then return end
        if self.unit:GetFractionComplete() ~= 1 then return end

        local bp = self:GetBlueprint()
        if not self.EconDrain and bp.EnergyRequired and bp.EnergyDrainPerSecond then
            local nrgReq = self:GetWeaponEnergyRequired()
            local nrgDrain = self:GetWeaponEnergyDrain()
            if nrgReq > 0 and nrgDrain > 0 then
                local time = nrgReq / nrgDrain
                if time < 0.1 then
                    time = 0.1
                end
                self.EconDrain = CreateEconomyEvent(self.unit, nrgReq, 0, time)
                self.FirstShot = true
                self.unit:ForkThread(function()
                    WaitFor(self.EconDrain)
                    RemoveEconomyEvent(self.unit, self.EconDrain)
                    self.EconDrain = nil
                end)
            end
        end
    end,

    -- Determine how much Energy is required to fire
    GetWeaponEnergyRequired = function(self)
        local bp = self:GetBlueprint()
        local weapNRG = (bp.EnergyRequired or 0) * (self.AdjEnergyMod or 1)
        if weapNRG < 0 then
            weapNRG = 0
        end
        return weapNRG
    end,

    -- Determine how much Energy should be drained per second
    GetWeaponEnergyDrain = function(self)
        local bp = self:GetBlueprint()
        local weapNRG = (bp.EnergyDrainPerSecond or 0) * (self.AdjEnergyMod or 1)
        return weapNRG
    end,

    GetWeaponRoF = function(self)
        local bp = self:GetBlueprint()

        return bp.RateOfFire / (self.AdjRoFMod or 1)
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

        if (canSee == true or TAutils.ArmyHasTargetingFacility(self.unit:GetArmy()) == true or currentTarget == target or (target and IsProp(target)) or EntityCategoryContains(categories.NOCUSTOMTARGET, self.unit)) then
             return true
        else
            self:ResetTarget()
            return false
        end
    end,
    
    IdleState = State(DefaultWeapon.IdleState) {
        OnGotTarget = function(self)
            if (self:OnGotTargetCheck() == true) then
                DefaultWeapon.IdleState.OnGotTarget(self)
            end
        end,
    },

    WeaponUnpackingState = State(DefaultWeapon.WeaponUnpackingState) {
        Main = function(self)
            if (self:OnGotTargetCheck() == true) then
                DefaultWeapon.WeaponUnpackingState.Main(self)
            else
                ChangeState(self, self.WeaponPackingState)
            end
        end,

        OnGotTarget = function(self)
            if (self:OnGotTargetCheck() == true) then
                DefaultWeapon.WeaponUnpackingState.OnGotTarget(self)
            end
        end,
    },

    RackSalvoFireReadyState = State(DefaultWeapon.RackSalvoFireReadyState) {
        WeaponWantEnabled = true,
        WeaponAimWantEnabled = true,

        Main = function(self)
            local bp = self:GetBlueprint()
            if (bp.CountedProjectile == true and bp.WeaponUnpacks == true) then
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
            if bp.CountedProjectile == true then
                ChangeState(self, self.RackSalvoFiringState)
            end

        end,

        OnGotTarget = function(self)
            if (self:OnGotTargetCheck() == true) then
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
            if bp.WeaponUnpacks == true then
                ChangeState(self, self.WeaponPackingState)
            end
        end,

    },

    WeaponPackingState = State(DefaultWeapon.WeaponPackingState) {
        OnGotTarget = function(self)
            if (self:OnGotTargetCheck() == true) then
                DefaultWeapon.WeaponPackingState.OnGotTarget(self)
            end
        end,
    },

    GetDamageTable = function(self)
        local weaponBlueprint = self:GetBlueprint()
        local damageTable = {}
        damageTable.EdgeEffectiveness = weaponBlueprint.EdgeEffectiveness
        damageTable.DamageRadius = weaponBlueprint.DamageRadius or 0
        damageTable.DamageAmount = weaponBlueprint.Damage + (self.DamageMod or 0)
        damageTable.DamageType = weaponBlueprint.DamageType
        damageTable.DamageFriendly = weaponBlueprint.DamageFriendly
        if damageTable.DamageFriendly == nil then
            damageTable.DamageFriendly = true
        end
        damageTable.CollideFriendly = weaponBlueprint.CollideFriendly or false
        damageTable.DoTTime = weaponBlueprint.DoTTime
        damageTable.DoTPulses = weaponBlueprint.DoTPulses
        damageTable.MetaImpactAmount = weaponBlueprint.MetaImpactAmount
        damageTable.MetaImpactRadius = weaponBlueprint.MetaImpactRadius
        #Add buff
        damageTable.Buffs = {}
        if weaponBlueprint.Buffs != nil then
            for k, v in weaponBlueprint.Buffs do
                damageTable.Buffs[k] = {}
                damageTable.Buffs[k] = v
            end   
        end     
        #remove disabled buff
        if (self.Disabledbf != nil) and (damageTable.Buffs != nil) then
            for k, v in damageTable.Buffs do
                for j, w in self.Disabledbf do
                    if v.BuffType == w then
                        #Removing buff
                        table.remove( damageTable.Buffs, k )
                    end
                end
            end  
        end  
        
        return damageTable
    end,
}

TACommanderDeathWeapon = Class(BareBonesWeapon) {
    OnCreate = function(self)
        BareBonesWeapon.OnCreate(self)

        local myBlueprint = self:GetBlueprint()
        self.Data = {
            NukeOuterRingDamage = myBlueprint.NukeOuterRingDamage or 10,
            NukeOuterRingRadius = myBlueprint.NukeOuterRingRadius or 40,
            NukeOuterRingTicks = myBlueprint.NukeOuterRingTicks or 20,
            NukeOuterRingTotalTime = myBlueprint.NukeOuterRingTotalTime or 10,

            NukeInnerRingDamage = myBlueprint.NukeInnerRingDamage or 1000,
            NukeInnerRingRadius = myBlueprint.NukeInnerRingRadius or 30,
            NukeInnerRingTicks = myBlueprint.NukeInnerRingTicks or 24,
            NukeInnerRingTotalTime = myBlueprint.NukeInnerRingTotalTime or 24,
        }
    end,


    OnFire = function(self)
    end,

    Fire = function(self)
        local myBlueprint = self:GetBlueprint()
        local myProjectile = self.unit:CreateProjectile( myBlueprint.ProjectileId, 0, 0, 0, nil, nil, nil):SetCollision(false)
        myProjectile:PassDamageData(self:GetDamageTable())
        if self.Data then
            myProjectile:PassData(self.Data)
        end
    end,
}

TACommanderSuicideWeapon = Class(BareBonesWeapon) {
    OnCreate = function(self)
        BareBonesWeapon.OnCreate(self)

        local myBlueprint = self:GetBlueprint()
        self.Data = {
            NukeOuterRingDamage = myBlueprint.NukeOuterRingDamage or 10,
            NukeOuterRingRadius = myBlueprint.NukeOuterRingRadius or 40,
            NukeOuterRingTicks = myBlueprint.NukeOuterRingTicks or 20,
            NukeOuterRingTotalTime = myBlueprint.NukeOuterRingTotalTime or 10,

            NukeInnerRingDamage = myBlueprint.NukeInnerRingDamage or 500,
            NukeInnerRingRadius = myBlueprint.NukeInnerRingRadius or 30,
            NukeInnerRingTicks = myBlueprint.NukeInnerRingTicks or 24,
            NukeInnerRingTotalTime = myBlueprint.NukeInnerRingTotalTime or 24,
        }
    end,


    OnFire = function(self)
    end,

    Fire = function(self)
        local myBlueprint = self:GetBlueprint()
        local myProjectile = self.unit:CreateProjectile( myBlueprint.ProjectileId, 0, 0, 0, nil, nil, nil):SetCollision(false)
        myProjectile:PassDamageData(self:GetDamageTable())
        if self.Data then
            myProjectile:PassData(self.Data)
        end
    end,
}