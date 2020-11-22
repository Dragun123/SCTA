#ARM Moho Mine - Advanced Metal Extractor
#ARMMOHO
#
#Script created by Raevn

local TAMass = import('/mods/SCTA-master/lua/TAMass.lua').TAMass
local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')

ARMMASS = Class(TAMass) {
	OnCreate = function(self)
		TAMass.OnCreate(self)
		self:SetMaintenanceConsumptionActive()
		self.Spinners = {
			arms = CreateRotator(self, 'arms', 'y', nil, 0, 91, 0),
		}
		self.Trash:Add(self.Spinners.arms)
	end,

	CreateWreckage = function( self, overkillRatio )
		if self.onMetalSpot then
			TAMass.CreateWreckageProp(self, overkillRatio)
		---else
			---return nil
		end
	end,

	OnStopBeingBuilt = function(self, builder, layer)
		TAMass.OnStopBeingBuilt(self, builder, layer)
		local markers = ScenarioUtils.GetMarkers() 
		local unitPosition = self:GetPosition()  
		for k, v in pairs(markers) do 
			if(v.type == 'Mass') then 
                		local MassPosition = v.position 
                		if (MassPosition[1] < unitPosition[1] + 1) and (MassPosition[1] > unitPosition[1] - 1) then 
	                    		if (MassPosition[3] < unitPosition[3] + 1) and (MassPosition[3] > unitPosition[3] - 1) then
						self.onMetalSpot = true
	                    			break 
					end
	               		end 
            		end 
        	end		
		self:PlayUnitSound('Activate')
		self.Spinners.arms:SetTargetSpeed(self:GetProductionPerSecondMass() * 50)
	end,

	OnProductionPaused = function(self)
		TAMass.OnProductionPaused(self)
		self.Spinners.arms:SetAccel(182)
		self.Spinners.arms:SetTargetSpeed(0)
		self:SetMaintenanceConsumptionInactive()
		self:PlayUnitSound('Deactivate')
	end,

	OnProductionUnpaused = function(self)
		TAMass.OnProductionUnpaused(self)
		self.Spinners.arms:SetAccel(91)
		self.Spinners.arms:SetTargetSpeed(self:GetProductionPerSecondMass() * 50)
		self:SetMaintenanceConsumptionActive()
		self:PlayUnitSound('Activate')
	end,
}

TypeClass = ARMMASS