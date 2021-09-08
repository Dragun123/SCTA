-----------------------------------------------------------------------------------------------
-- File     :  /effects/Entities/UEFNukeEffectController01/UEFNukeEffectController01_script.lua
-- Author(s):  Gordon Duclos
-- Summary  :  Nuclear explosion script
-- Copyright © 2005,2006 Gas Powered Games, Inc.  All rights reserved.
-----------------------------------------------------------------------------------------------
local NullShell = import('/lua/sim/defaultprojectiles.lua').NullShell
local EffectTemplate = import('/lua/EffectTemplates.lua')
local Util = import('/lua/utilities.lua')
local RandomFloat = Util.GetRandomFloat

TANuke01 = Class(NullShell) {
    EffectThread = function(self)
        local position = self:GetPosition()

        -- Create full-screen glow flash
        CreateLightParticle(self, -1, self.Army, 35, 4, 'glow_02', 'ramp_red_02')
        --WaitSeconds(0.25)
        coroutine.yield(3)
        CreateLightParticle(self, -1, self.Army, 80, 20, 'glow_03', 'ramp_fire_06')

        -- Create initial fireball dome effect
        --local FireballDomeYOffset = -5
        --self:CreateProjectile('/effects/entities/TANukeEffect01/TANukeEffect01_proj.bp',0,FireballDomeYOffset,0,0,0,1)

        -- Create projectile that controls plume effects
        local PlumeEffectYOffset = 1
        self:CreateProjectile('/mods/SCTA-master/effects/entities/TANukeEffect01/TANukeEffect01_proj.bp',0,PlumeEffectYOffset,0,0,0,1)

    
        CreateEmitterAtEntity(self, self.Army, '/mods/SCTA-master/effects/emitters/EMPBOOM_emit.bp')
        

        --self:CreateInitialFireballSmokeRing()
        self:ForkThread(self.CreateOuterRingWaveSmokeRing)
        --self:ForkThread(self.CreateHeadConvectionSpinners)
        --self:ForkThread(self.CreateFlavorPlumes)

        --WaitSeconds(0.55)
        coroutine.yield(6)
        CreateLightParticle(self, -1, self.Army, 300, 250, 'glow_03', 'ramp_nuke_04')
      
        -- Create ground decals
        local orientation = RandomFloat(0,2*math.pi)
        CreateDecal(position, orientation, 'Crater01_albedo', '', 'Albedo', 50, 50, 1200, 0, self.Army)
        CreateDecal(position, orientation, 'Crater01_normals', '', 'Normals', 50, 50, 1200, 0, self.Army)
        CreateDecal(position, orientation, 'nuke_scorch_003_albedo', '', 'Albedo', 60, 60, 1200, 0, self.Army)

        WaitSeconds(8.9)
        --coroutine.yield(90)
        self:CreateGroundPlumeConvectionEffects(self.Army)
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
            local proj = self:CreateProjectile('/effects/EMPFluxWarhead/EMPFluxWarheadEffect01_proj.bp')
                :SetVelocity(velocity)
            table.insert(projectiles, proj)
        end

        WaitSeconds(3)
        --coroutine.yield(30)
        -- Slow projectiles down to normal speed
        for k, v in projectiles do
            v:SetAcceleration(-0.45)
        end
    end,


    CreateGroundPlumeConvectionEffects = function(self,army)
        CreateEmitterAtEntity(self, army, '/mods/SCTA-master/effects/emitters/EMPBOOM_emit.bp'):ScaleEmitter(10)

        local sides = 10
        local angle = (2*math.pi) / sides
        local inner_lower_limit = 2
        local outer_lower_limit = 2
        local outer_upper_limit = 2

        local inner_lower_height = 1
        local inner_upper_height = 3
        local outer_lower_height = 2
        local outer_upper_height = 3

        sides = 8
        angle = (2*math.pi) / sides
        for i = 0, (sides-1) do
            local magnitude = RandomFloat(outer_lower_limit, outer_upper_limit)
            local x = math.sin(i*angle+RandomFloat(-angle/2, angle/4)) * magnitude
            local z = math.cos(i*angle+RandomFloat(-angle/2, angle/4)) * magnitude
            local velocity = RandomFloat(1, 3) * 3
            self:CreateProjectile('/effects/entities/UEFNukeEffect05/UEFNukeEffect05_proj.bp', x, RandomFloat(outer_lower_height, outer_upper_height), z, x, 0, z)
                :SetVelocity(x * velocity, 0, z * velocity)
        end
    end,
}

TypeClass = TANuke01
