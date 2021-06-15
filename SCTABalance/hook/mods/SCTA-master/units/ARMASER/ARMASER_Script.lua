local oldARMASER = ARMASER
ARMASER = Class(oldARMASER) { 
	OnStopBeingBuilt = function(self,builder,layer)
		oldARMASER.OnStopBeingBuilt(self,builder,layer)
		self:SetScriptBit('RULEUTC_CloakToggle', false)
		self:RequestRefreshUI()
        self.DelayedCloakThread = self:ForkThread(self.CloakDelayed)
    end,

    CloakDelayed = function(self)
        if not self.Dead then
            WaitSeconds(2)
            --self.IntelDisables['RadarStealth']['ToggleBit5'] = true
            self.IntelDisables['CloakField']['ToggleBit8'] = true
			--self:EnableUnitIntel('ToggleBit5', 'RadarStealth')
            self:EnableUnitIntel('ToggleBit8', 'CloakField')
        end
        KillThread(self.DelayedCloakThread)
        self.DelayedCloakThread = nil
    end,

    OnIntelEnabled = function(self)
        oldARMASER.OnIntelEnabled(self)
        --self:EnableUnitIntel('ToggleBit5', 'RadarStealth')
        self:EnableUnitIntel('ToggleBit8', 'CloakField')
    end,

    OnIntelDisabled = function(self)
        oldARMASER.OnIntelDisabled(self)
        --self:DisableUnitIntel('ToggleBit5', 'RadarStealth')
        self:DisableUnitIntel('ToggleBit8', 'CloakField')
    end,

}

TypeClass = ARMASER
