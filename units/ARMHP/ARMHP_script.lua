#ARM Hovercraft Platform - Builds Hovercraft
#ARMHP
#
#Script created by Raevn

local TASeaPlat = import('/mods/SCTA-master/lua/TAFactory.lua').TASeaPlat

ARMHP = Class(TASeaPlat) {
    Open = function(self)
			self.Chassis:SetSpeed(10)
			self.Chassis:SetGoal(0,0,0)
			self:DisableIntel('RadarStealth')
			TASeaPlat.WaterRise(self)
		end,
	
		WaterFall = function(self)
			TASeaPlat.WaterFall(self)
			self.Chassis:SetSpeed(10)
			self.Chassis:SetGoal(0,-10,0)
			--self:SetCollisionShape( 'Box', self.bp.CollisionOffsetX or -5,(self.bp.CollisionOffsetY + (self.bp.SizeY*-0.5)) or 0,self.bp.CollisionOffsetZ or -5, self.bp.SizeX * self.scale, self.bp.SizeY * self.scale, self.bp.SizeZ * self.scale )
			self:EnableIntel('RadarStealth')
	end,
}

TypeClass = ARMHP