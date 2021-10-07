#ARM Aircraft Plant - Produces Aircraft
#ARMDAP
#
#Script created by Raevn

local TAFactory = import('/mods/SCTA-master/lua/TAFactory.lua').TAFactory

ARMADAP = Class(TAFactory) {
	OnStopBeingBuilt = function(self,builder,layer)
		TAFactory.OnStopBeingBuilt(self,builder,layer)
		self.Trash:Add(CreateRotator(self, 'Radar', 'y', nil, 0, 45, 45))
	end,
}

TypeClass = ARMADAP