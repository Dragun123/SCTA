#COR Hovercraft Platform - Builds Hovercraft
#CORHP
#
#Script created by Raevn

local TASeaPlat = import('/mods/SCTA-master/lua/TAFactory.lua').TASeaPlat

CORHP = Class(TASeaPlat) {

	WaterFall = function(self)
		TASeaPlat.WaterFall(self)
			self.Chassis:SetSpeed(10)
			self.Chassis:SetGoal(0,-10,0)
			--self:SetCollisionShape( 'Box', self.bp.CollisionOffsetX or -5,(self.bp.CollisionOffsetY + (self.bp.SizeY*-0.5)) or 0,self.bp.CollisionOffsetZ or -5, self.bp.SizeX * self.scale, self.bp.SizeY * self.scale, self.bp.SizeZ * self.scale )
		end,
	
		WaterRise = function(self)
			TASeaPlat.WaterRise(self)
			self.Chassis:SetSpeed(10)
			self.Chassis:SetGoal(0,0,0)
			--self:SetCollisionShape( 'Box', self.bp.CollisionOffsetX or 0,(self.bp.CollisionOffsetY + (self.bp.SizeY*0.5)) or 0,self.bp.CollisionOffsetZ or 0, self.bp.SizeX * self.scale, self.bp.SizeY * self.scale, self.bp.SizeZ * self.scale )
	end,
}

TypeClass = CORHP