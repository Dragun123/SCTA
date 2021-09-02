local DefaultProjectileFile = import('/lua/sim/defaultprojectiles.lua')
local SinglePolyTrailProjectile = DefaultProjectileFile.SinglePolyTrailProjectile
local NukeProjectile = DefaultProjectileFile.NukeProjectile
local OnWaterEntryEmitterProjectile = DefaultProjectileFile.OnWaterEntryEmitterProjectile

TAProjectile = Class(SinglePolyTrailProjectile) {
	PolyTrail =  '',
}

TANuclearProjectile = Class(NukeProjectile) {
	FxTrails = { '/mods/SCTA-master/effects/emitters/smoke_emit.bp'},

    InitialEffects = {'/mods/SCTA-master/effects/emitters/damage_bad_smoke_emit.bp',},
    LaunchEffects = {
        '/effects/emitters/nuke_munition_launch_trail_03_emit.bp',
        '/effects/emitters/nuke_munition_launch_trail_05_emit.bp',
        '/effects/emitters/nuke_munition_launch_trail_07_emit.bp',
    },
    ThrustEffects = {
        '/effects/emitters/nuke_munition_launch_trail_04_emit.bp',
        '/effects/emitters/nuke_munition_launch_trail_06_emit.bp',
    },
	    FxImpactProjectile = {
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_01_emit.bp',
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_03_emit.bp',
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_04_emit.bp',
	},
	FxProjectileHitScale = 1.5,
    
    FxImpactTrajectoryAligned = false,

}
TAHeavyCannonProjectile = Class(TAProjectile) {
	FxImpactAirUnit = {
		'/mods/SCTA-master/effects/emitters/TANapalm_emit.bp',
		'/effects/emitters/napalm_03_emit.bp',
		'/effects/emitters/napalm_03_emit.bp',
		'/effects/emitters/napalm_03_emit.bp',
    	'/mods/SCTA-master/effects/emitters/ta_missile_hit_01_emit.bp',
	},
	FxAirUnitHitScale = 2,
	FxImpactShield = {
		'/mods/SCTA-master/effects/emitters/TANapalm_emit.bp',
		'/effects/emitters/napalm_03_emit.bp',
		'/effects/emitters/napalm_03_emit.bp',
		'/effects/emitters/napalm_03_emit.bp',
    	'/mods/SCTA-master/effects/emitters/ta_missile_hit_01_emit.bp',
	},
	FxShieldHitScale = 2,
	FxImpactUnit = {
		'/mods/SCTA-master/effects/emitters/TANapalm_emit.bp',
		'/effects/emitters/napalm_03_emit.bp',
		'/effects/emitters/napalm_03_emit.bp',
		'/effects/emitters/napalm_03_emit.bp',
    	'/mods/SCTA-master/effects/emitters/ta_missile_hit_01_emit.bp',
	},
	FxUnitHitScale = 2,
	FxImpactProp = {
		'/mods/SCTA-master/effects/emitters/TANapalm_emit.bp',
		'/effects/emitters/napalm_03_emit.bp',
		'/effects/emitters/napalm_03_emit.bp',
		'/effects/emitters/napalm_03_emit.bp',
    	'/mods/SCTA-master/effects/emitters/ta_missile_hit_01_emit.bp',
	},
	FxPropHitScale = 2,
	FxImpactLand = {
		'/mods/SCTA-master/effects/emitters/TANapalm_emit.bp',
		'/effects/emitters/napalm_03_emit.bp',
		'/effects/emitters/napalm_03_emit.bp',
		'/effects/emitters/napalm_03_emit.bp',
    	'/mods/SCTA-master/effects/emitters/ta_missile_hit_01_emit.bp',
	},
	FxLandHitScale = 2,
	FxImpactWater = {
		'/effects/emitters/destruction_water_splash_ripples_01_emit.bp',
		'/effects/emitters/destruction_water_splash_wash_01_emit.bp',
		'/effects/emitters/destruction_water_splash_plume_01_emit.bp',
	},
    	FxWaterHitScale = 1.5,
}

