do
    local OldModBlueprints = ModBlueprints

    function ModBlueprints(all_blueprints)
        OldModBlueprints(all_blueprints)
        BlueprintMults(all_blueprints)
        GiveVet(all_blueprints.Unit)
    end

    function BlueprintMults(all_blueprints)
        -- #1 CB Change: Split Mults into tables and individual variables. Renamed variables to only loop through all_blueprints.Unit once. This reduces the number of checks later at Comment #3
        local Land_Mults = {
            Defense = {
                Health = 0.5,
                MaxHealth = 0.5,
            },
            Display = {
                UniformScale = 0.5,
            },
            Intel = {
                VisionRadius = 1.5, 
                WaterVisionRadius = 3,
            },
            Economy = {
                BuildCostEnergy = 0.3,
                BuildCostMass = 0.5,
                BuildTime = 0.13,
                BuildRate = 0.075,
                MaintenanceConsumptionPerSecondEnergy = 3,
            },
            Physics = {
                MaxSpeed = 1.2,
                TurnRate = 0.75,
            }
        }
        local Land_Singles = {
            LifeBarHeight = 0.3,
            LifeBarOffset = 0.3,
            LifeBarSize = 0.5,
             
            SelectionSizeX = 0.5,
            SelectionSizeZ = 0.5,
            SelectionThickness = 2.5,
            SizeX = 0.5,
            SizeY = 0.5,
            SizeZ = 0.5,
        }

        -- #4 Move naval and air unit declarations up here so you only iterate over all_blueprints.Unit once.
        local Naval_Mults = {
            Defense = {
                Health = 0.8,
                MaxHealth = 0.8,
            },
            Display = {
                UniformScale = 0.5,
            },
            Intel = {
                VisionRadius = 1.5, 
                WaterVisionRadius = 3,
                },
            Economy = {
                BuildCostEnergy = 0.3,
                BuildCostMass = 0.5,
                BuildTime = 0.13,
                BuildRate = 0.075,
                MaintenanceConsumptionPerSecondEnergy = 3,
            },
            Physics = {
                MaxSpeed = 0.75,
                TurnRate = 0.5,
            },
        }
        local Naval_Singles = {
            LifeBarHeight = 0.3,
            LifeBarSize = 0.5,
            SelectionSizeX = 0.5,
            SelectionSizeZ = 0.5,
            SizeX = 0.5,
            SizeY = 0.5,
            SizeZ = 0.5,
        }
        
        local Air_Mults = {
            Defense = {
                Health = 0.5,
                MaxHealth = 0.5,
            },
            Display = {
                UniformScale = 0.33,
            },
            Intel = {
                WaterVisionRadius = 3,
                },
            Economy = {
                BuildCostEnergy = 0.3,
                BuildCostMass = 0.5,
                BuildTime = 0.13,
                BuildRate = 0.04,
            },
            Physics = {
                FuelRechargeRate = 0.00001,
                FuelUseTime = 0.0012,
            },    
        }
        local Air_Singles = {
            LifeBarHeight = 0.3,
            LifeBarOffset = 0.5,
            LifeBarSize = 0.5,
            
            SelectionSizeX = 0.33,
            SelectionSizeZ = 0.33,
            SelectionThickness = 2,
        }
        local Struct_Mults = {
            Defense = {
                Health = 0.75,
                MaxHealth = 0.75,
            },
            Display = {
                UniformScale = 0.5,
            },
            Intel = {
                VisionRadius = 1.5, 
                WaterVisionRadius = 3,
                RadarRadius = 1.5,
                },
            Economy = {
                BuildCostEnergy = 0.3,
                BuildCostMass = 0.5,
                BuildTime = 0.05,
                BuildRate = 0.2,
                MaintenanceConsumptionPerSecondEnergy = 3,
            },
        }
        local Struct_Singles = {
            LifeBarHeight = 0.3,
            LifeBarOffset = 0.8,
            LifeBarSize = 0.75, 
            SelectionSizeX = 0.5,
            SelectionSizeZ = 0.5,
            SizeX = 0.5,
            SizeY = 0.5,
            SizeZ = 0.5,
        }
        
        local Proj_Mults = {
            Display = {
                UniformScale = 0.35,
            },
        }
        -- Currently empty
        local Proj_Singles = {

        }

        for id, bp in all_blueprints.Unit do
            if bp.Categories and table.find(bp.Categories, 'SUBMERSIBLE') and (table.find(bp.Categories, 'TECH1') or table.find(bp.Categories, 'TECH2') or table.find(bp.Categories, 'TECH3')) then
            if bp.Defense.ArmorType and type(bp.Defense.ArmorType) == 'string' then
                bp.Defense.ArmorType = 'Sub'
            end
        end
            -- #2 CB Change: Check ARM/CORE in its own IF statement, then do if/else on land/navy/air/struct
            if bp.Categories and table.find(bp.Categories, 'ARM') or table.find(bp.Categories, 'CORE') then
                if table.find(bp.Categories, 'STRUCTURE') then
                    UpdateStat(bp, Struct_Mults, Struct_Singles, 'STRUCTURE')
                elseif table.find(bp.Categories, 'MOBILE') then
                    -- #7 CB Change: "_" is a throwaway variable that I'm using to simplify this code. if the "UpdateStat" function returns true, then the others don't get run at all.
                    local _ = UpdateStat(bp, Land_Mults, Land_Singles, 'LAND') or UpdateStat(bp, Naval_Mults, Naval_Singles, 'NAVAL') or UpdateStat(bp, Air_Mults, Air_Singles, 'AIR')
                end
            end
        end

        for id, bp in all_blueprints.Projectile do
            if bp.Categories and (table.find(bp.Categories, 'ARM') or table.find(bp.Categories, 'CORE')) then 
                UpdateStat_NoCheck(bp, Proj_Mults, Proj_Singles)
            end
        end
    end


