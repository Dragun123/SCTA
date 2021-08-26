#ARM Adv. Aircraft Plant - Produces Aircraft
#CORPLAT
#
#Script created by Raevn

local TASeaPlat = import('/mods/SCTA-master/lua/TAFactory.lua').TASeaPlat


CORPLAT = Class(TASeaPlat) {
    WaterRise = function(self)
			--self.Layer = 'Water'
			self.Chassis:SetSpeed(11)
			self.Chassis:SetGoal(0,-5,0)
			TASeaPlat.WaterRise(self)
		end,
	
		WaterFall = function(self)
			TASeaPlat.WaterFall(self)
			self.Chassis:SetSpeed(11)
			self.Chassis:SetGoal(0,-16,0)
	end,
}

TypeClass = CORPLAT