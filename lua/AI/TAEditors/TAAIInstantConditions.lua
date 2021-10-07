local AIUtils = import('/lua/ai/AIUtilities.lua')
--local Util = import('utilities.lua')

function TAGetEngineerFaction(engineer)
    if EntityCategoryContains(categories.ARM, engineer) then
        return 'Arm'
    elseif EntityCategoryContains(categories.CORE, engineer) then
        return 'Core'
    else
        return false
    end
end

------AIUTILITIES FUNCTIONS (RNG, NUTCTACKER, and RECLAIM MY OWN)
function TANormalizeVector( v )

	if v.x then
		v = {v.x, v.y, v.z}
	end
	
    local length = math.sqrt( math.pow( v[1], 2 ) + math.pow( v[2], 2 ) + math.pow(v[3], 2 ) )
	
    if length > 0 then
        local invlength = 1 / length
        return Vector( v[1] * invlength, v[2] * invlength, v[3] * invlength )
    else
        return Vector( 0,0,0 )
    end
end

function TAGetDirectionVector( v1, v2 )
    return TANormalizeVector( Vector(v1[1] - v2[1], v1[2] - v2[2], v1[3] - v2[3]) )
end
-----locational things

function TAGetDirectionInDegrees( v1, v2 )
    local SCTAACOS = math.acos
    local PI = math.pi
    local vec = TAGetDirectionVector( v1, v2)
    
    if vec[1] >= 0 then
        return SCTAACOS(vec[3]) * (360/(PI*2))
    end
    
    return 360 - (SCTAACOS(vec[3]) * (360/(PI*2)))
end

function TAGetMOARadii(bool)
    -- Military area is slightly less than half the map size (10x10map) or maximal 200.
    local BaseMilitaryArea = math.max( ScenarioInfo.size[1]-50, ScenarioInfo.size[2]-50 ) / 2.2
    BaseMilitaryArea = math.max( 180, BaseMilitaryArea )
    -- DMZ is half the map. Mainly used for air formers
    local BaseDMZArea = math.max( ScenarioInfo.size[1]-40, ScenarioInfo.size[2]-40 ) / 2
    -- Restricted Area is half the BaseMilitaryArea. That's a little less than 1/4 of a 10x10 map
    local BaseRestrictedArea = BaseMilitaryArea / 2
    -- Make sure the Restricted Area is not smaller than 50 or greater than 100
    BaseRestrictedArea = math.max( 60, BaseRestrictedArea )
    BaseRestrictedArea = math.min( 120, BaseRestrictedArea )
    -- The rest of the map is enemy area
    local BaseEnemyArea = math.max( ScenarioInfo.size[1], ScenarioInfo.size[2] ) * 1.5
    -- "bool" is only true if called from "AIBuilders/Mobile Land.lua", so we only print this once.
    if bool then
        --LOG('* RNGAI: BaseRestrictedArea= '..math.floor( BaseRestrictedArea * 0.01953125 ) ..' Km - ('..BaseRestrictedArea..' units)' )
        --LOG('* RNGAI: BaseMilitaryArea= '..math.floor( BaseMilitaryArea * 0.01953125 )..' Km - ('..BaseMilitaryArea..' units)' )
        --LOG('* RNGAI: BaseDMZArea= '..math.floor( BaseDMZArea * 0.01953125 )..' Km - ('..BaseDMZArea..' units)' )
        --LOG('* RNGAI: BaseEnemyArea= '..math.floor( BaseEnemyArea * 0.01953125 )..' Km - ('..BaseEnemyArea..' units)' )
    end
    return BaseRestrictedArea, BaseMilitaryArea, BaseDMZArea, BaseEnemyArea
end

---TA Engis Engi Cannot Captur

function SCTAEngineerTryReclaimCaptureArea(aiBrain, eng, pos)
    if not pos then
        return false
    end
    local Reclaiming = false
    -- Check if enemy units are at location
    local checkUnits = aiBrain:GetUnitsAroundPoint( (categories.STRUCTURE + categories.MOBILE) - categories.AIR, pos, 10, 'Enemy')
    -- reclaim units near our building place.
    if checkUnits and not table.empty(checkUnits) then
        for num, unit in checkUnits do
            if unit.Dead or unit:BeenDestroyed() then
                continue
            end
            if not IsEnemy( aiBrain:GetArmyIndex(), unit:GetAIBrain():GetArmyIndex() ) then
                continue
            end
            if EntityCategoryContains(categories.COMMAND, eng) and unit:IsCapturable() then 
                -- reclaim if its a T1 mex and the engineer is a commander
                unit.CaptureInProgress = true
                IssueCapture({eng}, unit)
            else
                -- else reclaim
                unit.ReclaimInProgress = true
                IssueReclaim({eng}, unit)
            end
            Reclaiming = true
        end
    end
    -- reclaim rocks etc or we can't build mexes or hydros
    local Reclaimables = GetReclaimablesInRect(Rect(pos[1], pos[3], pos[1], pos[3]))
    if Reclaimables and not table.empty( Reclaimables ) then
        for k,v in Reclaimables do
            if v.MaxMassReclaim > 0 or v.MaxEnergyReclaim > 0 then
                IssueReclaim({eng}, v)
                Reclaiming = true
            end
        end
    end
    return Reclaiming
end

--TA Build Conditions

function TAAIEcoConditionEfficiency(aiBrain)
    local econEff = {}
    econEff.EnergyIncome = aiBrain:GetEconomyIncome('ENERGY')
    econEff.MassIncome = aiBrain:GetEconomyIncome('MASS')
    econEff.EnergyRequested = aiBrain:GetEconomyRequested('ENERGY')
    econEff.MassRequested = aiBrain:GetEconomyRequested('MASS')

    if aiBrain.EconomyMonitorThread then
        local econTime = aiBrain:GetEconomyOverTime()

        econEff.EnergyEfficiencyOverTime = math.min(econTime.EnergyIncome / econTime.EnergyRequested, 40)
        econEff.MassEfficiencyOverTime = math.min(econTime.MassIncome / econTime.MassRequested, 10)
    end

    return econEff
