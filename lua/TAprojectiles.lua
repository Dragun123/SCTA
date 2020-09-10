local SinglePolyTrailProjectile = import('/lua/sim/Defaultprojectiles.lua').SinglePolyTrailProjectile
local TAutils = import('/mods/SCTA/lua/TAutils.lua')

TAProjectile = Class(SinglePolyTrailProjectile) {
	Smoke = false,

	FxSmoke = '/mods/SCTA/effects/emitters/smoke_emit.bp',
	FxSmokeScale = 1,

	PolyTrail =  '/effects/emitters/aeon_laser_trail_02_emit.bp',

	OnCreate = function(self)
		SinglePolyTrailProjectile.OnCreate(self)
		if self.TrackTime then
			self:ForkThread( self.TrackingThread, self )
		end
		if self.Smoke == true then
			self.Trash:Add(CreateAttachedEmitter(self, 0, self:GetArmy(), self.FxSmoke):ScaleEmitter(self.FxSmokeScale))
		end
        	---self:SetCollisionShape('Sphere', 0, 0, 0, 1)
	end,

	TrackingThread = function(self)
		WaitSeconds(self.TrackTime)
		self:TrackTarget(false)
		self.Smoke = false
	end,

    PassData = function(self, data)
        self.Data = data
    end,

    PassDamageData = function(self, DamageData)
        self.DamageData.DamageRadius = DamageData.DamageRadius
        self.DamageData.DamageAmount = DamageData.DamageAmount
        self.DamageData.DamageType = DamageData.DamageType
        self.DamageData.DamageFriendly = DamageData.DamageFriendly
        self.DamageData.CollideFriendly = DamageData.CollideFriendly
        self.DamageData.DoTTime = DamageData.DoTTime
        self.DamageData.DoTPulses = DamageData.DoTPulses
        self.DamageData.MetaImpactAmount = DamageData.MetaImpactAmount
        self.DamageData.MetaImpactRadius = DamageData.MetaImpactRadius
        self.DamageData.Buffs = DamageData.Buffs
        self.DamageData.ArtilleryShieldBlocks = DamageData.ArtilleryShieldBlocks
        self.DamageData.InitialDamageAmount = DamageData.InitialDamageAmount
        self.CollideFriendly = self.DamageData.CollideFriendly
	end,
	
	DoDamage = function(self, instigator, DamageData, targetEntity)
        local damage = DamageData.DamageAmount
        if damage and damage > 0 then
            local radius = DamageData.DamageRadius
            if radius and radius > 0 then
                if not DamageData.DoTTime or DamageData.DoTTime <= 0 then
                    DamageArea(instigator, self:GetPosition(), radius, damage, DamageData.DamageType, DamageData.DamageFriendly, DamageData.DamageSelf or false)
                else
                    -- DoT damage - check for initial damage
                    local initialDmg = DamageData.InitialDamageAmount or 0
                    if initialDmg > 0 then
                        if radius > 0 then
                            DamageArea(instigator, self:GetPosition(), radius, initialDmg, DamageData.DamageType, DamageData.DamageFriendly, DamageData.DamageSelf or false)
                        elseif targetEntity then
                            Damage(instigator, self:GetPosition(), targetEntity, initialDmg, DamageData.DamageType)
                        end
                    end

                    ForkThread(DefaultDamage.AreaDoTThread, instigator, self:GetPosition(), DamageData.DoTPulses or 1, (DamageData.DoTTime / (DamageData.DoTPulses or 1)), radius, damage, DamageData.DamageType, DamageData.DamageFriendly)
                end
            -- ONLY DO DAMAGE IF THERE IS DAMAGE DATA.  SOME PROJECTILE DO NOT DO DAMAGE WHEN THEY IMPACT.
            elseif DamageData.DamageAmount and targetEntity then
                if not DamageData.DoTTime or DamageData.DoTTime <= 0 then
                    Damage(instigator, self:GetPosition(), targetEntity, DamageData.DamageAmount, DamageData.DamageType)
                else
                    -- DoT damage - check for initial damage
                    local initialDmg = DamageData.InitialDamageAmount or 0
                    if initialDmg > 0 then
                        if radius > 0 then
                            DamageArea(instigator, self:GetPosition(), radius, initialDmg, DamageData.DamageType, DamageData.DamageFriendly, DamageData.DamageSelf or false)
                        elseif targetEntity then
                            Damage(instigator, self:GetPosition(), targetEntity, initialDmg, DamageData.DamageType)
                        end
                    end

                    ForkThread(DefaultDamage.UnitDoTThread, instigator, targetEntity, DamageData.DoTPulses or 1, (DamageData.DoTTime / (DamageData.DoTPulses or 1)), damage, DamageData.DamageType, DamageData.DamageFriendly)
                end
            end
        end
        if self.InnerRing and self.OuterRing then
            local pos = self:GetPosition()
            self.InnerRing:DoNukeDamage(self.Launcher, pos, self.Brain, self.Army, DamageData.DamageType or 'Nuke')
            self.OuterRing:DoNukeDamage(self.Launcher, pos, self.Brain, self.Army, DamageData.DamageType or 'Nuke')
        end
    end,
}

