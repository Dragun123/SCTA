#ARM Metal Maker - Converts Energy into Metal
#ARMMAKR
#
#Script created by Raevn

local TAStructure = import('/mods/SCTA-master/lua/TAStructure.lua').TAStructure

ARMMAKR = Class(TAStructure) {

	OnCreate = function(self)
		TAStructure.OnCreate(self)
		self.AnimManip = CreateAnimator(self)
		self.Trash:Add(self.AnimManip)
	end,

    OnStopBeingBuilt = function(self,builder,layer)
        TAStructure.OnStopBeingBuilt(self,builder,layer)
		self:PlayUnitSound('Activate')
        if layer == 'Water' then
			self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationWater)
			self.AnimManip:SetRate(1 * (self:GetBlueprint().Display.AnimationWaterRate or 0.2))
		end
	end,

	OnProductionUnpaused = function(self)
		TAStructure.OnProductionUnpaused(self)
		self:PlayUnitSound('Activate')
	end,


	OnProductionPaused = function(self)
		TAStructure.OnProductionPaused(self)
		self:PlayUnitSound('Deactivate')		
	end,
}

TypeClass = ARMMAKR