local BaseGenericDebris = import('/lua/sim/DefaultProjectiles.lua').BaseGenericDebris
local EffectTemplates = import('/lua/EffectTemplates.lua')

ARMWIN_debris01 = Class(BaseGenericDebris) {
    FxImpactLand = EffectTemplates.GenericDebrisLandImpact01,
    FxTrails = {
	'/mods/SCTAFix/effects/emitters/debris_smoke_emit.bp',
	'/mods/SCTAFix/effects/emitters/debrisfire_smoke_emit.bp',
    },
}

TypeClass = ARMWIN_debris01

