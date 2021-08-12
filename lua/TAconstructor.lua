local TAWalking = import('/mods/SCTA-master/lua/TAMotion.lua').TAWalking
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')
local oldPosition={1,1,1}
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat

TAconstructor = Class(TAWalking) {
    OnCreate = function(self)
        TAWalking.OnCreate(self) 
        local bp = self:GetBlueprint()
        -- Save build effect bones for faster access when creating build effects
        self.BuildEffectBones = bp.General.BuildBones.BuildEffectBones

        self.EffectsBag = {}
        if bp.General.BuildBones then
            self:SetupBuildBones()
        end

        if bp.Display.AnimationBuild then
            self.BuildingOpenAnim = bp.Display.AnimationBuild
        end

        if self.BuildingOpenAnim then
            self.BuildingOpenAnimManip = CreateAnimator(self)
            self.BuildingOpenAnimManip:SetPrecedence(1)
            self.BuildingOpenAnimManip:PlayAnim(self.BuildingOpenAnim, false):SetRate(0)
            if self.BuildArmManipulator then
                self.BuildArmManipulator:Disable()
            end
        end
        self.BuildingUnit = false
        if __blueprints['armgant'] and not (EntityCategoryContains(categories.TECH3 + categories.COMMAND + categories.SUBCOMMANDER, self) or self:GetAIBrain().Level3) then
            TAutils.updateBuildRestrictions(self)
        end
        --LOG('*Who', self:GetBlueprint().General.FactionName)
    end,

    OnPaused = function(self)
        self:StopUnitAmbientSound('Construct')
        if self.BuildingUnit then
            self:UpdateConsumptionValues()
            TAWalking.StopBuildingEffects(self, self.UnitBeingBuilt)
        end
        TAWalking.OnPaused(self)
    end,

    OnUnpaused = function(self)
        if self.BuildingUnit then
            self:PlayUnitAmbientSound('Construct')
            TAWalking.StartBuildingEffects(self, self.UnitBeingBuilt, self.UnitBuildOrder)
            self:UpdateConsumptionValues()
        end
        TAWalking.OnUnpaused(self)
    end,
    
    OnStartBuild = function(self, unitBeingBuilt, order ) 
        self.UnitBeingBuilt = unitBeingBuilt
        self.UnitBuildOrder = order
        self.BuildingUnit = true
        TAWalking.OnStartBuild(self, unitBeingBuilt, order)
        if not self:GetGuardedUnit() and unitBeingBuilt:GetFractionComplete() == 0 and not self:CanBuild(unitBeingBuilt:GetBlueprint().BlueprintId) then
            IssueStop({self})
            IssueClearCommands({self})
            unitBeingBuilt:Destroy()
        end
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        TAWalking.OnStopBeingBuilt(self, builder, layer)
        if __blueprints['armgant'] and self.TARestrict then
            TAutils.TABuildRestrictions(self)
        end
    end,  

    OnStopBuild = function(self, unitBeingBuilt)
        self.UnitBeingBuilt = nil
        self.UnitBuildOrder = nil

        if self.BuildingOpenAnimManip and self.BuildArmManipulator then
            self.StoppedBuilding = true
        elseif self.BuildingOpenAnimManip then
            self.BuildingOpenAnimManip:SetRate(-1)
        end
        self.BuildingUnit = false
        self:SetImmobile(false)
        TAWalking.OnStopBuild(self, unitBeingBuilt)
    end,

    WaitForBuildAnimation = function(self, enable)
        if self.BuildArmManipulator then
            WaitFor(self.BuildingOpenAnimManip)
            if enable then
                self.BuildArmManipulator:Enable()
            end
        end
    end,


    OnPrepareArmToBuild = function(self)
        TAWalking.OnPrepareArmToBuild(self)
        if self.BuildingOpenAnimManip then
            self.BuildingOpenAnimManip:SetRate(self:GetBlueprint().Display.AnimationBuildRate or 1)
            if self.BuildArmManipulator then
                self.StoppedBuilding = false
                self:ForkThread(self.WaitForBuildAnimation, true)
            end
        end
        if self:IsMoving() then
            self:SetImmobile(true)
            self:ForkThread(function() WaitTicks(1) if not self:BeenDestroyed() then self:SetImmobile(false) end end)
        end
    end,

    OnFailedToBuild = function(self)
        TAWalking.OnFailedToBuild(self)
        self:SetImmobile(false)
    end,

    OnStopBuilderTracking = function(self)
        TAWalking.OnStopBuilderTracking(self)
        if self.StoppedBuilding then
            self.StoppedBuilding = false
            self.BuildArmManipulator:Disable()
            self.BuildingOpenAnimManip:SetRate(-(self:GetBlueprint().Display.AnimationBuildRate or 1))
            self:SetImmobile(false)
        end
    end,
    
    CreateBuildEffects = function( self, unitBeingBuilt, order )
        self.BuildEffectsBag:Add( TAutils.CreateTABuildingEffects( self, unitBeingBuilt, self.BuildEffectBones, self.BuildEffectsBag ))
    end,

    CreateReclaimEffects = function( self, target )
        self.ReclaimEffectsBag:Add(TAutils.TAReclaimEffects(self, target, self.BuildEffectBones or {0, }, self.ReclaimEffectsBag))
    end,

    OnStopReclaim = function(self, target)
        TAWalking.OnStopReclaim(self, target)
        if self.BuildingOpenAnimManip then
            self.BuildingOpenAnimManip:SetRate(-1)
        end
    end,
        
}

