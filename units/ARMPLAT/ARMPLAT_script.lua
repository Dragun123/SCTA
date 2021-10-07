#ARM Adv. Aircraft Plant - Produces Aircraft
#ARMAAP
#
#Script created by Raevn

local TASeaPlat = import('/mods/SCTA-master/lua/TAFactory.lua').TASeaPlat


ARMPLAT = Class(TASeaPlat) {
    WaterRise = function(self)
			self.Chassis:SetSpeed(13)
			self.Chassis:SetGoal(0,0,0)
			--self:SetCollisionShape( 'Box', self.bp.CollisionOffsetX or 0,(self.bp.CollisionOffsetY + (self.bp.SizeY*0.5)) or 0,self.bp.CollisionOffsetZ or 0, self.bp.SizeX * self.scale, self.bp.SizeY * self.scale, self.bp.SizeZ * self.scale )
        TASeaPlat.WaterRise(self)
    end,

	WaterFall = function(self)
		TASeaPlat.WaterFall(self)
			self.Chassis:SetSpeed(13)
			self.Chassis:SetGoal(0,-13,0)
			--self:SetCollisionShape( 'Box', self.bp.CollisionOffsetX or -5,(self.bp.CollisionOffsetY + (self.bp.SizeY*-0.5)) or 0,self.bp.CollisionOffsetZ or -5, self.bp.SizeX * self.scale, self.bp.SizeY * self.scale, self.bp.SizeZ * self.scale )
	end,
}

TypeClass = ARMPLAT