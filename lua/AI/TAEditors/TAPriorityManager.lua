local Factory = import('/lua/editor/UnitCountBuildConditions.lua').HaveGreaterThanUnitsWithCategory
local PowerGeneration = import('/lua/editor/UnitCountBuildConditions.lua').HaveLessThanUnitsWithCategory
local Numbers = import('/lua/editor/UnitCountBuildConditions.lua').HaveUnitsWithCategoryAndAlliance
local MoreProduct = import('/lua/editor/UnitCountBuildConditions.lua').HaveGreaterThanUnitsInCategoryBeingBuilt
local LessProduct = import('/lua/editor/UnitCountBuildConditions.lua').HaveLessThanUnitsInCategoryBeingBuilt
local LessTime = import('/lua/editor/MiscBuildConditions.lua').LessThanGameTime
local RAIDAIR = (categories.armfig + categories.corveng + categories.GROUNDATTACK)
local RAIDER =  (categories.armpw + categories.corak + categories.armflash + categories.corgator + (categories.AMPHIBIOUS - categories.COMMAND))
local PLANT = (categories.FACTORY * categories.TECH1)
local LAB = (categories.FACTORY * categories.TECH2)
local PLATFORM = (categories.FACTORY * categories.TECH3)
local FUSION = ((categories.ENERGYPRODUCTION * (categories.TECH2 + categories.TECH3)) * categories.STRUCTURE)
local CLOAKREACT = (categories.ENERGYPRODUCTION * categories.TECH3 * categories.STRUCTURE)

AirCarrierExist = function(self, aiBrain)
    if Factory(aiBrain,  0, categories.NAVALCARRIER) then 
        return 200
    else
        return 0
    end
end

AirProduction = function(self, aiBrain)
    if Factory(aiBrain,  0, categories.GATE) then
        return 0
    elseif aiBrain.Labs > 4 then 
        return 10
    else
        return 105
    end
end

ScoutShipProduction = function(self, aiBrain)
    if Factory(aiBrain,  0, categories.NAVAL * categories.FACTORY) and PowerGeneration(aiBrain,  1, categories.GATE) then 
        return 110
    else
        return 0
    end
end


AssistProduction = function(self, aiBrain)
    if aiBrain.Plant > 10 then 
        return 100
    elseif aiBrain.Plant > 4 then 
        return 50
    else
        return 0
    end
end


---TECHUPPRoduction
NavalProduction = function(self, aiBrain)
    if (Numbers(aiBrain, true, 0, categories.NAVAL * categories.FACTORY, 'Enemy') and Factory(aiBrain,  0, categories.NAVAL * categories.FACTORY)) or Numbers(aiBrain, true, 0, categories.NAVAL * categories.MOBILE, 'Enemy') then
        return 125
    else
        return 0
    end
end

NavalProductionT2 = function(self, aiBrain)
    if (Numbers(aiBrain, true, 0, categories.NAVAL * categories.FACTORY, 'Enemy') and Factory(aiBrain,  0, categories.NAVAL * LAB)) or Numbers(aiBrain, true, 0, categories.NAVAL * categories.MOBILE, 'Enemy') then
        return 160
    else
        return 0
    end
end

StructureProductionT2 = function(self, aiBrain)
    if aiBrain.Labs > 0  then 
        return 120
    elseif Factory(aiBrain,  0, categories.STRUCTURE * categories.TECH2) then
        return 10
    else
        return 0
    end
end

StructureProductionT2Energy = function(self, aiBrain)
    if aiBrain.Labs > 2 and PowerGeneration(aiBrain,  2, CLOAKREACT) then 
        return 150
    elseif aiBrain.Plant > 10  and PowerGeneration(aiBrain,  2, CLOAKREACT) then
        return 100
    else
        return 0
    end
end

ProductionT3Air = function(self, aiBrain)
    if Factory(aiBrain,  0, categories.GATE) and Factory(aiBrain,  0, CLOAKREACT) then
        return 125
    elseif Factory(aiBrain,  0, PLATFORM) and Factory(aiBrain,  0, CLOAKREACT) then
        return 105
    elseif aiBrain.Labs > 4 and Factory(aiBrain,  4, FUSION) then 
        return 100
    else
        return 0
    end
end

FactoryReclaim = function(self, aiBrain)
    if Factory(aiBrain,  1, PLATFORM) then
        return 200
    elseif aiBrain.Labs > 2 then 
        return 150
    elseif aiBrain.Plants > 10 then 
        return 10
    else
        return 0
    end
end





---WithinTechProduction








----TECH1 PRODUCTION


ProductionT3 = function(self, aiBrain)
    if Factory(aiBrain,  0, categories.GATE) then
        return 125
    elseif Factory(aiBrain,  0, PLATFORM) then
        return 105    
    elseif aiBrain.Labs > 4 then
        return 100
    else
        return 0
    end
end

UnitProduction = function(self, aiBrain)
    if Factory(aiBrain,  1, PLATFORM) then
        return 80
    elseif aiBrain.Labs > 0 then
        return 125
    elseif aiBrain.Plants > 10 then 
        return 110
    else
        return 0
    end
end

UnitProductionT1 = function(self, aiBrain)
    if Factory(aiBrain,  0, categories.GATE) then
          return 0
    elseif aiBrain.Labs > 2 then
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


HighTechEnergyProduction = function(self, aiBrain)
    if Factory(aiBrain,  2, FUSION) then 
        return 0
    else
        return 80
    end
end


----GANTRYSPECIFIC




GateBeingBuilt = function(self, aiBrain)
    if MoreProduct(aiBrain,  0, categories.GATE) then 
        return 125
    else
        return 0
    end
end


--ENERGYMIDTECH

NothingBuilt = function(self, aiBrain)
    if MoreProduct(aiBrain,  0, FUSION) then 
        return 200
    else
        return 0
    end
end

GantryUnitBuilding = function(self, aiBrain)
    if LessProduct(aiBrain,  1, categories.EXPERIMENTAL * categories.MOBILE) and Factory(aiBrain,  0, categories.GATE) then 
        return 200
    else
        return 0
    end
end

TechEnergyExist = function(self, aiBrain)
    if Factory(aiBrain,  1, FUSION) then 
        return 125
    else
        return 0
    end
end

GantryConstruction = function(self, aiBrain)
    if Factory(aiBrain,  1, PLATFORM) and Factory(aiBrain,  2, FUSION) then
        return 150
    elseif aiBrain.Labs > 4 and Factory(aiBrain,  2, FUSION) then
        return 100
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

UnitProductionLab = function(self, aiBrain)
    if Factory(aiBrain,  0, RAIDER) then
        return 200
    else
        return 0
    end
end

GantryProduction = function(self, aiBrain)
    if Factory(aiBrain,  0, categories.GATE) then
        return 200
    else
        return 0
    end
end