#CORE Aircraft Plant - Produces Aircraft
#CORDAP
#
#Script created by Raevn

local TAFactory = import('/mods/SCTA-master/lua/TAFactory.lua').TAFactory

CORDAP = Class(TAFactory) {
	OnStopBeingBuilt = function(self,builder,layer)
		TAFactory.OnStopBeingBuilt(self,builder,layer)
		self.Trash:Add(CreateRotator(self, 'dish', 'y', nil, 150, 0, 0))
	end,
}

TypeClass = CORDAP