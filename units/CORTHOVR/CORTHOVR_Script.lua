#COR Snapper - Hovertank
#CORSNAP
#
#Script created by Raevn

local TATransportSea = import('/mods/SCTA-master/lua/TATransport.lua').TATransportSea

CORTHOVR = Class(TATransportSea) {
    OnCreate = function(self)
		TATransportSea.OnCreate(self)
		self.Spinners = {
			arm1 = CreateRotator(self, 'Crane1', 'y', nil, 0, 0, 0),
			arm2 = CreateRotator(self, 'Crane2', 'y', nil, 0, 0, 0),
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
	end,
    OnStopBeingBuilt = function(self,builder,layer)
        TATransportSea.OnStopBeingBuilt(self,builder,layer)
        self.Spinners.arm1:SetGoal(90)
		self.Spinners.arm1:SetSpeed(160.03)

		self.Spinners.arm2:SetGoal(90)
		self.Spinners.arm2:SetSpeed(160.03)
    end,
}

TypeClass = CORTHOVR

--[[]]