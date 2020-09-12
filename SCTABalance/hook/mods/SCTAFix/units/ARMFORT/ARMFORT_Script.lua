local oldARMFORT = ARMFORT
ARMFORT = Class(oldARMFORT) {
    ShieldEffects = {
        ShieldEffects = {
            '/effects/emitters/terran_shield_generator_t2_01_emit.bp',
            '/effects/emitters/terran_shield_generator_t2_02_emit.bp',
            '/effects/emitters/terran_shield_generator_t2_03_emit.bp',
    },
    
    OnStopBeingBuilt = function(self,builder,layer)
        oldARMFORT.OnStopBeingBuilt(self,builder,layer)
		self.ShieldEffectsBag = {}
    end,
}

TypeClass = ARMFORT