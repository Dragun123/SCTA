local SinglePolyTrailProjectile = import('/lua/sim/Defaultprojectiles.lua').SinglePolyTrailProjectile
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')

TAProjectile = Class(SinglePolyTrailProjectile) {
	Smoke = nil,

	FxSmoke = '/mods/SCTA-master/effects/emitters/smoke_emit.bp',
	FxSmokeScale = 1,

	PolyTrail =  '/effects/emitters/aeon_laser_trail_02_emit.bp',

	OnCreate = function(self)
		SinglePolyTrailProjectile.OnCreate(self)
		if self.TrackTime then
			self:ForkThread( self.TrackingThread, self )
		end
		if self.Smoke then
			self.Trash:Add(CreateAttachedEmitter(self, 0, self:GetArmy(), self.FxSmoke):ScaleEmitter(self.FxSmokeScale))
		end
        	---self:SetCollisionShape('Sphere', 0, 0, 0, 1)
	end,

	TrackingThread = function(self)
		WaitSeconds(self.TrackTime)
		self:TrackTarget(false)
		self.Smoke = nil
	end,
}

TANuclearProjectile = Class(TAProjectile) {
	Smoke = true,
	FxImpactAirUnit = {
		'/mods/SCTA-master/effects/emitters/COMBOOM_emit.bp',
	},
	FxAirUnitHitScale = 15,
	FxImpactShield = {
		'/mods/SCTA-master/effects/emitters/COMBOOM_emit.bp',
	},
	FxShieldHitScale = 15,
	FxImpactUnit = {
		'/mods/SCTA-master/effects/emitters/COMBOOM_emit.bp',
	},
	FxUnitHitScale = 15,
	FxImpactProp = {
		'/mods/SCTA-master/effects/emitters/COMBOOM_emit.bp',
	},
	FxPropHitScale = 15,
	FxImpactLand = {
		'/mods/SCTA-master/effects/emitters/COMBOOM_emit.bp',
	},
	FxLandHitScale = 15,
	FxImpactWater = {
		'/effects/emitters/destruction_water_splash_ripples_01_emit.bp',
		'/effects/emitters/destruction_water_splash_wash_01_emit.bp',
		'/effects/emitters/destruction_water_splash_plume_01_emit.bp',
	},
    	FxWaterHitScale = 15,
	    FxImpactProjectile = {
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_01_emit.bp',
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_03_emit.bp',
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_04_emit.bp',
	},
	FxProjectileHitScale = 1.5,
    
    FxImpactTrajectoryAligned = false,

}

