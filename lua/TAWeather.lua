local TAStructure = import('/mods/SCTA-master/lua/TAStructure.lua').TAStructure

local SyncroniseThread = function(self, interval, event, data)
    local time = GetGameTick()
    local wait = interval - math.mod(time,interval) + 1
    WaitTicks(wait)
    while true do
        event(data)
        WaitTicks(interval + 1)
    end
end



TAWeather = Class(TAStructure) 
{
OnKilled = function(self, instigator, type, overKillRatio)
    ---felt might be needed to do this to stop threads from staying after death 
    if self.ControlThread then
    KillThread(self.ControlThread)
    end
    TAStructure.OnKilled(self, instigator, type, overKillRatio)
end,

OnStopBeingBuilt = function(self,builder,layer)
    TAStructure.OnStopBeingBuilt(self,builder,layer)
    ------------------------------------------------------------------------
    -- Pre-setup
    ------------------------------------------------------------------------
    ---Both Tidals and Winds do this so creating shared function
    self:SetProductionPerSecondEnergy(0)
    --_ALERT(repr(self.Buffs))
end,
}
--------------------------------------------------------------------------------
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

TATidal = Class(TAWeather) 
{
        OnStopBeingBuilt = function(self,builder,layer)
        TAWeather.OnStopBeingBuilt(self,builder,layer)
        ------------------------------------------------------------------------
        -- Pre-setup
        ------------------------------------------------------------------------
        ------------------------------------------------------------------------
        -- Calculate energy values
        ------------------------------------------------------------------------
        if not TidalEnergyMin and not TidalEnergyRange then
            --LOG("Defining tidal generator energy output value range.")
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
            --LOG("Map tidal strength defined as: " .. TidalEnergyMin .. "–" .. TidalEnergyMin + TidalEnergyRange)
        end
        ------------------------------------------------------------------------
        -- Run the thread
        ------------------------------------------------------------------------
        self:SetProductionPerSecondEnergy(TidalEnergyMin *
        (self.EnergyProdAdjMod or 1))
        ---EnergyProdAdjMod is EnergyProductionAdjustModifier not EnergyProductionAdjacencyModifier 
        ---Not Having it here meant no benefits from cheat modifiers 
        ---->< Okay moving. Thankfully its an easish fix. Just So very angry at myself
        ---Got to make sure everything works correclty now.
        if TidalEnergyRange >= 0.1 then
            self.ControlThread = self:ForkThread(SyncroniseThread,60,self.OnWeatherInterval,self)
        end
    end,

    OnWeatherInterval = function(self)
        if not self.Dead then
        local power = TidalEnergyMin + ((math.sin(GetGameTimeSeconds()) + 1) * TidalEnergyRange * 0.5)
        --[[if self:GetAIBrain().CheatEnabled then
            self:SetProductionPerSecondEnergy ( power * tonumber(ScenarioInfo.Options.CheatMult))
        else]]
            self:SetProductionPerSecondEnergy( power *
            (self.EnergyProdAdjMod or 1) )
        --end 
        self.Spinners.wheel:SetSpeed(self:GetProductionPerSecondEnergy())
        end
    end,

}

-----------------------

local WindEnergyMin = false
local WindEnergyRange = false

TAWin = Class(TAWeather) 
{
    OnStopBeingBuilt = function(self,builder,layer)
        TAWeather.OnStopBeingBuilt(self,builder,layer)
        if not WindEnergyMin and not WindEnergyRange then
        --LOG("Defining wind turbine energy output value range.")
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
       self.ControlThread = self:ForkThread(SyncroniseThread,30,self.OnWeatherInterval,self)
    end,

    OnWeatherInterval = function(self)
    ---LOG('Wind Being Ran')
        if not self.Dead then
            --[[if self:GetAIBrain().CheatEnabled then
                ---This is brute forced method just checking if cheatmods enabled provided benefit
            self:SetProductionPerSecondEnergy (((WindEnergyMin + WindEnergyRange * ScenarioInfo.WindStats.Power) * tonumber(ScenarioInfo.Options.CheatMult)))
            else]]
                ----WHYISCHEATMODTIEDENERGYPRODADJ. 
            self:SetProductionPerSecondEnergy (
                (WindEnergyMin + WindEnergyRange * ScenarioInfo.WindStatsTA.Power) *
                (self.EnergyProdAdjMod or 1))
            --end
    ---local Wind = 
    ---LOG(Wind)
        self.Spinners.post:SetSpeed(self:GetProductionPerSecondEnergy())
        self.Spinners.blades:SetSpeed((self:GetProductionPerSecondEnergy()) * 2)
        end
    end,
    }