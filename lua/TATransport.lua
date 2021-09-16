#Generic TA Air unit
local AirTransport = import('/lua/defaultunits.lua').AirTransport
local FireSelfdestructWeapons = import('/lua/selfdestruct.lua').FireSelfdestructWeapons


TATransport = Class(AirTransport)
{
	OnCreate = function(self)
        AirTransport.OnCreate(self)
        self.FxMovement = TrashBag()
	end,
	
	OnStopBeingBuilt = function(self,builder,layer)
		AirTransport.OnStopBeingBuilt(self,builder,layer)
		self.KillingInProgress = nil
	end,

    OnKilled = function(self, instigator, type, overkillRatio)
        local layer = self:GetCurrentLayer()
        self.Dead = true


        local bp = self:GetBlueprint()
        self:PlayUnitSound('Killed')
        -- apply death animation on half built units (do not apply for ML and meg
        self:DoUnitCallbacks('OnKilled')
        ArmyBrains[self:GetArmy()].LastUnitKilledBy = (instigator or self):GetArmy()

        if self.DeathWeaponEnabled ~= false then
            self:DoDeathWeapon()
        end

        -- Notify instigator of kill and spread veterancy
        -- We prevent any vet spreading if the instigator isn't part of the vet system (EG - Self destruct)
        -- This is so that you can bring a damaged Experimental back to base, kill, and rebuild, without granting
        -- instant vet to the enemy army, as well as other obscure reasons
        if self.totalDamageTaken > 0 and not self.veterancyDispersed then
            self:VeterancyDispersal(not instigator or not IsUnit(instigator))
        end

        self:DisableUnitIntel('Killed')
        self:ForkThread(self.DeathThread, overkillRatio , instigator)

        ArmyBrains[self.Army]:AddUnitStat(self.UnitId, "lost", 1)   
    end,

    Kill = function(self)
        if self.Dead or self.KillingInProgress then
            return
        end
        self.KillingInProgress = true
        --LOG('AirTransport.Kill ' .. self:GetBlueprint().General.UnitName)

        -- allow cargo to fire self destruct weapons (SelfDestructed flag is set in selfdestruct.lua)
        if self.SelfDestructed then
            --LOG('  yes self destruct:' .. self:GetBlueprint().General.UnitName)
            local cargo = self:GetCargo()
            --pcall(function() cargo = self:GetCargo() end)
            for _,unit in cargo or { } do
                --LOG('  firing cargo self-d weapons:' .. unit:GetBlueprint().General.UnitName)
                FireSelfdestructWeapons(unit)
            end
        end

        AirTransport.Kill(self)

    end,

    StartMoveFxTA = function(self)
        if not self.MoveFx then
            self.MoveFx = self:ForkThread(self.TAMoveFxThread)
        end
    end,

    TAMoveFxThread = function(self)
        while self:IsUnitState('Moving') and not self.Dead do
			local bp = self:GetBlueprint()
			for k, v in bp.Display.MovementEffects.TAMovement.Bones do
				self.TAMove = CreateAttachedEmitter(self, v, self:GetArmy(), bp.Display.MovementEffects.TAMovement.Emitter ):ScaleEmitter(bp.Display.MovementEffects.TAMovement.Scale)
			---LOG('TAIEXIST', self.Trash)
                --self.Trash:Add(CreateAttachedEmitter(self,'Back_Wake',self:GetArmy(),'/mods/CTO/effects/emitters/AU_MOVEMENTS/WATER/AU_MOVEMENTS_WATER_drops_emit.bp'):OffsetEmitter(0.0, -0.75, 0.0):ScaleEmitter(0.2))
			coroutine.yield(11)
            self.TAMove:Destroy()
			end
        end
    end,

    MoveFxStopTA = function(self)
        if self.TAMoveFxThread then
            KillThread(self.MoveFx)
            self.MoveFx = nil
        end
    end,

}

TATransportSea = Class(TATransport) {
    OnMotionHorzEventChange = function(self, new, old )
		TATransport.OnMotionHorzEventChange(self, new, old)
        if ( new == 'Cruise' and old == 'Stopped') then
            self:ForkThread(self.StartMoveFxTA)
         end
        if ( new == 'Stopped' ) or ( new == 'Stopped' and old == 'Stopping' ) then
            self:ForkThread(self.MoveFxStopTA)
        end
	end,
}


TATransportAir = Class(TATransport) {
    OnCreate = function(self)
        TATransport.OnCreate(self)
        HasFuel = true
	end,
    
    OnStopBeingBuilt = function(self,builder,layer)
		TATransport.OnStopBeingBuilt(self,builder,layer)
		self:OpenWings(self)
		self:PlayUnitSound('TakeOff')
	end,

    OnMotionVertEventChange = function(self, new, old)
        TATransport.OnMotionVertEventChange(self, new, old)
        self.CreateMovementEffects(self)
        if (new == 'Down' or new == 'Bottom') then
			self:CloseWings()
			self:PlayUnitSound('Landing')
            self:ForkThread(self.MoveFxStopTA)
			local vis = self:GetBlueprint().Intel.VisionRadius / 2
            self:SetIntelRadius('Vision', vis)
        elseif (new == 'Up' or new == 'Top') then
			self:OpenWings()
			self:PlayUnitSound('TakeOff')
            self:ForkThread(self.StartMoveFxTA)
			local bpVision = self:GetBlueprint().Intel.VisionRadius
            if bpVision then
                self:SetIntelRadius('Vision', bpVision)
            else
                self:SetIntelRadius('Vision', 0)
            end
        end
	end,
    
    OpenWings = function(self)
	end,

	CloseWings = function(self)
	end,

	OnRunOutOfFuel = function(self)
		self.HasFuel = false
        # penalize movement for running out of fuel
        self:SetSpeedMult(0.25)     # change the speed of the unit by this mult
        self:SetAccMult(0.25)       # change the acceleration of the unit by this mult
        self:SetTurnMult(0.25)      # change the turn ability of the unit by this mult
    end,

	OnGotFuel = function(self)
		self.HasFuel = true
        # revert these values to the blueprint values
        self:SetSpeedMult(1)
        self:SetAccMult(1)
        self:SetTurnMult(1)
	end,
}