TACannonProjectile = Class(TAProjectile) {
	FxImpactAirUnit = {
		'/mods/SCTA-master/effects/emitters/TANapalm_emit.bp',
	},
	FxAirUnitHitScale = 1.25,
	FxImpactShield = {
		'/mods/SCTA-master/effects/emitters/TANapalm_emit.bp',
	},
	FxShieldHitScale = 1.25,
	FxImpactUnit = {
		'/mods/SCTA-master/effects/emitters/TANapalm_emit.bp',
	},
	FxUnitHitScale = 1.25,
	FxImpactProp = {
		'/mods/SCTA-master/effects/emitters/TANapalm_emit.bp',
	},
	FxPropHitScale = 1.25,
	FxImpactLand = {
		'/mods/SCTA-master/effects/emitters/TANapalm_emit.bp',
	},
	FxLandHitScale = 1.25,
	FxImpactWater = {
		'/effects/emitters/destruction_water_splash_ripples_01_emit.bp',
		'/effects/emitters/destruction_water_splash_wash_01_emit.bp',
		'/effects/emitters/destruction_water_splash_plume_01_emit.bp',
	},
    	FxWaterHitScale = 0.75,
}

TAMediumCannonProjectile = Class(TAProjectile) {
	FxImpactNone = {
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_01_emit.bp',
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_03_emit.bp',
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_04_emit.bp',
	},
	FxNoneHitScale = 0.35,
	FxImpactShield = {
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_01_emit.bp',
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_03_emit.bp',
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_04_emit.bp',
	},
	FxShieldHitScale = 0.35,
	FxImpactUnit = {
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_01_emit.bp',
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_03_emit.bp',
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_04_emit.bp',
	},
	FxUnitHitScale = 0.35,
	FxImpactAirUnit = {
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_01_emit.bp',
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_03_emit.bp',
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_04_emit.bp',
	},
	FxAirUnitHitScale = 0.35,
	FxImpactProp = {
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_01_emit.bp',
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_03_emit.bp',
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_04_emit.bp',
	},
	FxPropHitScale = 0.35,
	FxImpactLand = {
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_01_emit.bp',
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_03_emit.bp',
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_04_emit.bp',
	},
	FxLandHitScale = 0.35,
	FxImpactWater = {
		'/effects/emitters/destruction_water_splash_ripples_01_emit.bp',
		'/effects/emitters/destruction_water_splash_wash_01_emit.bp',
		'/effects/emitters/destruction_water_splash_plume_01_emit.bp',
	},
    	FxWaterHitScale = 0.5,
}

TABombProjectile = Class(TAMediumCannonProjectile) {
	OnImpact = function(self, targetType, targetEntity)
        if targetType ~= 'Shield' and targetType ~= 'Water' and targetType ~= 'Air' and targetType ~= 'UnitAir' and targetType ~= 'Projectile' then
            local RandomFloat = import('/lua/utilities.lua').GetRandomFloat
            local rotation = RandomFloat(0,2*math.pi)
            local radius = self.DamageData.DamageRadius
            local size = radius + RandomFloat(0.75,2.0)
            local pos = self:GetPosition()
            local army = self.Army

            DamageArea(self, pos, radius, 1, 'Force', true)
            DamageArea(self, pos, radius, 1, 'Force', true)
 			CreateDecal(pos, rotation, 'scorch_001_albedo', '', 'Albedo', size, size, 150, 30, army)
		end	 
		TAMediumCannonProjectile.OnImpact( self, targetType, targetEntity )
    end,
}
TALightCannonProjectile = Class(TAProjectile) {
	FxImpactAirUnit = {
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_04_emit.bp',
	},
	FxAirUnitHitScale = 0.25,
	FxImpactShield = {
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_04_emit.bp',
	},
	FxShieldHitScale = 0.25,
	FxImpactUnit = {
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_04_emit.bp',
	},
	FxUnitHitScale = 0.25,
	FxImpactProp = {
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_04_emit.bp',
	},
	FxPropHitScale = 0.25,
	FxImpactLand = {
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_04_emit.bp',
	},
	FxLandHitScale = 0.25,
	FxImpactWater = {
		'/effects/emitters/destruction_water_splash_ripples_01_emit.bp',
		'/effects/emitters/destruction_water_splash_wash_01_emit.bp',
	},
    	FxWaterHitScale = 0.5,
}

