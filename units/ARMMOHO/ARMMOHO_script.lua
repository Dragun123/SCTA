#ARM Moho Mine - Advanced Metal Extractor
#ARMMOHO
#
#Script created by Raevn

local TAMass = import('/mods/SCTA-master/lua/TAunit.lua').TAMass
local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')

ARMMOHO = Class(TAMass) {

	OnCreate = function(self)
		TAMass.OnCreate(self)
		self.Spinners = {
			arms = CreateRotator(self, 'Blades', 'y', nil, 0, 91, 0),
		}
		self.Trash:Add(self.Spinners.arms)
	end,

	CreateWreckage = function( self, overkillRatio )
		if self.onMetalSpot then
			TAMass.CreateWreckage(self, overkillRatio)
		--else
			--return nil
		end
	end,

	OnStopBeingBuilt = function(self, builder, layer)
		TAMass.OnStopBeingBuilt(self, builder, layer)
		local markers = ScenarioUtils.GetMarkers() 
		local unitPosition = self:GetPosition()  
		for k, v in pairs(markers) do 
			if(v.type == 'Mass') then 
                		local massPosition = v.position 
                		if (massPosition[1] < unitPosition[1] + 1) and (massPosition[1] > unitPosition[1] - 1) then 
	                    		if (massPosition[2] < unitPosition[2] + 1) and (massPosition[2] > unitPosition[2] - 1) then 
		                    		if (massPosition[3] < unitPosition[3] + 1) and (massPosition[3] > unitPosition[3] - 1) then 
							self.onMetalSpot = true
		                    			break 
						end
					end
                		end 
            		end 
        	end	
		self:PlayUnitSound('Activate')	
		self.Spinners.arms:SetTargetSpeed(self:GetProductionPerSecondMass() * 17)
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
		self.Spinners.arms:SetTargetSpeed(self:GetProductionPerSecondMass() * 17)
		self:SetMaintenanceConsumptionActive()
		self:PlayUnitSound('Activate')
	end,
}

TypeClass = ARMMOHO