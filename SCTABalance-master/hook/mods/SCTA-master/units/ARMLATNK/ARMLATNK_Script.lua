local oldARMLATNK = ARMLATNK
ARMLATNK = Class(oldARMLATNK) { 

	OnIntelDisabled = function(self)
		local bp = self:GetBlueprint()
		oldARMLATNK.OnIntelDisabled(self)
		--self.SetJammerBlips(0) 
	end,

	OnIntelEnabled = function(self)
		local bp = self:GetBlueprint()
		oldARMLATNK.OnIntelEnabled(self)
		---self.SetJammerBlips(bp.Intel.JammerBlips * 5)
	end,
}

TypeClass = ARMLATNK
