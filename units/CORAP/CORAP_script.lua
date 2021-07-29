#CORE Aircraft Plant - Produces Aircraft
#CORAP
#
#Script created by Raevn

local TAFactory = import('/mods/SCTA-master/lua/TAFactory.lua').TAFactory

CORAP = Class(TAFactory) {
	OnStopBeingBuilt = function(self,builder,layer)
		TAFactory.OnStopBeingBuilt(self,builder,layer)
		self.Trash:Add(CreateRotator(self, 'dish', 'y', nil, 150, 0, 0))
	end,

}

TypeClass = CORAP