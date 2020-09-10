local BaseGenericDebris = import('/lua/sim/DefaultProjectiles.lua').BaseGenericDebris
local EffectTemplates = import('/lua/EffectTemplates.lua')

ARMSOLAR_debris = Class(BaseGenericDebris) {
    FxImpactLand = EffectTemplates.GenericDebrisLandImpact01,
    FxTrails = {
	'/mods/SCTAFix/effects/emitters/debris_smoke_emit.bp',
	'/mods/SCTAFix/effects/emitters/debrisfire_smoke_emit.bp',
    },
}

TypeClass = ARMSOLAR_debris

