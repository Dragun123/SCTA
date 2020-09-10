local Unit = import('/lua/sim/Unit.lua').Unit
local explosion = import('/lua/defaultexplosions.lua')
local scenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local TAutils = import('/mods/SCTA/lua/TAutils.lua')
local Game = import('/lua/game.lua')
local TAunit = import('/mods/SCTA/lua/TAunit.lua').TAunit
local util = import('/lua/utilities.lua')
local debrisCat = import('/mods/SCTA/lua/TAdebrisCategories.lua')

local SyncroniseThread = function(self, interval, event, data)
    local time = GetGameTick()
    local wait = interval - math.mod(time,interval) + 1
    WaitTicks(wait)
    while true do
        event(data)
        WaitTicks(interval + 1)
    end
end

local WindEnergyMin = false
local WindEnergyRange = false

TAWin = Class(TAunit) 
{
    OnStopBeingBuilt = function(self,builder,layer)
    TAunit.OnStopBeingBuilt(self,builder,layer)
    self:SetProductionPerSecondEnergy(0)
    if not WindEnergyMin and not WindEnergyRange then
        LOG("Defining wind turbine energy output value range.")
        local bp = self:GetBlueprint().Economy
        local mean = bp.ProductionPerSecondEnergy or 17.5
        local min = bp.ProductionPerSecondEnergyMin or 5
        local max = bp.ProductionPerSecondEnergyMax or 30
        if (min + max) / 2 == mean then
            --Then nothing has messed with the numbers, or something messed with all of them.
            WindEnergyMin = min
            WindEnergyRange = max - min
        else
            --Something has messed with the numbers, and we should move to match.
            local mult = mean / 17.5
            WindEnergyMin = min * mult
            WindEnergyRange = (max - min) * mult
        end
    end
    ------------------------------------------------------------------------
    -- Run the thread
    ------------------------------------------------------------------------
    self:ForkThread(SyncroniseThread,30,self.OnWeatherInterval,self)
end,

OnWeatherInterval = function(self)
   self:SetProductionPerSecondEnergy (
       (WindEnergyMin + WindEnergyRange * ScenarioInfo.WindStats.Power)
   )
end,

        OnKilled = function(self, instigator, type, overKillRatio)
           TAunit.OnKilled(self, instigator, type, overKillRatio)
        end,
    }