end

function EcoManagementTA(aiBrain, MassEfficiency, EnergyEfficiency)
    local econEff = TAAIEcoConditionEfficiency(aiBrain)
    if ((aiBrain:GetEconomyStored('MASS') >= 125) and (aiBrain:GetEconomyStored('ENERGY') >= 350)) then
        if ((econEff.MassEfficiencyOverTime >= MassEfficiency) and (econEff.EnergyEfficiencyOverTime >= EnergyEfficiency)) or
        ((aiBrain:GetEconomyStoredRatio('Mass').MassStorageRatio >= 0.5) and (aiBrain:GetEconomyStoredRatio('ENERGY').EnergyStorageRatio >= 0.5)) then
            return true
        else
            return false
        end
    else
    return false
    end
end

function LessMassStorageMaxTA(aiBrain, mStorageRatio)
    if (aiBrain:GetEconomyStoredRatio('MASS').MassStorageRatio <= mStorageRatio) then
        return true
    else
        return false
    end
end

function GreaterEnergyStorageMaxTA(aiBrain, eStorageRatio)
    if (aiBrain:GetEconomyStoredRatio('ENERGY').EnergyStorageRatio >= eStorageRatio) then
        return true
    else
    return false
    end
end


function GreaterTAStorageRatio(aiBrain, mStorageRatio, eStorageRatio)
    local econ = TAAIEcoConditionEfficiency(aiBrain)
    if ((econ.EnergyEfficiencyOverTime >= 0.9) and (econ.MassEfficiencyOverTime >= 0.5)) then
        if ((aiBrain:GetEconomyStoredRatio('ENERGY').EnergyStorageRatio >= eStorageRatio) and (aiBrain:GetEconomyStoredRatio('MASS').MassStorageRatio >= mStorageRatio)) then
            return true
        else
            return false
        end
    else
        return false
    end
end

function LessThanEconEnergyTAEfficiency(aiBrain, EnergyEfficiency)
    local econ = TAAIEcoConditionEfficiency(aiBrain)
    if (econ.EnergyEfficiencyOverTime <= EnergyEfficiency) and (econ.MassEfficiencyOverTime >= 0.5) then
        return true
    else
    return false
    end
end

function GreaterThanEconEnergyTAEfficiency(aiBrain, EnergyEfficiency)
    local econ = TAAIEcoConditionEfficiency(aiBrain)
    if (econ.EnergyEfficiencyOverTime >= EnergyEfficiency) and (econ.MassEfficiencyOverTime >= 0.5) then
        return true
    else
    return false
    end
end

function TARandomLocation(x,z, value)
	
	local Random = Random
	local r_value = value or 20

    local finalX = x + Random(-r_value, r_value)
	
	-- there is potential here for a hung loop if the random value cannot overcome the map boundary
    while finalX <= 0 or finalX >= ScenarioInfo.size[1] do
	
        finalX = x + Random(-r_value, r_value)
		
    end
	
    local finalZ = z + Random(-r_value, r_value)
	
    while finalZ <= 0 or finalZ >= ScenarioInfo.size[2] do
	
        finalZ = z + Random(-r_value, r_value)
		
    end
	
    local height = GetTerrainHeight( finalX, finalZ )
	
    if GetSurfaceHeight( finalX, finalZ ) > height then
	
        height = GetSurfaceHeight( finalX, finalZ )
		
    end
	
    return { finalX, height, finalZ }
end

function HaveGreaterThanUnitsInCategoryBeingBuiltSCTA(aiBrain, numunits, category)
    local unitsBuilding = aiBrain:GetListOfUnits(categories.CONSTRUCTION + categories.CQUEMOV, false)
    local numBuilding = 0
    for unitNum, unit in unitsBuilding do
        if not unit.Dead and (unit:IsUnitState('Building') or unit:IsUnitState('Upgrading')) then
            local buildingUnit = unit.UnitBeingBuilt
            if buildingUnit and not buildingUnit.Dead and EntityCategoryContains(category, buildingUnit) then
                numBuilding = numBuilding + 1
            end
        end
        if numunits < numBuilding then
            return true
        end
    end
    return false
end

--[[function TAUnfinishedUnits(aiBrain, locationType, category)
    local engineerManager = aiBrain.BuilderManagers[locationType].EngineerManager
    if not engineerManager then
        return false
    end
    local unfinished = aiBrain:GetUnitsAroundPoint(category, engineerManager:GetLocationCoords(), engineerManager.Radius, 'Ally')
    for num, unit in unfinished do
        donePercent = unit:GetFractionComplete()
        if donePercent < 1 and GetGuards(aiBrain, unit) < 2 then
            return true
        end
    end
    return false
end

function GetGuards(aiBrain, Unit)
    local engs = aiBrain:GetUnitsAroundPoint(categories.ENGINEER, Unit:GetPosition(), 10, 'Ally')
    local count = 0
    local UpgradesFrom = Unit:GetBlueprint().General.UpgradesFrom
    for k,v in engs do
        if v.UnitBeingBuilt == Unit then
            count = count + 1
        end
    end
    if UpgradesFrom and UpgradesFrom != 'none' then -- Used to filter out upgrading units
        local oldCat = ParseEntityCategory(UpgradesFrom)
        local oldUnit = aiBrain:GetUnitsAroundPoint(oldCat, Unit:GetPosition(), 0, 'Ally')
        if oldUnit then
            count = count + 1
        end
    end
    return count
end]]