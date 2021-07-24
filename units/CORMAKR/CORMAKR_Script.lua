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
		}
		self.Spinners = {
			plug = CreateRotator(self, 'plug', 'z', nil, 0, 0, 0),
		}
		for k, v in self.Sliders do
			self.Trash:Add(v)
		end
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
	end,

	OnStopBeingBuilt = function(self,builder,layer)
		TAStructure.OnStopBeingBuilt(self,builder,layer)
		self:DisableIntel('RadarStealth')
		if layer == 'Water' then
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
		self.Spinners.plug:SetGoal(0)
		self.Spinners.plug:SetSpeed(60)
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
		self.Spinners.plug:SetGoal(180)
		self.Spinners.plug:SetSpeed(60)
	end,
}

TypeClass = CORMAKR