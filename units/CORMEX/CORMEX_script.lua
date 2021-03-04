#CORE Metal Extractor - Extracts Metal
#CORMEX
#
#Script created by Raevn

local TAMass = import('/mods/SCTA-master/lua/TAStructure.lua').TAMass
local ScenarioUtils = import('/lua/sim/ScenarioUtilities.lua')

CORMEX = Class(TAMass) {
	OnCreate = function(self)
		TAMass.OnCreate(self)
		---self:SetMaintenanceConsumptionActive()
		self.Spinners = {
			arms = CreateRotator(self, 'arms', 'y', nil, 0, 91, 0),
		}
		self.Sliders = {
			stand = CreateSlider(self, 'stand'),
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
	end,

	CreateWreckage = function( self, overkillRatio )
		if not self.onMetalSpot then
			TAMass.CreateWreckageProp(self, overkillRatio)
		else
			return nil
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
	                    		if (massPosition[3] < unitPosition[3] + 1) and (massPosition[3] > unitPosition[3] - 1) then 
						self.onMetalSpot = true
	                    			break 
					end
	               		end 
            		end 
        	end		
		self:PlayUnitSound('Activate')
		ForkThread(self.StartSpin,self)
	end,

	OnProductionPaused = function(self)
		TAMass.OnProductionPaused(self)
		self:PlayUnitSound('Deactivate')
		ForkThread(self.StopSpin,self)
	end,

	OnProductionUnpaused = function(self)
		TAMass.OnProductionUnpaused(self)
		self:PlayUnitSound('Activate')
		ForkThread(self.StartSpin,self)
	end,

	StartSpin = function(self)
		self.Sliders.stand:SetGoal(0,6,0)
		self.Sliders.stand:SetSpeed(5)
		WaitFor(self.Sliders.stand)
		self.Spinners.arms:SetAccel(91)
		self.Spinners.arms:ClearGoal()
		self.Spinners.arms:SetTargetSpeed(self:GetProductionPerSecondMass() * 50)
	end,

	StopSpin = function(self)
		self.Spinners.arms:SetAccel(182)
		self.Spinners.arms:SetTargetSpeed(0)
		WaitFor(self.Spinners.arms)
		self.Spinners.arms:SetGoal(0)
		self.Spinners.arms:SetSpeed(35)
		WaitFor(self.Spinners.arms)
		self.Sliders.stand:SetGoal(0,0,0)
		self.Sliders.stand:SetSpeed(5)
	end,
}

TypeClass = CORMEX