end



-- #5 CB Comment - create some functions to keep the code cleaner
function UpdateStat(bp, mults, singles, category)
    local found = table.find(bp.Categories, category)
    if found then
        UpdateStat_NoCheck(bp, mults, singles)
    end
    return found
end

function UpdateStat_NoCheck(bp, mults, singles)
    for group, gdata in mults do
        -- #3 CB Change: Removed this type check as it's garuanteed to be a table now. Split the "else" into a for loop for singles
        for stat, data in gdata do
            if bp[group] and bp[group][stat] then
                bp[group][stat] = bp[group][stat] * data
            end
        end
    end
    for group, gdata in singles do
        if bp[group] then
            bp[group] = bp[group] * gdata
        end
    end
end

function GiveVet(all_bps)
    for id, bp in all_bps do
        if bp.Weapon and bp.Categories then
            -- #9 CB Comment: we don't need to assign to 10 then reassign to 1-4. Only assign to 10 if there's not a match.
            local mul
            if table.find(bp.Categories, 'LEVEL1') then
                mul = 1
            elseif table.find(bp.Categories, 'LEVEL2') then
                mul = 2
            elseif table.find(bp.Categories, 'LEVEL3') then
                mul = 3
            elseif table.find(bp.Categories, 'LEVEL4') then
                mul = 4
            else
                mul = 10
            end
            -- #8 CB Comment: bp.Buffs.Regen won't exist if bp.Buffs doesn't, so don't double check it.
            if not bp.Buffs then
                bp.Buffs = {}
            elseif not bp.Buffs.Regen then
                bp.Buffs.Regen = {
                    Level1 = 1 * mul,
                    Level2 = 2 * mul,
                    Level3 = 3 * mul,
                    Level4 = 4 * mul,
                    Level5 = 5 * mul,
                }
            end
            if not bp.Veteran then
                bp.Veteran =  {
                    Level1 = 3 * mul,
                    Level2 = 6 * mul,
                    Level3 = 9 * mul,
                    Level4 = 12 * mul,
                    Level5 = 15 * mul,
                }
            end
        end
    end
end