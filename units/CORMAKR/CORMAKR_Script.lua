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
		self.Brain:AddEnabledEnergyExcessUnit(self)
		end,
	
		-- for auto fabricator behavior
		OnExcessEnergy = function(self)
			self:OnProductionUnpaused()
		end,
	
		-- for auto fabricator behavior
		OnNoExcessEnergy = function(self)
			self:OnProductionPaused()
		end,
	
	OnLayerChange = function(self, new, old)
		TAStructure.OnLayerChange(self, new, old)
			if new == 'Sub' then
			self.bp = self:GetBlueprint()
			self.scale = 0.5
			self.Water = true
			self:SetCollisionShape( 'Box', self.bp.CollisionOffsetX or -5,(self.bp.CollisionOffsetY + (self.bp.SizeY*-0.25)) or 0,self.bp.CollisionOffsetZ or -5, self.bp.SizeX * self.scale, self.bp.SizeY * self.scale, self.bp.SizeZ * self.scale )
			end
		end,
	
		OnDestroy = function(self)
			if self.GeneratorCollision then
			self.GeneratorCollision:Destroy()
			self.GeneratorCollision = nil
			end
			TAStructure.OnDestroy(self)
		end,

	OnProductionUnpaused = function(self)
		self:PlayUnitSound('Activate')	
		TAStructure.OnProductionUnpaused(self)
		if self.Water then
			self.Sliders.chassis:SetSpeed(10)
			self.Sliders.chassis:SetGoal(0,0,0)
			self:DisableIntel('RadarStealth')
			if not self.GeneratorCollision then
				local pos = self:GetPosition()
				self.GeneratorCollision = CreateUnitHPR('Falling',self:GetArmy(),pos[1],pos[2],pos[3],0,0,0)
            	self.GeneratorCollision:SetCollisionShape( 'Box', self.bp.CollisionOffsetX or 0,(self.bp.CollisionOffsetY + (self.bp.SizeY*0.5)) or 0,self.bp.CollisionOffsetZ or 0, self.bp.SizeX * self.scale, self.bp.SizeY * self.scale, self.bp.SizeZ * self.scale )
				self.GeneratorCollision.Parent = self
        	end
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
			self:EnableIntel('RadarStealth')
			if self.GeneratorCollision then
				---if the unit falls then the box is destroyed again
				self.GeneratorCollision:Destroy()
				self.GeneratorCollision = nil
			end
		end
		self.Sliders.plug:SetGoal(180)
		self.Sliders.plug:SetSpeed(60)
	end,
}

TypeClass = CORMAKR