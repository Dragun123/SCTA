#ARM Wind Generator - Produces Energy
#ARMWIN
#
#Script created by Raevn

local TAWin = import('/mods/SCTAFix/lua/TAWin.lua').TAWin

ARMWIN = Class(TAWin) {
	OnCreate = function(self,builder,layer)
		TAWin.OnCreate(self,builder,layer)
		self:SetProductionPerSecondEnergy(0)
		self.Spinners = {
		   --CreateRotator(Win, bone, axis, [goal], [speed], [accel], [goalspeed])
		   blades = CreateRotator(self, 'Blades', 'z', nil, 0, 0, 0),
		   post = CreateRotator(self, 'Turret', 'y', nil, 0, 0, 0),
	   }
	   	self.Trash:Add(self.Spinners.blades)
		self.Trash:Add(self.Spinners.post)
	end,

	OnStopBeingBuilt = function(self,builder,layer)
		TAWin.OnStopBeingBuilt(self,builder,layer)
		self.Spinners.post:SetSpeed(35)
		self.Spinners.blades:SetSpeed(50)
	end,
}

TypeClass = ARMWIN