TASeaConstructor = Class(TAconstructor) 
{
    OnMotionHorzEventChange = function( self, new, old )
        TAconstructor.OnMotionHorzEventChange(self, new, old)
        if ( new == 'Cruise' and old == 'Stopped') then
            self:ForkThread(self.StartMoveFxTA)
         end
        if ( new == 'Stopped' ) or ( new == 'Stopped' and old == 'Stopping' ) then
            self:ForkThread(self.MoveFxStopTA)
        end
    end,


}


TANecro = Class(TAconstructor) {
    OnStartReclaim = function(self, target)
        if self:GetBlueprint().Economy.Necro then
            if not target.ReclaimInProgress and not target.NecroingInProgress and not target:GetBlueprint().Economy.Heap then
                --LOG('* Necro: OnStartReclaim:  I am a necro! no ReclaimInProgress; starting Necroing')
                target.NecroingInProgress = true
				self.spawnUnit = true
                self.RecBP = target.AssociatedBP
                self.RecPosition = target:GetPosition()
            elseif not target.ReclaimInProgress and target.NecroingInProgress then
				--LOG('* Necro: OnStartReclaim:  I am a necro and helping necro')
				self.RecBP = nil
				self.RecPosition = target:GetPosition()
			else
                --LOG('* Necro: OnStartReclaim:  I am a necro and ReclaimInProgress; Stopped!')
				self.RecBP = nil
                self.RecPosition = nil
                IssueStop({self})
                IssueClearCommands({self})
                return
            end
        else
            if not target.NecroingInProgress then
                --LOG('* Necro: OnStartReclaim:  I am engineer, no NecroingInProgress, starting Reclaim')
                target.ReclaimInProgress = true
            else
                --LOG('* Necro: OnStartReclaim:  I am engineer and NecroingInProgress; Stopped!')
                IssueStop({self})
                IssueClearCommands({self})
                return
            end
        end
        TAconstructor.OnStartReclaim(self, target)
    end,

    OnStopReclaim = function(self, target)
        TAconstructor.OnStopReclaim(self, target)
        if not target then
            if self.RecBP and self:GetBlueprint().Economy.Necro and oldPosition ~= self.RecPosition and self.spawnUnit then
                --LOG('* Necro: OnStopReclaim:  I am a necro! and RecBP = true ')
                oldPosition = self.RecPosition
                self:ForkThread( self.RespawnUnit, self.RecBP, self:GetArmy(), self.RecPosition)
            else
                --LOG('* Necro: OnStopReclaim: no necro or no RecBP')
            end
        else
            if self:GetBlueprint().Economy.Necro then
                --LOG('* Necro: OnStopReclaim:  Wreck still exist. Removing target data from Necro')
                self.RecBP = nil
                self.RecPosition = nil
            else
                --LOG('* Necro: OnStopReclaim: Wreck still exist. no necro')
            end
        end
    end,

    RespawnUnit = function(self, RecBP, army, pos)
        --LOG('* Necro: RespawnUnit: ReclaimLeft '..ReclaimLeft)
        WaitTicks(3)
        local newUnit = CreateUnitHPR(RecBP, army, pos[1], pos[2], pos[3], 0, 0, 0)
        newUnit:SetHealth(nil, 100)
        newUnit.Necro = true
    end,
}

