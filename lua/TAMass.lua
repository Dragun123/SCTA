local Unit = import('/lua/sim/Unit.lua').Unit
local explosion = import('/lua/defaultexplosions.lua')
local scenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')
local Game = import('/lua/game.lua')
local TAunit = import('/mods/SCTA-master/lua/TAunit.lua').TAunit
local util = import('/lua/utilities.lua')
local debrisCat = import('/mods/SCTA-master/lua/TAdebrisCategories.lua')



TAMass = Class(TAunit) 
{
    OnCreate = function(self)
        TAunit.OnCreate(self)
        local markers = scenarioUtils.GetMarkers()
        local unitPosition = self:GetPosition()

        for k, v in pairs(markers) do
            if(v.type == 'MASS') then
                local massPosition = v.position
                if( (massPosition[1] < unitPosition[1] + 1) and (massPosition[1] > unitPosition[1] - 1) and
                    (massPosition[2] < unitPosition[2] + 1) and (massPosition[2] > unitPosition[2] - 1) and
                    (massPosition[3] < unitPosition[3] + 1) and (massPosition[3] > unitPosition[3] - 1)) then
                    self:SetProductionPerSecondMass(self:GetProductionPerSecondMass() * (v.amount / 100))
                    break
                end
            end
        end
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        TAunit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionActive()
    end,


    OnStartBuild = function(self, unitbuilding, order)
        TAunit.OnStartBuild(self, unitbuilding, order)
        self:AddCommandCap('RULEUCC_Stop')
        local massConsumption = self:GetConsumptionPerSecondMass()
        local massProduction = self:GetProductionPerSecondMass()
        self.UpgradeWatcher = self:ForkThread(self.WatchUpgradeConsumption, massConsumption, massProduction)
    end,

    OnStopBuild = function(self, unitbuilding, order)
        TAunit.OnStopBuild(self, unitbuilding, order)
        self:RemoveCommandCap('RULEUCC_Stop')
        if self.UpgradeWatcher then
            KillThread(self.UpgradeWatcher)
            self:SetConsumptionPerSecondMass(0)
            self:SetProductionPerSecondMass(self:GetBlueprint().Economy.ProductionPerSecondMass or 0)                  
        end  
    end,

    WatchUpgradeConsumption = function(self, massConsumption, massProduction) 
        while true do 
            if not self:IsPaused() then 
                if self:GetResourceConsumed() != 1 then 
                    local aiBrain = self:GetAIBrain() 
                    if aiBrain and aiBrain:GetEconomyStored('ENERGY') <= 1 then 
                        self:SetProductionPerSecondMass(massProduction) 
                        self:SetConsumptionPerSecondMass(massConsumption) 
                    else 
                        if self:GetResourceConsumed() != 0 then 
                            self:SetConsumptionPerSecondMass(massConsumption) 
                            self:SetProductionPerSecondMass(massProduction / self:GetResourceConsumed()) 
                        else 
                            self:SetProductionPerSecondMass(0) 
                        end 
                    end                
                else 
                    self:SetConsumptionPerSecondMass(massConsumption) 
                    self:SetProductionPerSecondMass(massProduction) 
                end 
            else 
                self:SetProductionPerSecondMass(massProduction) 
            end 
            WaitSeconds(0.2) 
        end 
    end,  	
    
    OnPaused = function(self)
        TAunit.OnPaused(self)
	end,

	OnUnpaused = function(self)
	    TAunit.OnUnpaused(self)
	end,
	
    OnProductionPaused = function(self)
        TAunit.OnProductionPaused(self)
    end,

    OnProductionUnpaused = function(self)
        TAunit.OnProductionUnpaused(self)
    end,	
    }