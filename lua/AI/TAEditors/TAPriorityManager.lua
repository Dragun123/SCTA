local Factory = import('/lua/editor/UnitCountBuildConditions.lua').HaveGreaterThanUnitsWithCategory
local PowerGeneration = import('/lua/editor/UnitCountBuildConditions.lua').HaveLessThanUnitsWithCategory
local Numbers = import('/lua/editor/UnitCountBuildConditions.lua').HaveUnitsWithCategoryAndAlliance
local MoreProduct = import('/lua/editor/UnitCountBuildConditions.lua').HaveGreaterThanUnitsInCategoryBeingBuilt
local LessProduct = import('/lua/editor/UnitCountBuildConditions.lua').HaveLessThanUnitsInCategoryBeingBuilt
local LessTime = import('/lua/editor/MiscBuildConditions.lua').LessThanGameTime
local Mass = import('/mods/SCTA-master/lua/AI/TAEditors/TAAIInstantConditions.lua').LessMassStorageMaxTA
local RAIDER = (categories.armpw + categories.corak + categories.armflash + categories.corgator)
local LAB = (categories.FACTORY * categories.TECH2)
local PLATFORM = (categories.FACTORY * categories.TECH3)
local FUSION = (categories.ENERGYPRODUCTION * categories.STRUCTURE * (categories.TECH2 + categories.TECH3))
local CLOAKREACT = (categories.ENERGYPRODUCTION * categories.TECH3 * categories.STRUCTURE)


AssistProduction = function(self, aiBrain)
    if aiBrain.Level2 then 
        return 100
    elseif aiBrain.Plants >= 4 then 
        return 50
    else
        return 0
    end
end


---TECHUPPRoduction


StructureProductionT2 = function(self, aiBrain)
    if aiBrain.Level2 then 
        return 120
    elseif Factory(aiBrain,  0, categories.STRUCTURE * categories.TECH2) then
        return 10
    else
        return 0
    end
end

StructureProductionT2Energy = function(self, aiBrain)
    if aiBrain.Labs >= 2 and PowerGeneration(aiBrain,  2, CLOAKREACT) then 
        return 150
    elseif aiBrain.Level2 and PowerGeneration(aiBrain,  2, CLOAKREACT) then
        return 100
    else
        return 0
    end
end

GantryConstruction = function(self, aiBrain)
    if Factory(aiBrain,  1, PLATFORM) and Factory(aiBrain,  2, FUSION) then
        return 200
    elseif aiBrain.Level3 and Factory(aiBrain,  2, FUSION) then
        return 100
    else
        return 0
    end
end

FactoryReclaim = function(self, aiBrain)
    if Factory(aiBrain,  1, PLATFORM) then
        return 200
    elseif aiBrain.Labs >= 2 then 
        return 150
    elseif aiBrain.Level2 then 
        return 10
    else
        return 0
    end
end


----NAVY PRODUCTION
NavalProduction = function(self, aiBrain)
    if Numbers(aiBrain, true, 0, categories.NAVAL * (categories.FACTORY + categories.MOBILE), 'Enemy') and aiBrain.TANavy then
        return 125
    else
        return 0
    end
end


ScoutShipProduction = function(self, aiBrain)
    if aiBrain.TANavy and PowerGeneration(aiBrain,  1, categories.GATE) then 
        return 110
    else
        return 0
    end
end

NavalProductionT2 = function(self, aiBrain)
    if aiBrain.TANavy and aiBrain.Labs >= 2 and Numbers(aiBrain, true, 0, categories.NAVAL * (categories.FACTORY + categories.MOBILE), 'Enemy') then
        return 160
    else
        return 0
    end
end



--AIR Production

AirProduction = function(self, aiBrain)
    if Factory(aiBrain,  0, categories.GATE) then
        return 0
    elseif aiBrain.Level3 then 
        return 10
    else
        return 105
    end
end

ProductionT3Air = function(self, aiBrain)
    if Factory(aiBrain,  0, categories.GATE) and Factory(aiBrain,  0, CLOAKREACT) then
        return 140
    elseif Factory(aiBrain,  0, PLATFORM) and Factory(aiBrain,  0, CLOAKREACT) then
        return 130
    elseif aiBrain.Level3 and Factory(aiBrain,  2, FUSION) then 
        return 125
    else
        return 0
    end
end

---LAND/Generic

UnitProductionT1 = function(self, aiBrain)
    if Factory(aiBrain,  0, categories.GATE) then
          return 0
    elseif aiBrain.Labs >= 2 then
              return 5
    elseif Factory(aiBrain,  0, categories.STRUCTURE * categories.TECH2) then 
              return 50
      else
          return 100
      end
  end

  UnitProductionT1Fac = function(self, aiBrain)
    if aiBrain.Labs > 0 then
              return 0
    elseif Factory(aiBrain,  0, categories.STRUCTURE * categories.TECH2) then 
              return 50
      else
          return 100
      end
  end

  UnitProduction = function(self, aiBrain)
    if Factory(aiBrain,  1, PLATFORM) then
        return 80
    elseif aiBrain.Level2 then 
        return 125
    else
        return 0
    end
end

ProductionT3 = function(self, aiBrain)
    if Factory(aiBrain,  0, categories.GATE) then
        return 140
    elseif Factory(aiBrain,  0, PLATFORM) then
        return 125    
    elseif aiBrain.Level3 then
        return 120
    else
        return 0
    end
end


---ENERGY

HighTechEnergyProduction = function(self, aiBrain)
    if Factory(aiBrain,  2, FUSION) then 
        return 0
    else
        return 80
    end
end

TechEnergyExist = function(self, aiBrain)
    if Factory(aiBrain,  1, FUSION) then 
        return 125
    else
        return 0
    end
end

----IEXIST

AirCarrierExist = function(self, aiBrain)
    if Factory(aiBrain,  0, categories.NAVALCARRIER) then 
        return 200
    else
        return 0
    end
end


UnitProductionField = function(self, aiBrain)
    if Factory(aiBrain,  0, categories.FIELDENGINEER) then
        return 200
    else
        return 0
    end
end

----GANTRYSPECIFIC


GantryProduction = function(self, aiBrain)
    if Factory(aiBrain,  0, categories.GATE) then
        return 200
    else
        return 0
    end
end

GateBeingBuilt = function(self, aiBrain)
    if MoreProduct(aiBrain,  0, categories.GATE) then 
        return 125
    else
        return 0
    end
end


--ENERGYMIDTECH


GantryUnitBuilding = function(self, aiBrain)
    if LessProduct(aiBrain,  1, categories.EXPERIMENTAL * categories.MOBILE) and Factory(aiBrain,  0, categories.GATE) then 
        return 200
    else
        return 0
    end
end

GantryUnitBuildingDecoy = function(self, aiBrain)
    if Factory(aiBrain,  0, categories.EXPERIMENTAL * categories.MOBILE) then 
        return 300
    else
        return 0
    end
end

TALowEco = function(self, aiBrain)
    if Mass(aiBrain,  0.2) then 
        return 110
    else
        return 0
    end
end

---Misc
----interesting the function doesn't work as intended 
--[[EarlyBO = function(self, aiBrain)
    if LessTime(aiBrain, 360) then
        return 1000
    else
        return 0
    end
end]]