TACommander = Class(TAconstructor) {

    CreateReclaimEffects = function( self, target )
        self.ReclaimEffectsBag:Add(TAutils.TACommanderReclaimEffects(self, target, self.BuildEffectBones or {0, }, self.ReclaimEffectsBag))
    end,

    SetAutoOvercharge = function(self, auto)
        self:GetWeaponByLabel('AutoOverCharge'):SetAutoOvercharge(auto)
        self.Sync.AutoOvercharge = auto
    end,

    ResetRightArm = function(self)
       self:SetImmobile(false)
       self:SetWeaponEnabledByLabel('OverCharge', true)
        if self.Sync.AutoOvercharge then
        self:GetWeaponByLabel('AutoOverCharge'):SetAutoOvercharge(wep.AutoMode)
        end
    end,

    OnPrepareArmToBuild = function(self)
        TAconstructor.OnPrepareArmToBuild(self)
        self:SetWeaponEnabledByLabel('OverCharge', false)
        self:SetWeaponEnabledByLabel('AutoOverCharge', false)
    end,

    OnCreate = function(self)
		TAconstructor.OnCreate(self)
        self:SetCapturable(false)
        self:SetWeaponEnabledByLabel('AutoOverCharge', false)
	end,
    
    CreateCaptureEffects = function( self, target )
		TAutils.TACaptureEffect( self, target, self:GetBlueprint().General.BuildBones.BuildEffectBones or {0,}, self.CaptureEffectsBag )
    end,

	OnStopCapture = function(self, target)
		TAconstructor.OnStopCapture(self, target)
        if self:BeenDestroyed() then return end
        self:ResetRightArm()
	end,
    
    OnFailedCapture = function(self, target)
		TAconstructor.OnFailedCapture(self, target)
        if self:BeenDestroyed() then return end
        self:ResetRightArm()
    end,

	DeathThread = function(self)
        self:CreateProjectile('/effects/entities/UEFNukeEffect02/UEFNukeEffect02_proj.bp',0,1,0,0,0,1)
		CreateAttachedEmitter( self, 0, self:GetArmy(), '/mods/SCTA-master/effects/emitters/COMBOOM_emit.bp'):ScaleEmitter(10)
		TAconstructor.DeathThread(self)
    end,

    OnStartReclaim = function(self, target)
		TAconstructor.OnStartReclaim(self, target)
		self:SetScriptBit('RULEUTC_CloakToggle', true)
    end,

    OnStopReclaim = function(self, target)
        TAconstructor.OnStopReclaim(self, target)
        if self:BeenDestroyed() then return end
        self:ResetRightArm()
    end,

    OnStartCapture = function(self, target)
		TAconstructor.OnStartCapture(self, target)
		self:SetScriptBit('RULEUTC_CloakToggle', true)
    end,

    OnStopBuild = function(self, unitBeingBuilt)
        TAconstructor.OnStopBuild(self, unitBeingBuilt)
        if self:BeenDestroyed() then return end
        self:ResetRightArm()
    end,

    OnStopBeingBuilt = function(self,builder,layer)
		TAconstructor.OnStopBeingBuilt(self,builder,layer)
        self.MainCost = self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergy
        self.Mesh = self:GetBlueprint().Display.MeshBlueprint
        self.TACloak = true
		self:SetMaintenanceConsumptionInactive()
		self:SetScriptBit('RULEUTC_CloakToggle', true)
        self:RequestRefreshUI()
	end,


}

