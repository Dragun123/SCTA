local oldARMASON = ARMASON
local TAutils = import('/mods/SCTAFix/lua/TAutils.lua')

ARMASON = Class(oldARMASON) {
	 OnStopBeingBuilt = function(self,builder,layer)
		oldARMASON.OnStopBeingBuilt(self,builder,layer)
		self:PlayUnitSound('Activate')
		TAutils.registerTargetingFacility(self:GetArmy())
	end,
}

TypeClass = ARMASON