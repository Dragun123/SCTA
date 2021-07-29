#ARM Aircraft Plant - Produces Aircraft
#ARMAP
#
#Script created by Raevn

local TAFactory = import('/mods/SCTA-master/lua/TAFactory.lua').TAFactory

ARMAP = Class(TAFactory) {
	OnStopBeingBuilt = function(self,builder,layer)
		TAFactory.OnStopBeingBuilt(self,builder,layer)
		self.Trash:Add(CreateRotator(self, 'Radar', 'y', nil, 45, 0, 0))
	end,
}

TypeClass = ARMAP