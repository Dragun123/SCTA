local oldCORASON = CORASON
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')

CORASON = Class(oldCORASON) {
	 OnStopBeingBuilt = function(self,builder,layer)
		oldCORASON.OnStopBeingBuilt(self,builder,layer)
		self:PlayUnitSound('Activate')
		TAutils.registerTargetingFacility(self:GetArmy())
	end,

	OnScriptBitSet = function(self, bit)
		if bit == 3 then
			self:PlayUnitSound('Deactivate')
			TAutils.unregisterTargetingFacility(self:GetArmy())
		end
		oldCORASON.OnScriptBitSet(self, bit)
	end,

	OnScriptBitClear = function(self, bit)
		if bit == 3 then
			self:PlayUnitSound('Activate')
			TAutils.registerTargetingFacility(self:GetArmy())
		end
		oldCORASON.OnScriptBitClear(self, bit)
	end,
}

TypeClass = CORASON