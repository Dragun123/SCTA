local oldCORVOYR = CORVOYR
CORVOYR = Class(oldCORVOYR) { 
	OnStopBeingBuilt = function(self,builder,layer)
		oldCORVOYR.OnStopBeingBuilt(self,builder,layer)
		self:SetScriptBit('RULEUTC_CloakToggle', false)
		self:RequestRefreshUI()
        self.DelayedCloakThread = self:ForkThread(self.CloakDelayed)
    end,

    CloakDelayed = function(self)
        if not self.Dead then
            --WaitSeconds(2)
            coroutine.yield(21)
            self.IntelDisables['RadarStealth']['ToggleBit5'] = true
            self.IntelDisables['CloakField']['ToggleBit8'] = true
			self:EnableUnitIntel('ToggleBit5', 'RadarStealth')
            self:EnableUnitIntel('ToggleBit8', 'CloakField')
        end
        KillThread(self.DelayedCloakThread)
        self.DelayedCloakThread = nil
    end,

    OnIntelEnabled = function(self)
        oldCORVOYR.OnIntelEnabled(self)
        self:EnableUnitIntel('ToggleBit5', 'RadarStealth')
        self:EnableUnitIntel('ToggleBit8', 'CloakField')
    end,

    OnIntelDisabled = function(self)
        oldCORVOYR.OnIntelDisabled(self)
        self:DisableUnitIntel('ToggleBit5', 'RadarStealth')
        self:DisableUnitIntel('ToggleBit8', 'CloakField')
    end,

}

TypeClass = CORVOYR
