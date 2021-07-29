#CORE Metal Maker - Converts Energy into Metal
#CORMAKR
#
#Script created by Raevn
local TAStructure = import('/mods/SCTA-master/lua/TAStructure.lua').TAStructure

CORMAKR = Class(TAStructure) {

	OnCreate = function(self)
		TAStructure.OnCreate(self)
		self.Sliders = {
			chassis = CreateSlider(self, 0),
			plug = CreateRotator(self, 'plug', 'z', nil, 0, 0, 0),
		}
		for k, v in self.Sliders do
			self.Trash:Add(v)
		end
	end,

	OnStopBeingBuilt = function(self,builder,layer)
		TAStructure.OnStopBeingBuilt(self,builder,layer)
		self:DisableIntel('RadarStealth')
	end,

	OnLayerChange = function(self, new, old)
		TAStructure.OnLayerChange(self, new, old)
		if new == 'Water' then
			self.bp = self:GetBlueprint()
			self.scale = 0.5
			self.Water = true
		end
	end,

	OnProductionUnpaused = function(self)
		self:PlayUnitSound('Activate')	
		TAStructure.OnProductionUnpaused(self)
		if self.Water then
			self.Sliders.chassis:SetSpeed(10)
			self.Sliders.chassis:SetGoal(0,0,0)
			self:SetCollisionShape( 'Box', self.bp.CollisionOffsetX or 0,(self.bp.CollisionOffsetY + (self.bp.SizeY*0.5)) or 0,self.bp.CollisionOffsetZ or 0, self.bp.SizeX * self.scale, self.bp.SizeY * self.scale, self.bp.SizeZ * self.scale )
			self:DisableIntel('RadarStealth')
		end
		self.Sliders.plug:SetGoal(0)
		self.Sliders.plug:SetSpeed(60)
	end,

	OnProductionPaused = function(self)	
		self:PlayUnitSound('Deactivate')
		TAStructure.OnProductionPaused(self)
		--TURN plug to z-axis <0> SPEED <50.01>
		if self.Water then
			self.Sliders.chassis:SetSpeed(10)
			self.Sliders.chassis:SetGoal(0,-10,0)
			self:SetCollisionShape( 'Box', self.bp.CollisionOffsetX or -5,(self.bp.CollisionOffsetY + (self.bp.SizeY*-0.25)) or 0,self.bp.CollisionOffsetZ or -5, self.bp.SizeX * self.scale, self.bp.SizeY * self.scale, self.bp.SizeZ * self.scale )
			self:EnableIntel('RadarStealth')
		end
		self.Sliders.plug:SetGoal(180)
		self.Sliders.plug:SetSpeed(60)
	end,
}

TypeClass = CORMAKR