local BaseGenericDebris = import('/lua/sim/DefaultProjectiles.lua').BaseGenericDebris
local EffectTemplates = import('/lua/EffectTemplates.lua')

ARMRAD_debris01 = Class(BaseGenericDebris) {
    FxImpactLand = EffectTemplates.GenericDebrisLandImpact01,
    FxTrails = {
	'/mods/SCTAFix/effects/emitters/debris_smoke_emit.bp',
	'/mods/SCTAFix/effects/emitters/debrisfire_smoke_emit.bp',
    },
}

TypeClass = ARMRAD_debris01

