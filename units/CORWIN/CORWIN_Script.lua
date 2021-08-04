#CORE Wind Generator - Produces Energy
#CORWIN
#
#Script created by Raevn

local TAWin = import('/mods/SCTA-master/lua/TAWeather.lua').TAWin

CORWIN = Class(TAWin) {
	OnCreate = function(self)
		TAWin.OnCreate(self)
		self.Spinners = {
		   --CreateRotator(Win, bone, axis, [goal], [speed], [accel], [goalspeed])
		   blades = CreateRotator(self, 'Rotor', 'z', nil, 0, 0, 0),
		   post = CreateRotator(self, 'Tower', 'z', nil, 0, 0, 0),
	   }
	   self.Trash:Add(self.Spinners.blades)
	   self.Trash:Add(self.Spinners.post)
	end,
}

TypeClass = CORWIN