local TAAntiRocketProjectile = import('/mods/SCTA-master/lua/TAprojectiles.lua').TAAntiRocketProjectile
local Flare = import("/lua/defaultantiprojectile.lua").Flare
local EffectTemplate = import("/lua/effecttemplates.lua")
local FlareCategories = categories.TACTICAL + categories.MISSILE

-- upvalue scope for performance
local IsEnemy = IsEnemy
local EntityCategoryContains = EntityCategoryContains


CORMABM_WEAPON = Class(TAAntiRocketProjectile) 
{
    OnCreate = function(self)
        TAAntiRocketProjectile.OnCreate(self)
        self.RedirectedMissiles = 0

        -- missiles that hit the flare are immediately neutralized
        self:SetCollisionShape('Sphere', 0, 0, 0, 1.0)

        -- Create several flares of different sizes. A collision check is done when an entity enters the
        -- collision box of another entity. As long as the entity remains inside no additional checks
        -- are done. Therefore we create several flares of different sizes to catch missiles that are
        -- far out and close by.

        local flareSpecs = {
            Radius = 10,
            Owner = self,
            Category = "MISSILE TACTICAL",
        }

        local trash = self.Trash
        for k = 1, 3 do
            flareSpecs.Radius = 8 + k * 5
            trash:Add(Flare(flareSpecs))
        end
    end,

    OnDestroy = function(self)
        TAAntiRocketProjectile.OnDestroy(self)

        -- create a pretty flash depending on the number of missiles we redirected
        local redirectedMissiles = self.RedirectedMissiles
        if redirectedMissiles > 0 then
            CreateLightParticleIntel(self, -1, self.Army, redirectedMissiles, 5, 'glow_02', 'ramp_blue_22')
        end
    end,

    OnCollisionCheck = function(self, other)
        -- flat out destroy the tactical missile when we get in contact with it
        if EntityCategoryContains(FlareCategories, other) and
            IsEnemy(self.Army, other.Army)
        then
            -- destroy the other projectile
            Damage(self.Launcher, other:GetPosition(), other, 200, "Normal")
        end

        return true
    end,

    OnImpact = function(self, TargetType, targetEntity)
            TAAntiRocketProjectile.OnImpact(self, TargetType, targetEntity)
            if TargetType == 'Terrain' or TargetType == 'Water' or TargetType == 'Prop' then
                if self.Trash then
                    self.Trash:Destroy()
                end
                self:Destroy()
            end
        end,
}



TypeClass = CORMABM_WEAPON