TAEMPNuclearProjectile = Class(TAProjectile) {
	Smoke = true,
	FxImpactAirUnit = {
		'/mods/SCTA-master/effects/emitters/EMPBOOM_emit.bp',
	},
	FxAirUnitHitScale = 15,
	FxImpactShield = {
		'/mods/SCTA-master/effects/emitters/EMPBOOM_emit.bp',
	},
	FxShieldHitScale = 15,
	FxImpactUnit = {
		'/mods/SCTA-master/effects/emitters/EMPBOOM_emit.bp',
	},
	FxUnitHitScale = 15,
	FxImpactProp = {
		'/mods/SCTA-master/effects/emitters/EMPBOOM_emit.bp',
	},
	FxPropHitScale = 15,
	FxImpactLand = {
		'/mods/SCTA-master/effects/emitters/EMPBOOM_emit.bp',
	},
	FxLandHitScale = 15,
	FxImpactWater = {
		'/effects/emitters/destruction_water_splash_ripples_01_emit.bp',
		'/effects/emitters/destruction_water_splash_wash_01_emit.bp',
		'/effects/emitters/destruction_water_splash_plume_01_emit.bp',
	},
    	FxWaterHitScale = 15,
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
		'/mods/SCTA-master/effects/emitters/napalm_fire_emit.bp',
		'/mods/SCTA-master/effects/emitters/napalm_03_emit.bp',
		'/mods/SCTA-master/effects/emitters/napalm_03_emit.bp',
		'/mods/SCTA-master/effects/emitters/napalm_03_emit.bp',
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_01_emit.bp',
	},
	FxAirUnitHitScale = 2,
	FxImpactShield = {
		'/mods/SCTA-master/effects/emitters/napalm_fire_emit.bp',
		'/mods/SCTA-master/effects/emitters/napalm_03_emit.bp',
		'/mods/SCTA-master/effects/emitters/napalm_03_emit.bp',
		'/mods/SCTA-master/effects/emitters/napalm_03_emit.bp',
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_01_emit.bp',
	},
	FxShieldHitScale = 2,
	FxImpactUnit = {
		'/mods/SCTA-master/effects/emitters/napalm_fire_emit.bp',
		'/mods/SCTA-master/effects/emitters/napalm_03_emit.bp',
		'/mods/SCTA-master/effects/emitters/napalm_03_emit.bp',
		'/mods/SCTA-master/effects/emitters/napalm_03_emit.bp',
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_01_emit.bp',
	},
	FxUnitHitScale = 2,
	FxImpactProp = {
		'/mods/SCTA-master/effects/emitters/napalm_fire_emit.bp',
		'/mods/SCTA-master/effects/emitters/napalm_03_emit.bp',
		'/mods/SCTA-master/effects/emitters/napalm_03_emit.bp',
		'/mods/SCTA-master/effects/emitters/napalm_03_emit.bp',
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_01_emit.bp',
	},
	FxPropHitScale = 2,
	FxImpactLand = {
		'/mods/SCTA-master/effects/emitters/napalm_fire_emit.bp',
		'/mods/SCTA-master/effects/emitters/napalm_03_emit.bp',
		'/mods/SCTA-master/effects/emitters/napalm_03_emit.bp',
		'/mods/SCTA-master/effects/emitters/napalm_03_emit.bp',
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
		'/mods/SCTA-master/effects/emitters/napalm_fire_emit.bp',
	},
	FxAirUnitHitScale = 1.25,
	FxImpactShield = {
		'/mods/SCTA-master/effects/emitters/napalm_fire_emit.bp',
	},
	FxShieldHitScale = 1.25,
	FxImpactUnit = {
		'/mods/SCTA-master/effects/emitters/napalm_fire_emit.bp',
	},
	FxUnitHitScale = 1.25,
	FxImpactProp = {
		'/mods/SCTA-master/effects/emitters/napalm_fire_emit.bp',
	},
	FxPropHitScale = 1.25,
	FxImpactLand = {
		'/mods/SCTA-master/effects/emitters/napalm_fire_emit.bp',
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

TAMissileProjectile = Class(TAMediumCannonProjectile) {
	Smoke = true,
	OnCreate = function(self)
	self:SetCollisionShape('Sphere', 0, 0, 0, 1)
	TAMediumCannonProjectile.OnCreate(self)
	end,
}


TAAntiNukeProjectile = Class(TAMissileProjectile) {
	FxImpactProjectile = {
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_01_emit.bp',
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_03_emit.bp',
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_04_emit.bp',
	},
	FxProjectileHitScale = 1.5,
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

TAEMGProjectile = Class(TALaserProjectile ) {
}

TAUnderWaterProjectile = Class(TAMediumCannonProjectile) {
	OnCreate = function(self)
		self:SetCollisionShape('Sphere', 0, 0, 0, 1)
		TAMediumCannonProjectile.OnCreate(self)
		ForkThread(self.MovementThread, self)
		end,

		MovementThread = function(self)
			self:TrackTarget(true)
			WaitSeconds(0.1)
			self:SetTurnRate(50)
			local target = self:GetTrackingTarget()
			if target and IsBlip(target) then target = target:GetSource() end
			if target and IsUnit(target) then
				local layer = target:GetCurrentLayer()
				if layer == 'Sub' then
					self:ForkThread(self.PassDamageThread)
				end
			end
		end,

		
	OnEnterWater = function(self)
		for k,v in self.FxImpactWater do
			CreateEmitterAtEntity(self, self:GetArmy(), v):ScaleEmitter(self.FxWaterHitScale)
		end
	end,

	OnExitWater = function(self)
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
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_03_emit.bp',
    		'/mods/SCTA-master/effects/emitters/ta_missile_hit_04_emit.bp',
	},
	FxUnderWaterHitScale = 0.35,
	FxImpactWater = {
		'/effects/emitters/destruction_water_splash_ripples_01_emit.bp',
	},
		FxWaterHitScale = 0.35,
}