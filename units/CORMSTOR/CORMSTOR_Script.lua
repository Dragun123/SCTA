#CORE Metal Storage - Increases Metal Storage
#CORMSTOR
#
#Script created by Raevn

local TAStructure = import('/mods/SCTA-master/lua/TAStructure.lua').TAStructure

CORMSTOR = Class(TAStructure) {
    --[[OnStopBeingBuilt = function(self,builder,layer)
        TAStructure.OnStopBeingBuilt(self,builder,layer)
        self.Trash:Add(CreateStorageManip(self, 'A1', 'MASS', 0, 0, 0, 0, 0, 0.41))
    end,]]
}

TypeClass = CORMSTOR
