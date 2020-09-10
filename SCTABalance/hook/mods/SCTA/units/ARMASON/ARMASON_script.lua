local oldARMASON = ARMASON
local TAutils = import('/mods/SCTA/lua/TAutils.lua')

ARMASON = Class(oldARMASON) {
	 OnStopBeingBuilt = function(self,builder,layer)
		oldARMASON.OnStopBeingBuilt(self,builder,layer)
		self:PlayUnitSound('Activate')
		TAutils.registerTargetingFacility(self:GetArmy())
	end,
}

TypeClass = ARMASON