#Generic TA unit
local Unit = import('/lua/sim/Unit.lua').Unit
local FireState = import('/lua/game.lua').FireState
local explosion = import('/lua/defaultexplosions.lua')
local scenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')
local Game = import('/lua/game.lua')
local util = import('/lua/utilities.lua')

TAunit = Class(Unit) 
{
	lastHitVector = nil,
	buildAngle = 0,
	--TextureAnimation = false,
    	FxDamage1 = {},
    	FxDamage2 = {},
    	FxDamage3 = {},
	FxMovement = nil,
	Suicide = nil,
	CurrentSpeed = 'Stopped',
	FxReclaim = nil,
	DestructionExplosionWaitDelayMin = 0,
	DestructionExplosionWaitDelayMax = 0,

    LOGDBG = function(self, msg)
        --LOG(self._UnitName .. "(" .. self.Sync.id .. "):" .. msg)
    end,

	OnCreate = function(self)
		local bp = self:GetBlueprint()
        self._UnitName = bp.General.UnitName
        self:LOGDBG('TAUnit.OnCreate')
        Unit.OnCreate(self)
		self:SetFireState(FireState.GROUND_FIRE)
		if bp.General.BuildAngle then
		 	local angle = bp.General.BuildAngle / 182
			angle = (180 + self.buildAngle) * (math.pi / 180)
	 		local x = math.cos(angle / 2) 
	  		local z = math.sin(angle / 2) 
			Warp(self, self:GetPosition(), {0, x, 0, z}) 
		end
		--self:SetReclaimTimeMultiplier(50)
		self:SetDeathWeaponEnabled(true)
		self:HideFlares()
		self.FxMovement = TrashBag()
		if not EntityCategoryContains(categories.NOSMOKE, self) then
			ForkThread(self.Smoke, self)
		end
	end,

	OnStopBeingBuilt = function(self,builder,layer)
        self:LOGDBG('TAUnit.OnStopBeingBuilt')
		Unit.OnStopBeingBuilt(self,builder,layer)
		self:SetConsumptionActive(true)	
		ForkThread(self.IdleEffects, self)
	end,
	

	MovementEffects = function(self, EffectsBag, TypeSuffix)
		self:LOGDBG('TAUnit.MovementEffects')
		Unit.MovementEffects(self, EffectsBag, TypeSuffix)
		local bp = self:GetBlueprint()
		if not IsDestroyed(self) and bp.Display.MovementEffects then
			for k, v in bp.Display.MovementEffects.Bones do
				self.FxMovement:Add(CreateAttachedEmitter(self, v, self:GetArmy(), bp.Display.MovementEffects.Emitter ):ScaleEmitter(bp.Display.MovementEffects.Scale))
			end
		end
	end,

	IdleEffects = function(self)
        self:LOGDBG('TAUnit.IdleEffects')
		local bp = self:GetBlueprint()
		if not IsDestroyed(self) and not self:IsMoving() and bp.Display.IdleEffects then
			for k, v in bp.Display.IdleEffects.Bones do
				self.FxMovement:Add(CreateAttachedEmitter(self, v, self:GetArmy(), bp.Display.IdleEffects.Emitter ):ScaleEmitter(bp.Display.IdleEffects.Scale))
			end
		end
	end,
	
	Smoke = function(self)
        self:LOGDBG('TAUnit.Smoke')
		local bone = self:GetBlueprint().Display.SmokeBone or -1
		while not IsDestroyed(self) do
			if self:GetFractionComplete() == 1 then
				if self:GetHealth()/self:GetMaxHealth() < 0.25 then
					CreateEmitterAtBone(self, bone, self:GetArmy(), '/mods/SCTA-master/effects/emitters/damage_bad_smoke_emit.bp' )
					CreateEmitterAtBone(self, bone, self:GetArmy(), '/mods/SCTA-master/effects/emitters/damage_bad_smoke_emit.bp' )
				elseif self:GetHealth()/self:GetMaxHealth() < 0.5 then
					CreateEmitterAtBone(self, bone, self:GetArmy(), '/mods/SCTA-master/effects/emitters/damage_smoke_emit.bp' )
					CreateEmitterAtBone(self, bone, self:GetArmy(), '/mods/SCTA-master/effects/emitters/damage_bad_smoke_emit.bp' )
				elseif self:GetHealth()/self:GetMaxHealth() < 0.75 then
					CreateEmitterAtBone(self, bone, self:GetArmy(), '/mods/SCTA-master/effects/emitters/damage_smoke_emit.bp' )
				end
			end
			WaitSeconds(0.5)
		end
	end,

	ShowMuzzleFlare = function(self, duration)
        self:LOGDBG('TAUnit.ShowMuzzleFlare')
		local bp = self:GetBlueprint()
		#Show flare bone for pre-determined time
		self.unit:ShowBone(bp.RackBones[self.CurrentRackSalvoNumber - 1].MuzzleBones[1], true)
		WaitSeconds(duration)
		self.unit:HideBone(bp.RackBones[self.CurrentRackSalvoNumber - 1].MuzzleBones[1], true)
	end,


    HideFlares = function(self, bp)
        self:LOGDBG('TAUnit.HideFlares')
        if not bp then bp = self:GetBlueprint().Weapon end
        if bp then
            for i, weapon in bp do
                if weapon.RackBones then
                    for j, rack in weapon.RackBones do
                        if not rack.VisibleMuzzle then
                            if rack.MuzzleBones[1] and not rack.MuzzleBones[2] and self:IsValidBone(rack.MuzzleBones[1]) then
                                self:HideBone(rack.MuzzleBones[1], true)
                            elseif rack.MuzzleBones[2] then
                                for mi, muzzle in rack.MuzzleBones do
                                    if self:IsValidBone(muzzle) then
                                        self:HideBone(muzzle, true)
                                    end
                                end
                            end    
                        end
                    end
                end
            end
        end
    end,

}

