local oldCORASON = CORASON
local TAutils = import('/mods/SCTA/lua/TAutils.lua')

CORASON = Class(oldCORASON) {
	 OnStopBeingBuilt = function(self,builder,layer)
		oldCORASON.OnStopBeingBuilt(self,builder,layer)
		self:PlayUnitSound('Activate')
		TAutils.registerTargetingFacility(self:GetArmy())
	end,
}

TypeClass = CORASON