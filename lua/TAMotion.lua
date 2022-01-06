local TAunit = import('/mods/SCTA-master/lua/TAunit.lua').TAunit

TASea = Class(TAunit) 
{
    OnMotionHorzEventChange = function( self, new, old )
        TAunit.OnMotionHorzEventChange(self, new, old)
        if ( new == 'Cruise' and old == 'Stopped') then
            self:ForkThread(self.StartMoveFxTA)
         end
        if ( new == 'Stopped' ) or ( new == 'Stopped' and old == 'Stopping' ) then
            self:ForkThread(self.MoveFxStopTA)
        end
    end,
}

TAWalking = Class(TAunit) 
{
    WalkingAnim = nil,
    WalkingAnimRate = 1,
    DeathAnim = nil,
    DisabledBones = {},

	OnCreate = function(self)
        TAunit.OnCreate(self)
		local bpDisplay = self:GetBlueprint().Display
		if bpDisplay.AnimationWalk then
        self.AnimationWalk = bpDisplay.AnimationWalk
        self.AnimationWalkRate = bpDisplay.AnimationWalkRate
		end
    end,

    OnMotionHorzEventChange = function( self, new, old )
        ---self:LOGDBG('TAWalking.OnMotionHorzEventChange')
        TAunit.OnMotionHorzEventChange(self, new, old)
		---_ALERT('PELICASCTA22', self:GetVelocity())
        if old == 'Stopped' then
            if not self.Animator then
                self.Animator = CreateAnimator(self, true)
            end
            if self.AnimationWalk then
                self.Animator:PlayAnim(self.AnimationWalk, true)
                self.Animator:SetRate(self.AnimationWalkRate or 1)
            end
			---_ALERT('PELICASCTA23', self:GetVelocity())
        elseif new == 'Stopped' then
            -- Only keep the animator around if we are dying and playing a death anim
            -- Or if we have an idle anim
            if self.Animator and (not self.DeathAnim or not self.Dead) then
                self.Animator:Destroy()
                self.Animator = nil
            end
        end
    end,
}

TACounter = Class(TAWalking) 
{ 
	OnStopBeingBuilt = function(self,builder,layer)
		TAWalking.OnStopBeingBuilt(self,builder,layer)
		self.MainCost = self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergy
		--if bp.Intel.RadarStealthField or bp.Intel.RadarRadius then
		self:SetMaintenanceConsumptionActive()
        self:SetScriptBit('RULEUTC_StealthToggle', false)
		if self:GetBlueprint().Intel.TAIntel then
			self:SetScriptBit('RULEUTC_JammingToggle', true)
			self.SpecIntel = true
		elseif self:GetBlueprint().Intel.Cloak then
			self.TACloak = true
			self.Mesh = self:GetBlueprint().Display.MeshBlueprint
			self:SetScriptBit('RULEUTC_CloakToggle', true)
		end
		TAWalking.OnIntelEnabled(self)
		self:RequestRefreshUI()
	end,  

	OnIntelDisabled = function(self)
		TAWalking.OnIntelDisabled(self)
		if self.Spinners then
			self.Spinners.fork:SetTargetSpeed(0)
		end
	end,


	OnIntelEnabled = function(self)
		TAWalking.OnIntelEnabled(self)
		if self.Spinners then
			self.Spinners.fork:SetTargetSpeed(100)
	 	end
	end,
}


TAKamiCounter = Class(TACounter) { 
	OnScriptBitSet = function(self, bit)
		TACounter.OnScriptBitSet(self, bit)
		if bit == 7 then
			self:ExplodeTA()
		end
	end,

	ExplodeTA = function(self)
		self:DisableUnitIntel('ToggleBit8', 'Cloak')
		self:GetWeaponByLabel('Suicide'):FireWeapon()
	end,

	OnKilled = function(self, instigator, type, overkillRatio)
		if self.attacked then
			instigator = self
		end
		TACounter.OnKilled(self, instigator, type, overkillRatio)
	end,
}

TASeaCounter = Class(TASea) 
{ 
	OnStopBeingBuilt = function(self,builder,layer)
		TASea.OnStopBeingBuilt(self,builder,layer)
		self.MainCost = self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergy
		self:SetMaintenanceConsumptionActive()
        self:SetScriptBit('RULEUTC_StealthToggle', false)
		if self:GetBlueprint().Intel.TAIntel then
			self:SetScriptBit('RULEUTC_JammingToggle', true)
			self.SpecIntel = true
		elseif self:GetBlueprint().Intel.Cloak then
			self.TACloak = true
			self.Mesh = self:GetBlueprint().Display.MeshBlueprint
			self:SetScriptBit('RULEUTC_CloakToggle', true)
		end
		TASea.OnIntelEnabled(self)
		self:RequestRefreshUI()
	end,

	OnIntelDisabled = function(self)
		TASea.OnIntelDisabled(self)
			if self.Spinners.fork then
				self.Spinners.fork:SetTargetSpeed(0)
			end
		end,
	
	
		OnIntelEnabled = function(self)
			TASea.OnIntelEnabled(self)
			if self.Spinners.fork then
				self.Spinners.fork:SetTargetSpeed(100)
			 end
		end,
}