Disintegrator = Class(TALightCannonProjectile) {
	OnCreate = function(self)
		TALightCannonProjectile.OnCreate(self)
		self.launcher = self:GetLauncher()
		self.launcher.EconDrain = CreateEconomyEvent(self.launcher, 500, 0, 0)
		self.DGunDamage = self.launcher:GetWeaponByLabel('OverCharge'):GetBlueprint().DGun
		self.launcher:ForkThread(function()
                WaitFor(self.launcher.EconDrain)
                RemoveEconomyEvent(self.launcher, self.launcher.EconDrain)
				self.launcher.EconDrain = nil
			end)
		ForkThread(self.MovementThread, self)
	end,

	MovementThread = function(self)
		---need to figure out the double hitting code and why
		---damage adjustment for commanders
		while not IsDestroyed(self) do
			local pos = self:GetPosition()
		if pos.y < GetTerrainHeight(pos.x, pos.z) then
			self:SetTurnRate(0)
			self:TrackTarget(false)
			pos.y = GetTerrainHeight(pos.x, pos.z)
			DamageArea( self.launcher, pos, self.DamageData.DamageRadius, self.DGunDamage, self.DamageData.DamageType, self.DamageData.DamageFriendly)
				self:SetPosition(pos, true)
				self:PlaySound(Sound({Cue = 'XPLOMAS2', Bank = 'TA_Sound', LodCutoff = 'Weapon_LodCutoff'}))
				CreateEmitterAtEntity(self, self:GetArmy(), '/mods/SCTA-master/effects/emitters/ta_missile_hit_04_emit.bp' ):ScaleEmitter(0.5)
			end
			--WaitSeconds(0.1)
			coroutine.yield(2)
		end
	end,

	OnImpact = function(self, targetType, targetEntity)
		self.DamageData.DamageAmount = 0
		TALightCannonProjectile.OnImpact(self, targetType, targetEntity)
	end,
}
TAFlame = Class(TALightCannonProjectile) {
	FxTrails = {'/mods/SCTA-master/effects/emitters/TAFlamethrower_emit.bp'},
}

FlameProjectile = Class(TAFlame) {
	OnCreate = function(self)
		TAFlame.OnCreate(self)
		self.launcher = self:GetLauncher()
		ForkThread(self.MovementThread, self)
	end,

	MovementThread = function(self)
		while not IsDestroyed(self) do
			local pos = self:GetPosition()
			DamageArea(self.launcher, pos, 1, self.DamageData.DamageAmount, self.DamageData.DamageType, self.DamageData.DamageFriendly)
			--WaitSeconds(0.1)
			coroutine.yield(2)
		end
	end,

	FxImpactAirUnit = {},
	FxImpactShield = {},
	FxImpactUnit = {},
	FxImpactProp = {},
	FxImpactLand = {},
	FxImpactWater = {},
}

TAAntiRocketProjectile = Class(TAMediumCannonProjectile) {
	FxTrails = { '/mods/SCTA-master/effects/emitters/smoke_emit.bp'},
}

TARocketProjectile = Class(TAAntiRocketProjectile) {
	OnCreate = function(self)
	TAAntiRocketProjectile.OnCreate(self)
	self.TrackTime = self:GetBlueprint().Physics.TrackTime
	self:ForkThread( self.TrackingThread, self )
end,

	TrackingThread = function(self)
		WaitSeconds(self.TrackTime)
		self:TrackTarget(false)
	end,
}

TASAMProjectile = Class(TARocketProjectile) {
	OnCreate = function(self)
		TARocketProjectile.OnCreate(self)
		local target = self:GetTrackingTarget()
		if target and EntityCategoryContains(categories.AIR, target) then
		self:SetAcceleration(self:GetBlueprint().Physics.AirAccel)
			--LOG('TATarget', )
		end
	end,
}


TAMissileProjectile = Class(TARocketProjectile) {
	OnCreate = function(self)
	TARocketProjectile.OnCreate(self)
	self:SetCollisionShape('Sphere', 0, 0, 0, 1)
end,

TrackingThread = function(self)
	self:TrackTarget(false)
	WaitSeconds(self.TrackTime/2)
	self:TrackTarget(true)
	WaitSeconds(self.TrackTime)
	self:TrackTarget(false)
end,
}


