local oldARMASON = ARMASON
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')

ARMASON = Class(oldARMASON) {
	 OnStopBeingBuilt = function(self,builder,layer)
		oldARMASON.OnStopBeingBuilt(self,builder,layer)
		self:PlayUnitSound('Activate')
		TAutils.registerTargetingFacility(self:GetArmy())
	end,

	OnScriptBitSet = function(self, bit)
		if bit == 3 then
			self:PlayUnitSound('Deactivate')
			TAutils.unregisterTargetingFacility(self:GetArmy())
		end
		oldARMASON.OnScriptBitSet(self, bit)
	end,

	OnScriptBitClear = function(self, bit)
		if bit == 3 then
			self:PlayUnitSound('Activate')
			TAutils.registerTargetingFacility(self:GetArmy())
		end
		oldARMASON.OnScriptBitClear(self, bit)
	end,
}

TypeClass = ARMASON