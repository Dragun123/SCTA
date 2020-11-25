#Generic TA unit
local Unit = import('/lua/sim/Unit.lua').Unit
local FireState = import('/lua/game.lua').FireState
local explosion = import('/lua/defaultexplosions.lua')
local scenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')
local Game = import('/lua/game.lua')
local util = import('/lua/utilities.lua')
local debrisCat = import('/mods/SCTA-master/lua/TAdebrisCategories.lua')

TAunit = Class(Unit) 
{
	lastHitVector = nil,
	buildAngle = 0,
	textureAnimation = false,
    	FxDamage1 = {},
    	FxDamage2 = {},
    	FxDamage3 = {},
	FxMovement = nil,
	Suicide = false,
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
		self:SetDeathWeaponEnabled(false)
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
		self.textureAnimation = true
		ForkThread(self.IdleEffects, self)
	end,
	
	OnMotionVertEventChange = function(self, new, old )
        self:LOGDBG('TAUnit.OnMotionVertEventChange')
		local bp = self:GetBlueprint()
		if (old == 'Bottom') then
			if bp.Display.MovementEffects then
				ForkThread(self.MovementEffects, self)
			end
		elseif (new == 'Bottom' and old == 'Down') then
			if self.FxMovement then
				ForkThread(self.IdleEffects, self)
				for k,v in self.FxMovement do
					v:Destroy()
				end
			end
		end
	end,

	OnMotionHorzEventChange = function(self, new, old )
        self:LOGDBG('TAUnit.OnMotionHorzEventChange')
	        if self:IsDead() then
        	    return
	        end

		local bp = self:GetBlueprint()
		if (new == 'Cruise') then
			if bp.Display.MovementEffects then
				ForkThread(self.MovementEffects, self)
			end
			if old == 'Stopped' then
                		self:PlayUnitSound('StartMove')
			end
		elseif (new == 'Stopped') then
				if self.FxMovement then
					ForkThread(self.IdleEffects, self)
					for k,v in self.FxMovement do
						v:Destroy()
					end
			end
			self:PlayUnitSound('StopMove')
		end
		self.CurrentSpeed = new
			self:StopRocking()
	end,

				
	MovementEffects = function(self)
        self:LOGDBG('TAUnit.MovementEffects')
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

	OnKilled = function(self, instigator, type, overkillRatio)
        self:LOGDBG('TAUnit.OnKilled')
		local bp = self:GetBlueprint()
		if self:GetFractionComplete() == 1 then
			for k, weapon in bp.Weapon do
				#Self Destruct
				if ((self == instigator and weapon.Label == 'SuicideWeapon') or (self != instigator and weapon.Label == 'DeathWeapon') and type ~= "Reclaimed") then
					TAutils.DoTaperedAreaDamage(self, self:GetPosition(), weapon.DamageRadius, weapon.Damage, nil, nil, 'Normal', true, false, weapon.EdgeEffectiveness)
					if (self == instigator and weapon.Label == 'SuicideWeapon') then
						self:CreateDebrisProjectiles()
						self.Suicide = true
					end
				end
			end
		end
		Unit.OnKilled(self, instigator, type, overkillRatio)
	end,

	CreateWreckage = function( self, overkillRatio )
        self:LOGDBG('TAUnit.CreateWreckage')
		# if overkill ratio is high, the wreck is vaporized! No wreakage for you!
		if overkillRatio then
			if overkillRatio > 0.075 then
				self:CreateDebrisProjectiles()
				return
			end
		end

		# generate wreakage in place of the dead unit
	        if self:GetBlueprint().Wreckage.WreckageLayers[self:GetCurrentLayer()] and self.Suicide == false then
			TAutils.QueueDelayedWreckage(self, overkillRatio, self:GetBlueprint(), self:GetFractionComplete(), self:GetPosition(), self:GetOrientation(), self:GetMaxHealth())
		end
	end,

	CreateDestructionEffects = function( self, overKillRatio )
        self:LOGDBG('TAUnit.CreateDestructionEffects')
		local bp = self:GetBlueprint()
		if bp.Display.DestructionEffects then
 			if self:GetFractionComplete() == 1 then
				--if not EntityCategoryContains(categories.NOEXPLOSION, self) then
				--	CreateLightParticle( self, 0, self:GetArmy(), bp.Display.DestructionEffects.FlashSize or 20, bp.Display.DestructionEffects.FlashTime or 10, 'ExplosionGlow', 'ramp_ExplosionGlow' )
				--end
				if bp.Display.DestructionEffects.DestructionEmitters then
					for k,v in bp.Display.DestructionEffects.DestructionEmitters do
						for bk,bv in v.EmitterBone do
							for ek, ev in v.EmitterBlueprint do
								CreateEmitterAtBone(self, bv, self:GetArmy(), ev):ScaleEmitter(v.EmitterSize)
							end
						end
					end
				end
	    	self:HideBone(0, true)
			end
		end
	end,

	CreateDebrisProjectiles = function(self)
        self:LOGDBG('TAUnit.CreateDebrisProjectiles')
	    local bp = self:GetBlueprint()
	    local sx = bp.SizeX
	    local sy = bp.SizeY
	    local sz = bp.SizeZ
	    local partamounts = util.GetRandomInt( bp.Display.DestructionEffects.DefaultFlamingProjectileCountMin or 1, bp.Display.DestructionEffects.DefaultFlamingProjectileCountMax or ((sx * sz / 4) + 3)) 
		LOG("PartAmounts: ",partamounts)
	    for i = 1, partamounts do
	        local xpos, ypos, zpos = util.GetRandomOffset( sx, sy, sz, 1)
        	local xdir,ydir,zdir = util.GetRandomOffset( sx, sy, sz, 10)
        	self:CreateProjectile('/mods/SCTA-master/effects/entities/Debris/Flame/DefaultFlameProjectileDebris_proj.bp',xpos,ypos,zpos,xdir,ydir + 5,zdir)
	    end
	    partamounts = util.GetRandomInt( bp.Display.DestructionEffects.DefaultProjectileCountMin or 5, bp.Display.DestructionEffects.DefaultProjectileCountMax or (sx * sz + 4)) 
		LOG("PartAmounts: ",partamounts)
	    local z = math.cos(self:GetHeading())
	    local x = math.sin(self:GetHeading())
	    for i = 1, partamounts do
	        local xpos, ypos, zpos = util.GetRandomOffset( sx, sy, sz, 1)
        	local xdir,ydir,zdir = util.GetRandomOffset( sx, sy, sz, 10)

		local debrisList = {}
		if bp.Display.DestructionEffects.DefaultProjectileCategories then
			for k, v in bp.Display.DestructionEffects.DefaultProjectileCategories do
				for ek, ev in debrisCat.RULEDPC[v] do
					table.insert(debrisList, ev)
				end
			end
		else
			debrisList = debrisCat.RULEDPC.RULEDPC_Generic
		end
		if debrisList then
			if bp.Display.DestructionEffects.DestructionDebrisUseLocalVelocity and bp.Display.DestructionEffects.DestructionDebrisUseLocalVelocity == true then
				speed = bp.Physics.MaxSpeed
				if self.CurrentSpeed == 'Stopped' then
					speed = 0
				elseif self.CurrentSpeed == 'Cruise' then
					speed = speed / 2
				elseif self.CurrentSpeed == 'Stopping' then
					speed = speed / 5
				end
				xdir = xpos + x*speed
				zdir = zpos + z*speed
				ydir = ypos + sy
			end
	        	local debris = self:CreateProjectile(debrisList[util.GetRandomInt(1,table.getn(debrisList))],xpos,ypos,zpos,xdir,ydir,zdir)
			if bp.Display.DestructionEffects.DestructionDebrisUseLocalVelocity and bp.Display.DestructionEffects.DestructionDebrisUseLocalVelocity == true then
				debris:SetVelocity(speed)
			end
		end
	    end
	    if bp.Display.DestructionEffects.DestructionProjectiles then
		    for k, v in bp.Display.DestructionEffects.DestructionProjectiles do
	        	self:CreateProjectileAtBone(v.ProjectileBlueprint,v.Bone)
		    end
	    end
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

    OnReclaimed = function(self, entity)
        self:LOGDBG('TAUnit.OnReclaimed')
        self:DoUnitCallbacks('OnReclaimed', entity)
		self.CreateReclaimEndEffects( entity, self )
        self:OnKilled(entity, "Reclaimed", 0.0)
    end,

    DeathThread = function( self, overkillRatio, instigator)
        self:LOGDBG('TAUnit.DeathThread')
        #LOG('*DEBUG: OVERKILL RATIO = ', repr(overkillRatio))

        #WaitSeconds( utilities.GetRandomFloat( self.DestructionExplosionWaitDelayMin, self.DestructionExplosionWaitDelayMax) )
        self:DestroyAllDamageEffects()

        if self.PlayDestructionEffects then
            self:CreateDestructionEffects( self, overkillRatio )
        end

        #MetaImpact( self, self:GetPosition(), 0.1, 0.5 )
        if self.DeathAnimManip then
            WaitFor(self.DeathAnimManip)
            if self.PlayDestructionEffects and self.PlayEndAnimDestructionEffects then
                self:CreateDestructionEffects( self, overkillRatio )
            end
        end

        self:CreateWreckage( overkillRatio )
        if( self.ShowUnitDestructionDebris and overkillRatio ) then
            if overkillRatio <= 1 then
                self.CreateUnitDestructionDebris( self, true, true, false )
            elseif overkillRatio <= 2 then
                self.CreateUnitDestructionDebris( self, true, true, false )
            elseif overkillRatio <= 3 then
                self.CreateUnitDestructionDebris( self, true, true, true )
            else #VAPORIZED
                self.CreateUnitDestructionDebris( self, true, true, true )
            end
        end

        #LOG('*DEBUG: DeathThread Destroying in ',  self.DeathThreadDestructionWaitTime )
        WaitSeconds(self.DeathThreadDestructionWaitTime)

        self:PlayUnitSound('Destroyed')
        self:Destroy()
	end,

	AddBuff = function(self, buffTable, PosEntity)
        self:LOGDBG('TAUnit.AddBuff' .. self._UnitName .. self.Sync.id)
        local bt = buffTable.BuffType

        if not bt then
            error('*ERROR: Tried to add a unit buff in unit.lua but got no buff table.  Wierd.', 1)
            return
        end
        #When adding debuffs we have to make sure that we check for permissions
        local allow = categories.ALLUNITS
        if buffTable.TargetAllow then
            allow = ParseEntityCategory(buffTable.TargetAllow)
        end
        local disallow
        if buffTable.TargetDisallow then
            disallow = ParseEntityCategory(buffTable.TargetDisallow)
        end

        if bt == 'STUN' then
           if buffTable.Radius and buffTable.Radius > 0 then
                #if the radius is bigger than 0 then we will use the unit as the center of the stun blast
                #and collect all targets from that point
                local targets = {}
                if PosEntity then
                    targets = util.GetEnemyUnitsInSphere(self, PosEntity, buffTable.Radius)
                else
                    targets = util.GetEnemyUnitsInSphere(self, self:GetPosition(), buffTable.Radius)
                end
                if not targets then
                    #LOG('*DEBUG: No targets in radius to buff')
                    return
                end
                for k, v in targets do
                    if EntityCategoryContains(allow, v) and (not disallow or not EntityCategoryContains(disallow, v)) then
                        v:SetStunned(buffTable.Duration or 1)
                    end
                end
            else
                #The buff will be applied to the unit only
                if EntityCategoryContains(allow, self) and (not disallow or not EntityCategoryContains(disallow, self)) then
                    self:SetStunned(buffTable.Duration or 1)
                end
            end
        elseif bt == 'MAXHEALTH' then
            self:SetMaxHealth(self:GetMaxHealth() + (buffTable.Value or 0))
        elseif bt == 'HEALTH' then
            self:SetHealth(self, self:GetHealth() + (buffTable.Value or 0))
        elseif bt == 'SPEEDMULT' then
            self:SetSpeedMult(buffTable.Value or 0)
        elseif bt == 'MAXFUEL' then
            self:SetFuelUseTime(buffTable.Value or 0)
        elseif bt == 'FUELRATIO' then
            self:SetFuelRatio(buffTable.Value or 0)
        elseif bt == 'HEALTHREGENRATE' then
            self:SetRegenRate(buffTable.Value or 0)
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
