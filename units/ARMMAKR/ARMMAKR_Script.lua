#ARM Metal Maker - Converts Energy into Metal
#ARMMAKR
#
#Script created by Raevn

local TAStructure = import('/mods/SCTA-master/lua/TAStructure.lua').TAStructure

ARMMAKR = Class(TAStructure) {
	--[[OnCreate = function(self)
		TAStructure.OnCreate(self)
		self.AnimManip = CreateAnimator(self)
		self.Trash:Add(self.AnimManip)
	end,]]
----Thanks to Balth, need to look into a few other relavent units for code improvement later 

	OnLayerChange = function(self, new, old)
        TAStructure.OnLayerChange(self, new, old)
        if new == 'Water' then
            CreateAnimator(self):PlayAnim(self:GetBlueprint().Display.AnimationWater, false):SetRate(1)
        end
    end,

	OnStopBeingBuilt = function(self,builder,layer)
        TAStructure.OnStopBeingBuilt(self,builder,layer)
		self:PlayUnitSound('Activate')
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