TANuclearProjectile = Class(TAProjectile) {
	Smoke = true,
	FxImpactAirUnit = {
		'/mods/SCTA/effects/emitters/COMBOOM_emit.bp',
	},
	FxAirUnitHitScale = 15,
	FxImpactShield = {
		'/mods/SCTA/effects/emitters/COMBOOM_emit.bp',
	},
	FxShieldHitScale = 15,
	FxImpactUnit = {
		'/mods/SCTA/effects/emitters/COMBOOM_emit.bp',
	},
	FxUnitHitScale = 15,
	FxImpactProp = {
		'/mods/SCTA/effects/emitters/COMBOOM_emit.bp',
	},
	FxPropHitScale = 15,
	FxImpactLand = {
		'/mods/SCTA/effects/emitters/COMBOOM_emit.bp',
	},
	FxLandHitScale = 15,
	FxImpactWater = {
		'/effects/emitters/destruction_water_splash_ripples_01_emit.bp',
		'/effects/emitters/destruction_water_splash_wash_01_emit.bp',
		'/effects/emitters/destruction_water_splash_plume_01_emit.bp',
	},
    	FxWaterHitScale = 15,
	    FxImpactProjectile = {
    		'/mods/SCTA/effects/emitters/terran_missile_hit_01_emit.bp',
    		'/mods/SCTA/effects/emitters/terran_missile_hit_03_emit.bp',
    		'/mods/SCTA/effects/emitters/terran_missile_hit_04_emit.bp',
	},
	FxProjectileHitScale = 1.5,
    
    FxImpactTrajectoryAligned = false,

}

TAEMPNuclearProjectile = Class(TAProjectile) {
	Smoke = true,
	FxImpactAirUnit = {
		'/mods/SCTA/effects/emitters/EMPBOOM_emit.bp',
	},
	FxAirUnitHitScale = 15,
	FxImpactShield = {
		'/mods/SCTA/effects/emitters/EMPBOOM_emit.bp',
	},
	FxShieldHitScale = 15,
	FxImpactUnit = {
		'/mods/SCTA/effects/emitters/EMPBOOM_emit.bp',
	},
	FxUnitHitScale = 15,
	FxImpactProp = {
		'/mods/SCTA/effects/emitters/EMPBOOM_emit.bp',
	},
	FxPropHitScale = 15,
	FxImpactLand = {
		'/mods/SCTA/effects/emitters/EMPBOOM_emit.bp',
	},
	FxLandHitScale = 15,
	FxImpactWater = {
		'/effects/emitters/destruction_water_splash_ripples_01_emit.bp',
		'/effects/emitters/destruction_water_splash_wash_01_emit.bp',
		'/effects/emitters/destruction_water_splash_plume_01_emit.bp',
	},
    	FxWaterHitScale = 15,
	    FxImpactProjectile = {
    		'/mods/SCTA/effects/emitters/terran_missile_hit_01_emit.bp',
    		'/mods/SCTA/effects/emitters/terran_missile_hit_03_emit.bp',
    		'/mods/SCTA/effects/emitters/terran_missile_hit_04_emit.bp',
	},
	FxProjectileHitScale = 1.5,
    
    FxImpactTrajectoryAligned = false,

}

