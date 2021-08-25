#ARM Adv. Aircraft Plant - Produces Aircraft
#CORPLAT
#
#Script created by Raevn

local TASeaPlat = import('/mods/SCTA-master/lua/TAFactory.lua').TASeaPlat


CORPLAT = Class(TASeaPlat) {
    Open = function(self)
        if self.Water then
			--self.Layer = 'Water'
			self.Chassis:SetSpeed(11)
			self.Chassis:SetGoal(0,-5,0)
			self:SetCollisionShape( 'Box', self.bp.CollisionOffsetX or 0,(self.bp.CollisionOffsetY + (self.bp.SizeY*0.5)) or 0,self.bp.CollisionOffsetZ or 0, self.bp.SizeX * self.scale, self.bp.SizeY * self.scale, self.bp.SizeZ * self.scale )
			self:DisableIntel('RadarStealth')
		end
        TASeaPlat.Open(self)
    end,
	
	WaterFall = function(self)
		if self.Water then
			--self.Layer = 'Sub'
			self.Chassis:SetSpeed(11)
			self.Chassis:SetGoal(0,-16,0)
			self:SetCollisionShape( 'Box', self.bp.CollisionOffsetX or -5,(self.bp.CollisionOffsetY + (self.bp.SizeY*-0.5)) or 0,self.bp.CollisionOffsetZ or -5, self.bp.SizeX * self.scale, self.bp.SizeY * self.scale, self.bp.SizeZ * self.scale )
			self:EnableIntel('RadarStealth')
		end
	end,
}

TypeClass = CORPLAT