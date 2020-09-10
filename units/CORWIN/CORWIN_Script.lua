#CORE Wind Generator - Produces Energy
#CORWIN
#
#Script created by Raevn

local TAWin = import('/mods/SCTA/lua/TAWin.lua').TAWin

CORWIN = Class(TAWin) {
	OnCreate = function(self,builder,layer)
		TAWin.OnCreate(self,builder,layer)
		self:SetProductionPerSecondEnergy(0)
		self.Spinners = {
		   --CreateRotator(Win, bone, axis, [goal], [speed], [accel], [goalspeed])
		   fan = CreateRotator(self, 'fan', 'z', nil, 0, 0, 0),
		   cradle = CreateRotator(self, 'cradle', 'y', nil, 0, 0, 0),
	   }
	   	self.Trash:Add(self.Spinners.fan)
		self.Trash:Add(self.Spinners.cradle)
	end,

	OnStopBeingBuilt = function(self,builder,layer)
		TAWin.OnStopBeingBuilt(self,builder,layer)
		self.Spinners.cradle:SetSpeed(35)
		self.Spinners.fan:SetSpeed(50)
	end,
}

TypeClass = CORWIN