TAHeavyCannonProjectile = Class(TAProjectile) {
	FxImpactAirUnit = {
		'/mods/SCTA/effects/emitters/napalm_fire_emit.bp',
		'/mods/SCTA/effects/emitters/napalm_03_emit.bp',
		'/mods/SCTA/effects/emitters/napalm_03_emit.bp',
		'/mods/SCTA/effects/emitters/napalm_03_emit.bp',
    		'/mods/SCTA/effects/emitters/terran_missile_hit_01_emit.bp',
	},
	FxAirUnitHitScale = 2,
	FxImpactShield = {
		'/mods/SCTA/effects/emitters/napalm_fire_emit.bp',
		'/mods/SCTA/effects/emitters/napalm_03_emit.bp',
		'/mods/SCTA/effects/emitters/napalm_03_emit.bp',
		'/mods/SCTA/effects/emitters/napalm_03_emit.bp',
    		'/mods/SCTA/effects/emitters/terran_missile_hit_01_emit.bp',
	},
	FxShieldHitScale = 2,
	FxImpactUnit = {
		'/mods/SCTA/effects/emitters/napalm_fire_emit.bp',
		'/mods/SCTA/effects/emitters/napalm_03_emit.bp',
		'/mods/SCTA/effects/emitters/napalm_03_emit.bp',
		'/mods/SCTA/effects/emitters/napalm_03_emit.bp',
    		'/mods/SCTA/effects/emitters/terran_missile_hit_01_emit.bp',
	},
	FxUnitHitScale = 2,
	FxImpactProp = {
		'/mods/SCTA/effects/emitters/napalm_fire_emit.bp',
		'/mods/SCTA/effects/emitters/napalm_03_emit.bp',
		'/mods/SCTA/effects/emitters/napalm_03_emit.bp',
		'/mods/SCTA/effects/emitters/napalm_03_emit.bp',
    		'/mods/SCTA/effects/emitters/terran_missile_hit_01_emit.bp',
	},
	FxPropHitScale = 2,
	FxImpactLand = {
		'/mods/SCTA/effects/emitters/napalm_fire_emit.bp',
		'/mods/SCTA/effects/emitters/napalm_03_emit.bp',
		'/mods/SCTA/effects/emitters/napalm_03_emit.bp',
		'/mods/SCTA/effects/emitters/napalm_03_emit.bp',
    	'/mods/SCTA/effects/emitters/terran_missile_hit_01_emit.bp',
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
		'/mods/SCTA/effects/emitters/napalm_fire_emit.bp',
	},
	FxAirUnitHitScale = 1.25,
	FxImpactShield = {
		'/mods/SCTA/effects/emitters/napalm_fire_emit.bp',
	},
	FxShieldHitScale = 1.25,
	FxImpactUnit = {
		'/mods/SCTA/effects/emitters/napalm_fire_emit.bp',
	},
	FxUnitHitScale = 1.25,
	FxImpactProp = {
		'/mods/SCTA/effects/emitters/napalm_fire_emit.bp',
	},
	FxPropHitScale = 1.25,
	FxImpactLand = {
		'/mods/SCTA/effects/emitters/napalm_fire_emit.bp',
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
    		'/mods/SCTA/effects/emitters/terran_missile_hit_01_emit.bp',
    		'/mods/SCTA/effects/emitters/terran_missile_hit_03_emit.bp',
    		'/mods/SCTA/effects/emitters/terran_missile_hit_04_emit.bp',
	},
	FxNoneHitScale = 0.35,
	FxImpactShield = {
    		'/mods/SCTA/effects/emitters/terran_missile_hit_01_emit.bp',
    		'/mods/SCTA/effects/emitters/terran_missile_hit_03_emit.bp',
    		'/mods/SCTA/effects/emitters/terran_missile_hit_04_emit.bp',
	},
	FxShieldHitScale = 0.35,
	FxImpactUnit = {
    		'/mods/SCTA/effects/emitters/terran_missile_hit_01_emit.bp',
    		'/mods/SCTA/effects/emitters/terran_missile_hit_03_emit.bp',
    		'/mods/SCTA/effects/emitters/terran_missile_hit_04_emit.bp',
	},
	FxUnitHitScale = 0.35,
	FxImpactAirUnit = {
    		'/mods/SCTA/effects/emitters/terran_missile_hit_01_emit.bp',
    		'/mods/SCTA/effects/emitters/terran_missile_hit_03_emit.bp',
    		'/mods/SCTA/effects/emitters/terran_missile_hit_04_emit.bp',
	},
	FxAirUnitHitScale = 0.35,
	FxImpactProp = {
    		'/mods/SCTA/effects/emitters/terran_missile_hit_01_emit.bp',
    		'/mods/SCTA/effects/emitters/terran_missile_hit_03_emit.bp',
    		'/mods/SCTA/effects/emitters/terran_missile_hit_04_emit.bp',
	},
	FxPropHitScale = 0.35,
	FxImpactLand = {
    		'/mods/SCTA/effects/emitters/terran_missile_hit_01_emit.bp',
    		'/mods/SCTA/effects/emitters/terran_missile_hit_03_emit.bp',
    		'/mods/SCTA/effects/emitters/terran_missile_hit_04_emit.bp',
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
    		'/mods/SCTA/effects/emitters/terran_missile_hit_04_emit.bp',
	},
	FxAirUnitHitScale = 0.25,
	FxImpactShield = {
    		'/mods/SCTA/effects/emitters/terran_missile_hit_04_emit.bp',
	},
	FxShieldHitScale = 0.25,
	FxImpactUnit = {
    		'/mods/SCTA/effects/emitters/terran_missile_hit_04_emit.bp',
	},
	FxUnitHitScale = 0.25,
	FxImpactProp = {
    		'/mods/SCTA/effects/emitters/terran_missile_hit_04_emit.bp',
	},
	FxPropHitScale = 0.25,
	FxImpactLand = {
    		'/mods/SCTA/effects/emitters/terran_missile_hit_04_emit.bp',
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
    		'/mods/SCTA/effects/emitters/terran_missile_hit_01_emit.bp',
    		'/mods/SCTA/effects/emitters/terran_missile_hit_03_emit.bp',
    		'/mods/SCTA/effects/emitters/terran_missile_hit_04_emit.bp',
	},
	FxProjectileHitScale = 1.5,
}

