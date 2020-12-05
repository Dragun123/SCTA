local Unit = import('/lua/sim/Unit.lua').Unit
local explosion = import('/lua/defaultexplosions.lua')
local scenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')
local Game = import('/lua/game.lua')
local TAunit = import('/mods/SCTA-master/lua/TAunit.lua').TAunit
local util = import('/lua/utilities.lua')

local SyncroniseThread = function(self, interval, event, data)
    local time = GetGameTick()
    local wait = interval - math.mod(time,interval) + 1
    WaitTicks(wait)
    while true do
        event(data)
        WaitTicks(interval + 1)
    end
end

local GetEstimateMapWaterRatioFromGrid = function(grid)
    --aibrain:GetMapWaterRatio()
    if not grid then grid = 4 end
    local totalgrids = grid * grid
    local watergrids = 0
    local size = {
        ScenarioInfo.size[1] / (grid + 1),
        ScenarioInfo.size[2] / (grid + 1)
    }
    for x = 1, grid do
        for y = 1, grid do
            local coord = {x * size[1], y * size[2]}
            if GetSurfaceHeight(unpack(coord)) > GetTerrainHeight(unpack(coord)) then
                watergrids = watergrids + 1
            end
        end
    end
    return watergrids / totalgrids
end

--------------------------------------------------------------------------------
local TidalEnergyMin = false
local TidalEnergyRange = false

TATidal = Class(TAunit) 
{
        OnStopBeingBuilt = function(self,builder,layer)
        TAunit.OnStopBeingBuilt(self,builder,layer)
        ------------------------------------------------------------------------
        -- Pre-setup
        ------------------------------------------------------------------------
        self:SetProductionPerSecondEnergy(0)
        ------------------------------------------------------------------------
        -- Calculate energy values
        ------------------------------------------------------------------------
        if not TidalEnergyMin and not TidalEnergyRange then
            LOG("Defining tidal generator energy output value range.")
            --------------------------------------------------------------------
            -- Check check values to make sure another mod didn't change them
            --------------------------------------------------------------------
            local bp = self:GetBlueprint().Economy
            local mean = bp.ProductionPerSecondEnergy or 30
            local min = bp.ProductionPerSecondEnergyMin or 25
            local max = bp.ProductionPerSecondEnergyMax or 35
            local range = max - min
            if (min + max) / 2 ~= mean then
                local mult = mean / 25
                min = min * mult
                max = max * mult
                range = range * mult
            end
            --------------------------------------------------------------------
            -- Get two indpendant variables of map wetness
            --------------------------------------------------------------------
            local wR1 = GetEstimateMapWaterRatioFromGrid(4)
            local wR2 = self:GetAIBrain():GetMapWaterRatio()
            --------------------------------------------------------------------
            -- Calculate the actual range base on them
            --------------------------------------------------------------------
            TidalEnergyMin = min + (range * math.min(wR1,wR2))
            TidalEnergyRange = min + (range * math.max(wR1,wR2)) - TidalEnergyMin
            LOG("Map tidal strength defined as: " .. TidalEnergyMin .. "–" .. TidalEnergyMin + TidalEnergyRange)
        end
        ------------------------------------------------------------------------
        -- Run the thread
        ------------------------------------------------------------------------
        self:SetProductionPerSecondEnergy(TidalEnergyMin)
        if TidalEnergyRange >= 0.1 then
            self:ForkThread(SyncroniseThread,60,self.OnWeatherInterval,self)
        end
    end,

    OnWeatherInterval = function(self)
        local power = TidalEnergyMin + ((math.sin(GetGameTimeSeconds()) + 1) * TidalEnergyRange * 0.5)
        self:SetProductionPerSecondEnergy( power )
    end,

    OnKilled = function(self, instigator, type, overKillRatio)
        TAunit.OnKilled(self, instigator, type, overKillRatio)
    end,
}

-----------------------

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
    ---LOG('Wind Being Ran')
   self:SetProductionPerSecondEnergy (
       (WindEnergyMin + WindEnergyRange * ScenarioInfo.WindStats.Power)
   )
end,

        OnKilled = function(self, instigator, type, overKillRatio)
           TAunit.OnKilled(self, instigator, type, overKillRatio)
        end,
    }