TAAntiNukeProjectile = Class(SinglePolyTrailProjectile) {
	FxImpactProjectile = {
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_01_emit.bp',
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_03_emit.bp',
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_04_emit.bp',
	},
	FxProjectileHitScale = 1.5,
	FxTrails = { '/mods/SCTA-master/effects/emitters/smoke_emit.bp'},

	OnCreate = function(self)
		SinglePolyTrailProjectile.OnCreate(self)
		self:ForkThread( self.TrackingThread, self )
	end,
	
	TrackingThread = function(self)
		self:TrackTarget(false)
		WaitTicks(2)
		self:TrackTarget(true)
	end,
}

TALaserProjectile = Class(TAProjectile) {
	FxImpactAirUnit = {
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_01_emit.bp',
	},
	FxAirUnitHitScale = 0.25,
	FxImpactShield = {
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_01_emit.bp',
	},
	FxShieldHitScale = 0.25,
	FxImpactUnit = {
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_01_emit.bp',
	},
	FxUnitHitScale = 0.25,
	FxImpactProp = {
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_01_emit.bp',
	},
	FxPropHitScale = 0.25,
	FxImpactLand = {
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_01_emit.bp',
	},
	FxLandHitScale = 0.25,
	FxImpactWater = {
		'/effects/emitters/destruction_water_splash_ripples_01_emit.bp',
		'/effects/emitters/destruction_water_splash_wash_01_emit.bp',
	},
    FxWaterHitScale = 0.5,
}

TAEMGProjectile = Class(TALaserProjectile) {
}

TAYellowLaserProjectile = Class(TALaserProjectile ) {
	PolyTrail = '/mods/SCTA-master/effects/emitters/YELLOW_LASER_emit.bp',
}

TAGreenLaserProjectile = Class(TALaserProjectile ) {
	PolyTrail = '/mods/SCTA-master/effects/emitters/GREEN_LASER_emit.bp',
}

TARedLaserProjectile = Class(TALaserProjectile ) {
	PolyTrail = '/mods/SCTA-master/effects/emitters/RED_LASER_emit.bp',
}

TABlueLaserProjectile = Class(TALaserProjectile ) {
	PolyTrail = '/mods/SCTA-master/effects/emitters/BLUE_LASER_emit.bp',
}

TALIGHTNING = Class(TALaserProjectile ) {
	PolyTrail = '/mods/SCTA-master/effects/emitters/LIGHTNING_emit.bp',
}

TADepthCharges = Class(OnWaterEntryEmitterProjectile) {
    OnEnterWater = function(self)
        OnWaterEntryEmitterProjectile.OnEnterWater(self)
		for k,v in self.FxImpactWater do
			CreateEmitterAtEntity(self, self:GetArmy(), v):ScaleEmitter(self.FxWaterHitScale)
		end
    end,

	OnExitWater = function(self)
		OnWaterEntryEmitterProjectile.OnExitWater(self)
		for k,v in self.FxImpactWater do
			CreateEmitterAtEntity(self, self:GetArmy(), v):ScaleEmitter(self.FxWaterHitScale)
		end
	end,

	FxImpactLand = {
		'/effects/emitters/destruction_water_splash_ripples_01_emit.bp',
		'/effects/emitters/destruction_water_splash_wash_01_emit.bp',
		'/effects/emitters/destruction_water_splash_plume_01_emit.bp',
	},

	FxImpactUnderWater = {
		'/mods/SCTA-master/effects/emitters/ta_missile_hit_01_emit.bp',
		'/mods/SCTA-master/effects/emitters/ta_missile_hit_03_emit.bp',
		'/mods/SCTA-master/effects/emitters/ta_missile_hit_04_emit.bp',
	},
	FxUnderWaterHitScale = 0.35,
	
	FxImpactWater = {
		'/effects/emitters/destruction_water_splash_ripples_01_emit.bp',
	},
		FxWaterHitScale = 0.35,
}

TAUnderWaterProjectile = Class(TADepthCharges) {

    OnCreate = function(self, inWater)
        TADepthCharges.OnCreate(self, inWater)
		self:SetCollisionShape('Sphere', 0, 0, 0, 1)
	end,

}