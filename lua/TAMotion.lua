local TAunit = import('/mods/SCTA-master/lua/TAunit.lua').TAunit

TASea = Class(TAunit) 
{
    OnCreate = function(self)
        TAunit.OnCreate(self)
		self.FxMovement = TrashBag()
        end,

     
	OnMotionHorzEventChange = function(self, new, old )
		TAunit.OnMotionHorzEventChange(self, new, old)
		self.CreateMovementEffects(self)
	end,
    
    
	CreateMovementEffects = function(self, EffectsBag, TypeSuffix)
		if not IsDestroyed(self) then
		TAunit.CreateMovementEffects(self, EffectsBag, TypeSuffix)
		local bp = self:GetBlueprint()
		if self:IsUnitState('Moving') and bp.Display.MovementEffects.TAMovement then
			for k, v in bp.Display.MovementEffects.TAMovement.Bones do
				self.FxMovement:Add(CreateAttachedEmitter(self, v, self:GetArmy(), bp.Display.MovementEffects.TAMovement.Emitter ):ScaleEmitter(bp.Display.MovementEffects.TAMovement.Scale))
			end
		end
		if not self:IsUnitState('Moving') then
			for k,v in self.FxMovement do
				v:Destroy()
			end
		end
		end
	end,
}

TAWalking = Class(TAunit) 
{
    WalkingAnim = nil,
    WalkingAnimRate = 1,
    IdleAnim = false,
    IdleAnimRate = 1,
    DeathAnim = nil,
    DisabledBones = {},

    OnMotionHorzEventChange = function( self, new, old )
        ---self:LOGDBG('TAWalking.OnMotionHorzEventChange')
        TAunit.OnMotionHorzEventChange(self, new, old)
        if ( old == 'Stopped' ) then
            if (not self.Animator) then
                self.Animator = CreateAnimator(self, true)
            end
            local bpDisplay = self:GetBlueprint().Display
            if bpDisplay.AnimationWalk then
                self.Animator:PlayAnim(bpDisplay.AnimationWalk, true)
                self.Animator:SetRate(bpDisplay.AnimationWalkRate or 1)
            end
        elseif ( new == 'Stopped' ) then
            if(self.IdleAnim and not self:IsDead()) then
                self.Animator:PlayAnim(self.IdleAnim, true)
            elseif(not self.DeathAnim or not self:IsDead()) then
                self.Animator:Destroy()
                self.Animator = false
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

TASeaWalking = Class(TAWalking) 
{
    OnCreate = function(self)
        TAWalking.OnCreate(self)
		self.FxMovement = TrashBag()
        end,

     
	OnMotionHorzEventChange = function(self, new, old )
		TAWalking.OnMotionHorzEventChange(self, new, old)
		self.CreateMovementEffects(self)
	end,
    
    
	CreateMovementEffects = function(self, EffectsBag, TypeSuffix)
		if not IsDestroyed(self) then
			TAWalking.CreateMovementEffects(self, EffectsBag, TypeSuffix)
		local bp = self:GetBlueprint()
		if self:IsUnitState('Moving') and bp.Display.MovementEffects.TAMovement then
			for k, v in bp.Display.MovementEffects.TAMovement.Bones do
				self.FxMovement:Add(CreateAttachedEmitter(self, v, self:GetArmy(), bp.Display.MovementEffects.TAMovement.Emitter ):ScaleEmitter(bp.Display.MovementEffects.TAMovement.Scale))
			end
		end
			if not self:IsUnitState('Moving') then
			for k,v in self.FxMovement do
				v:Destroy()
			end
		end
		end
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