TAPop = Class(TAunit) {
	damageReduction = 1,
	Pack = function(self)
		self.damageReduction = 0.28
		self:EnableIntel('RadarStealth')
	end,

}

TAMass = Class(TAunit) {
    OnCreate = function(self)
        TAunit.OnCreate(self)
        local markers = scenarioUtils.GetMarkers()
        local unitPosition = self:GetPosition()

        for k, v in pairs(markers) do
            if(v.type == 'MASS') then
                local massPosition = v.position
                if( (massPosition[1] < unitPosition[1] + 1) and (massPosition[1] > unitPosition[1] - 1) and
                    (massPosition[2] < unitPosition[2] + 1) and (massPosition[2] > unitPosition[2] - 1) and
                    (massPosition[3] < unitPosition[3] + 1) and (massPosition[3] > unitPosition[3] - 1)) then
                    self:SetProductionPerSecondMass(self:GetProductionPerSecondMass() * (v.amount / 100))
                    break
                end
            end
        end
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        TAunit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionActive()
    end,


    OnStartBuild = function(self, unitbuilding, order)
        TAunit.OnStartBuild(self, unitbuilding, order)
        self:AddCommandCap('RULEUCC_Stop')
    end,

    OnStopBuild = function(self, unitbuilding, order)
        TAunit.OnStopBuild(self, unitbuilding, order)
        self:RemoveCommandCap('RULEUCC_Stop') 
    end,
	}
	
TAnoassistbuild = Class(TAunit) {
noassistbuild = true,

    OnDamage = function(self, instigator, amount, vector, damageType)
        TAunit.OnDamage(self, instigator, amount, vector, damageType)
        WaitSeconds(1)
        for _, v in self:GetGuards() do
            if not v.Dead then
                IssueClearCommands({v})
                IssueGuard({v},self)
            end
        end
    end,

}