TARealCommander = Class(TACommander) {
    DeathThread = function(self)
        TACommander.DeathThread(self)
        self:CreateInitialFireballSmokeRing()
        self:ForkThread(self.CreateOuterRingWaveSmokeRing)
        CreateDecal(self:GetPosition(), RandomFloat(0,2*math.pi), 'Crater01_albedo', '', 'Albedo', 50, 50, 1200, 0, self.Army)
        CreateDecal(self:GetPosition(), RandomFloat(0,2*math.pi), 'Crater01_normals', '', 'Normals', 50, 50, 1200, 0, self.Army)
        CreateDecal(self:GetPosition(), RandomFloat(0,2*math.pi), 'nuke_scorch_003_albedo', '', 'Albedo', 60, 60, 1200, 0, self.Army)
    end,  

    CreateInitialFireballSmokeRing = function(self)
        local sides = 12
        local angle = (2*math.pi) / sides
        local velocity = 5
        local OffsetMod = 8

        for i = 0, (sides-1) do
            local X = math.sin(i*angle)
            local Z = math.cos(i*angle)
            self:CreateProjectile('/effects/entities/UEFNukeShockwave01/UEFNukeShockwave01_proj.bp', X * OffsetMod , 1.5, Z * OffsetMod, X, 0, Z)
                :SetVelocity(velocity):SetAcceleration(-0.5)
        end
    end,

    CreateOuterRingWaveSmokeRing = function(self)
        local sides = 32
        local angle = (2*math.pi) / sides
        local velocity = 7
        local OffsetMod = 8
        local projectiles = {}

        for i = 0, (sides-1) do
            local X = math.sin(i*angle)
            local Z = math.cos(i*angle)
            local proj =  self:CreateProjectile('/effects/entities/UEFNukeShockwave02/UEFNukeShockwave02_proj.bp', X * OffsetMod , 2.5, Z * OffsetMod, X, 0, Z)
                :SetVelocity(velocity)
            table.insert(projectiles, proj)
        end

        WaitSeconds(3)

        -- Slow projectiles down to normal speed
        for k, v in projectiles do
            v:SetAcceleration(-0.45)
        end
    end,


    OnKilled = function(self, instigator, type, overkillRatio)
        TACommander.OnKilled(self, instigator, type, overkillRatio)

        if instigator and instigator.Army ~= self.Army then
            local instigatorBrain = ArmyBrains[instigator.Army]

            Sync.EnforceRating = true
            WARN('ACU kill detected. Rating for ranked games is now enforced.')

            if IsAlly(self.Army, instigator.Army) and not ((type == 'DeathExplosion' or type == 'Nuke' or type == 'Deathnuke') and not instigator.SelfDestructed) then
                WARN('Teamkill detected')
                Sync.Teamkill = {killTime = GetGameTimeSeconds(), instigator = instigator.Army, victim = self.Army}
            else
                ForkThread(function()
                    instigatorBrain:ReportScore()
                end)
            end
        end
        ArmyBrains[self.Army].CommanderKilledBy = (instigator or self).Army
    end,
    
    DoTakeDamage = function(self, instigator, amount, vector, damageType)
        if damageType == 'Overcharge' then
            local wep = instigator:GetWeaponByLabel('OverCharge')
            amount = wep:GetBlueprint().Overcharge.commandDamage
        end
        TACommander.DoTakeDamage(self, instigator, amount, vector, damageType)
        local aiBrain = self:GetAIBrain()
        if aiBrain then
            aiBrain:OnPlayCommanderUnderAttackVO()
        end
        if self:GetHealth() < ArmyBrains[self.Army]:GetUnitStat(self.UnitId, "lowest_health") then
            ArmyBrains[self.Army]:SetUnitStat(self.UnitId, "lowest_health", self:GetHealth())
        end
    end,

    OnStopBeingBuilt = function(self,builder,layer)
		TACommander.OnStopBeingBuilt(self,builder,layer)
		ForkThread(self.GiveInitialResources, self)
	end,

	GiveInitialResources = function(self)
		self:GetAIBrain():GiveResource('ENERGY', self:GetBlueprint().Economy.StorageEnergy)
		self:GetAIBrain():GiveResource('MASS', self:GetBlueprint().Economy.StorageMass)
	end,

    PlayCommanderWarpInEffect = function(self)
        self:SetCustomName( ArmyBrains[self:GetArmy()].Nickname )
        self:SetUnSelectable(false)
        self:SetBlockCommandQueue(true)
        WaitSeconds(1)
		self.PlayCommanderWarpInEffectFlag = true
        self:ForkThread(self.ExplosionInEffectThread)
    end,

    ExplosionInEffectThread = function(self)
		self:PlayUnitSound('CommanderArrival')
		---self:CreateProjectile( '/effects/entities/UnitTeleport01/UnitTeleport01_proj.bp', 0, 1.35, 0, nil, nil, nil):SetCollision(false)
		self.PlayCommanderWarpInEffectFlag = false
		self:SetMesh(self:GetBlueprint().Display.CloakMeshBlueprint, true)
		self:ShowBone(0, true)
        self:CreateProjectile( '/mods/SCTA-master/effects/entities/TAEntrance/TAEntrance_proj.bp', 0, 1.35, 0, nil, nil, nil):SetCollision(false)
		WaitSeconds(4)
		self:SetMesh(self:GetBlueprint().Display.MeshBlueprint, true)
        self:SetUnSelectable(false)
		self:SetBusy(false)
		self:SetBlockCommandQueue(false)
        local rotateOpt = ScenarioInfo.Options['RotateACU']
        if not rotateOpt or rotateOpt == 'On' then
            self:RotateTowardsMid()
        elseif rotateOpt == 'Marker' then
            local marker = GetMarker(strArmy) or {}
            if marker['orientation'] then
                local o = EulerToQuaternion(unpack(marker['orientation']))
                self:SetOrientation(o, true)
            end
        end
    end,
}