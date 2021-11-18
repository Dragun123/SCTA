#ARM Adv. Aircraft Plant - Produces Aircraft
#ARMAAP
#
#Script created by Raevn

local TAFactory = import('/mods/SCTA-master/lua/TAFactory.lua').TAFactory

ARMAAP = Class(TAFactory) {
	OnStopBeingBuilt = function(self,builder,layer)
		TAFactory.OnStopBeingBuilt(self,builder,layer)
		self.Trash:Add(CreateRotator(self, 'radar', 'y', nil, 45, 0, 0))
		self.Trash:Add(CreateRotator(self, 'Nozzle_01', 'y', 15, 5, 0, 0))
		self.Trash:Add(CreateRotator(self, 'Nozzle_02', 'y', -15, 5, 0, 0))
	end,
}

TypeClass = ARMAAP