TALaserProjectile = Class(TAProjectile) {

	FxImpactAirUnit = {
    		'/mods/SCTA/effects/emitters/terran_missile_hit_01_emit.bp',
	},
	FxAirUnitHitScale = 0.25,
	FxImpactShield = {
    		'/mods/SCTA/effects/emitters/terran_missile_hit_01_emit.bp',
	},
	FxShieldHitScale = 0.25,
	FxImpactUnit = {
    		'/mods/SCTA/effects/emitters/terran_missile_hit_01_emit.bp',
	},
	FxUnitHitScale = 0.25,
	FxImpactProp = {
    		'/mods/SCTA/effects/emitters/terran_missile_hit_01_emit.bp',
	},
	FxPropHitScale = 0.25,
	FxImpactLand = {
    		'/mods/SCTA/effects/emitters/terran_missile_hit_01_emit.bp',
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
    		'/mods/SCTA/effects/emitters/terran_missile_hit_01_emit.bp',
    		'/mods/SCTA/effects/emitters/terran_missile_hit_03_emit.bp',
    		'/mods/SCTA/effects/emitters/terran_missile_hit_03_emit.bp',
    		'/mods/SCTA/effects/emitters/terran_missile_hit_04_emit.bp',
	},
	FxUnderWaterHitScale = 0.35,
	FxImpactWater = {
		'/effects/emitters/destruction_water_splash_ripples_01_emit.bp',
	},
		FxWaterHitScale = 0.35,
	
		PassDamageThread = function(self)
			local bp = self:GetLauncher():GetBlueprint().Weapon
			WaitSeconds(0.1)
			self.DamageData.DamageAmount = bp.DamageWater or 100
			self.DamageData.DamageRadius = bp.DamageRadiusWater or 0
		end,
}