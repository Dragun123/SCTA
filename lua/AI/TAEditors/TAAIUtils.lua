local AIUtils = import('/lua/ai/AIUtilities.lua')
local AIAttackUtils = import('/lua/AI/aiattackutilities.lua')
local LessThanCats = import('/lua/editor/UnitCountBuildConditions.lua').HaveLessThanUnitsWithCategory

function HaveLessThanUnitsWithCategoryTA(aiBrain, numReq, category, idleReq)
    local Numbers
    if aiBrain.Level3 then 
        Numbers = 3
    elseif aiBrain.Level2 then
        Numbers = 2
    else 
        Numbers = 1
    end
    ---local NumbersVal = numReq * Numbers
    if LessThanCats(aiBrain,  numReq * Numbers, category, idleReq) then
        return true
    else
        return false
    end
end

function HaveLessThanUnitsWithCategoryTAMapSize(aiBrain, numReq, category, idleReq)
    local Numbers
    if aiBrain.MapSizeSCTA then 
        Numbers = (aiBrain.MapSizeSCTA)/2
    end
    ---local NumbersVal = numReq * Numbers
    if LessThanCats(aiBrain,  numReq + Numbers, category, idleReq) then
        return true
    else
        return false
    end
end
------AIUTILITIES FUNCTIONS (RNG, NUTCTACKER, and RECLAIM MY OW
function CheckBuildPlatoonDelaySCTA(aiBrain, PlatoonName)
    if aiBrain.DelayEqualBuildPlattons[PlatoonName] then
        --LOG('Delay Platoon Name exist' ..aiBrain.DelayEqualBuildPlattons[PlatoonName])
    end
    if aiBrain.DelayEqualBuildPlattons[PlatoonName] and aiBrain.DelayEqualBuildPlattons[PlatoonName] > GetGameTimeSeconds() then
        --LOG('Builder Delay false')
        return false
    end
   --LOG('Builder delay true')
    return true
end

function HaveUnitsInCategoryBeingUpgradeSCTA(aiBrain, numunits, category, compareType)
    -- get all units matching 'category'
    local unitsBuilding = aiBrain:GetListOfUnits(category, false)
    local numBuilding = 0
    -- own armyIndex
    local armyIndex = aiBrain:GetArmyIndex()
    -- loop over all units and search for upgrading units
    for unitNum, unit in unitsBuilding do
        if not unit.Dead and not unit:BeenDestroyed() and unit:IsUnitState('Upgrading') and unit:GetAIBrain():GetArmyIndex() == armyIndex then
            numBuilding = numBuilding + 1
        end
    end
    --LOG(aiBrain:GetArmyIndex()..' HaveUnitsInCategoryBeingUpgrade ( '..numBuilding..' '..compareType..' '..numunits..' ) --  return '..repr(CompareBody(numBuilding, numunits, compareType))..' ')
    return CompareBodySCTA(numBuilding, numunits, compareType)
end

function HaveLessThanUnitsInCategoryBeingUpgradeSCTA(aiBrain, numunits, category)
    return HaveUnitsInCategoryBeingUpgradeSCTA(aiBrain, numunits, category, '<')
end

function CompareBodySCTA(numOne, numTwo, compareType)
    if compareType == '>' then
        if numOne > numTwo then
            return true
        end
    elseif compareType == '<' then
        if numOne < numTwo then
            return true
        end
    elseif compareType == '>=' then
        if numOne >= numTwo then
            return true
        end
    elseif compareType == '<=' then
        if numOne <= numTwo then
            return true
        end
    else
       --error('*AI ERROR: Invalid compare type: ' .. compareType)
       return false
    end
    return false
end


function TAHavePoolUnitInArmy(aiBrain, unitCount, unitCategory, compareType)
    local poolPlatoon = aiBrain:GetPlatoonUniquelyNamed('ArmyPool')
    local numUnits = poolPlatoon:GetNumCategoryUnits(unitCategory)
    --LOG('* HavePoolUnitInArmy: numUnits= '..numUnits) 
    return CompareBodySCTA(numUnits, unitCount, compareType)
end

function TAHaveLessThanArmyPoolWithCategory(aiBrain, unitCount, unitCategory)
    return TAHavePoolUnitInArmy(aiBrain, unitCount, unitCategory, '<=')
end
function TAHaveGreaterThanArmyPoolWithCategory(aiBrain, unitCount, unitCategory)
    return TAHavePoolUnitInArmy(aiBrain, unitCount, unitCategory, '>=')
end

function TAFindUnfinishedUnits(aiBrain, locationType, buildCat)
    local engineerManager = aiBrain.BuilderManagers[locationType].EngineerManager
    local unfinished = aiBrain:GetUnitsAroundPoint(buildCat, engineerManager:GetLocationCoords(), engineerManager.Radius, 'Ally')
    local retUnfinished = false
    for num, unit in unfinished do
        donePercent = unit:GetFractionComplete()
        if donePercent < 1 and GetGuards(aiBrain, unit) < 1 and not unit:IsUnitState('Upgrading') then
            retUnfinished = unit
            break
        end
    end
    return retUnfinished
end
--TA Build Conditions

function TAAIGetEconomyNumbersStorageRatio(aiBrain)
    local econ = {}
    econ.MassStorageRatio = aiBrain:GetEconomyStoredRatio('MASS')
    econ.EnergyStorageRatio = aiBrain:GetEconomyStoredRatio('ENERGY')
    econ.EnergyStorage = aiBrain:GetEconomyStored('ENERGY')
    econ.MassStorage = aiBrain:GetEconomyStored('MASS')

    if econ.MassStorageRatio ~= 0 then
        econ.MassMaxStored = econ.MassStorage / econ.MassStorageRatio
    else
        econ.MassMaxStored = econ.MassStorage
    end

    if econ.EnergyStorageRatio ~= 0 then
        econ.EnergyMaxStored = econ.EnergyStorage / econ.EnergyStorageRatio
    else
        econ.EnergyMaxStored = econ.EnergyStorage
    end

    return econ
end


function GreaterThanStorageRatioTA(aiBrain, mStorageRatio, eStorageRatio)
    local econ = TAAIGetEconomyNumbersStorageRatio(aiBrain)
    if (econ.MassStorageRatio >= mStorageRatio and econ.EnergyStorageRatio >= eStorageRatio) then
        return true
    end
    return false
end

-----TAExpansion

function TAExpansionBaseCheck(aiBrain)
    -- Removed automatic setting of Land-Expasions-allowed. We have a Game-Option for this.
    local checkNum = tonumber(aiBrain.MapSizeSCTA/2)
    --LOG('*SCTAEXPANSIONTA', checkNum)
    return TAExpansionBaseCount(aiBrain, '<', checkNum)
end

function TAExpansionBaseCount(aiBrain, compareType, checkNum)
    local expBaseCount = aiBrain:GetManagerCount('Expansion Area')
        ---LOG('*SCTAEXPANSIONTA', expBaseCount)
       if expBaseCount > checkNum then
       end
       return CompareBodySCTA(expBaseCount, checkNum, compareType)
end

function TAStartBaseCheck(aiBrain)
    -- Removed automatic setting of Land-(ScenarioInfo.Options.LandExpansionsAllowed)/3 or 2Expasions-allowed. We have a Game-Option for this.
    local checkNum2 = tonumber(aiBrain.MapSizeSCTA)
    --LOG('*SCTAEXPANSIONTA2', checkNum2)
    return TAStartBaseCount(aiBrain, '<', checkNum2)
end

function TAStartBaseCount(aiBrain, compareType, checkNum2)
       local expBaseCount2 = aiBrain:GetManagerCount('Start Location')
       ----LOG('*SCTAEXPANSIONTA2', expBaseCount2)
       if expBaseCount2 > checkNum2 + 1 then
       end
       return CompareBodySCTA(expBaseCount2, checkNum2, compareType)
end

--[[function FormerBaseCheck(aiBrain)
    -- Removed automatic setting of Land-Expasions-allowed. We have a Game-Option for this.
    local checkNum = 5
    return StartBaseCount(aiBrain, '<', checkNum)
end

function FormerBaseCheck(aiBrain, compareType, checkNum)
       local expBaseCount = aiBrain:GetManagerCount('Mass')
       if expBaseCount > checkNum then
       end
       return CompareBodySCTA(expBaseCount, checkNum, compareType)
end]]

function TAHaveUnitsWithCategoryAndAllianceFalse(aiBrain, numReq, category, alliance)
    local numUnits = aiBrain:GetNumUnitsAroundPoint(category, Vector(0,0,0), 100000, alliance)
    if numUnits > numReq then
        return false
    else
    return true
    end
end

---TAUnit Building

function TAFactoryCapCheckT1Early(aiBrain)
    --LOG('*SCTALABs', aiBrain.Plants)
    if not aiBrain.Level2 then
        return true
    end
    return false
end

function TAFactoryCapCheckT1(aiBrain)
    --LOG('*SCTALABs', aiBrain.Plants)
    if aiBrain.Plants > 5 and not aiBrain.Level2 then
        return true
    end
    return false
end

function TAFactoryCapCheckT2Early(aiBrain)
    --LOG('*SCTALABs', aiBrain.Plants)
    if not aiBrain.Level3 then
        return true
    end
    return false
end

function TAFactoryCapCheckT2(aiBrain)
    --LOG('*SCTALABs', aiBrain.Plants)
    if aiBrain.Labs > 2 and not aiBrain.Level3 then
        return true
    end
    return false
end

function TAFactoryCapCheckT2Expansion(aiBrain)
    --LOG('*SCTALABs', aiBrain.Plants)
    if (aiBrain.Labs + (aiBrain:GetCurrentUnits(categories.TECH2 * categories.FACTORY) - aiBrain.Labs)) < (6 + aiBrain.MapSizeSCTA) and not aiBrain.CapCheckT2 then
        return true
    end
    aiBrain.CapCheckT2 = true
    return false
end

function TAHaveEnemyUnitAtLocation(aiBrain, radius, locationType, unitCount, categoryEnemy, compareType)
    if not aiBrain.BuilderManagers[locationType] then
        WARN('*AI WARNING: HaveEnemyUnitAtLocation - Invalid location - ' .. locationType)
        return false
    elseif not aiBrain.BuilderManagers[locationType].Position then
        WARN('*AI WARNING: HaveEnemyUnitAtLocation - Invalid position - ' .. locationType)
        return false
    end
    local numEnemyUnits = aiBrain:GetNumUnitsAroundPoint(categoryEnemy, aiBrain.BuilderManagers[locationType].Position, radius , 'Enemy')
    --LOG(aiBrain:GetArmyIndex()..' CompareBody {World} radius:['..radius..'] '..repr(DEBUG)..' ['..numEnemyUnits..'] '..compareType..' ['..unitCount..'] return '..repr(CompareBody(numEnemyUnits, unitCount, compareType)))
    return CompareBodySCTA(numEnemyUnits, unitCount, compareType)
end
--            { UCBC, 'EnemyUnitsGreaterAtLocationRadius', {  BasePanicZone, 'LocationType', 0, categories.MOBILE * categories.LAND }}, -- radius, LocationType, unitCount, categoryEnemy
function TAEnemyUnitsGreaterAtLocationRadius(aiBrain, radius, locationType, unitCount, categoryEnemy)
    return TAHaveEnemyUnitAtLocation(aiBrain, radius, locationType, unitCount, categoryEnemy, '>')
end
--            { UCBC, 'EnemyUnitsLessAtLocationRadius', {  BasePanicZone, 'LocationType', 1, categories.MOBILE * categories.LAND }}, -- radius, LocationType, unitCount, categoryEnemy
function TAEnemyUnitsLessAtLocationRadius(aiBrain, radius, locationType, unitCount, categoryEnemy)
    return TAHaveEnemyUnitAtLocation(aiBrain, radius, locationType, unitCount, categoryEnemy, '<')
end


function TAAttackNaval(aiBrain, bool)
    local startX, startZ = aiBrain:GetArmyStartPos()
    local enemyX, enemyZ
    if aiBrain:GetCurrentEnemy() then
        enemyX, enemyZ = aiBrain:GetCurrentEnemy():GetArmyStartPos()
    end
    local navalMarker = AIUtils.AIGetClosestMarkerLocation(aiBrain, 'Naval Area', startX, startZ)
    local path, reason = false
    if enemyX then
        path, reason = AIAttackUtils.PlatoonGenerateSafePathToSCTAAI(aiBrain, 'Water', {startX,0,startZ}, {enemyX,0,enemyZ}, 10)
    end
    if (navalMarker and path) and bool then
        return true
    end
    return false
end

function TAHaveUnitRatioGreaterThanLand(aiBrain, Land)
    local numOne = aiBrain:GetCurrentUnits((Land) * categories.LAND * categories.MOBILE - categories.ENGINEER)
    local numTwo = aiBrain:GetCurrentUnits(categories.LAND * categories.MOBILE - categories.ENGINEER)
    if ((numOne + 1) / (numTwo + 1)) < 0.15 then
        return true
    else
        return false
    end
    return false
end

function TAHaveUnitRatioGreaterThanNavalT1(aiBrain, Naval)
    local numOne = aiBrain:GetCurrentUnits(Naval)
    local numTwo = aiBrain:GetCurrentUnits(categories.LIGHTBOAT)
    if (numOne < ((numTwo + 1) * aiBrain.MapSizeSCTA)) then
        return true
    else
        return false
    end
    return false
end

function TAHaveUnitRatioGreaterThanNaval(aiBrain, Naval)
    local numOne = aiBrain:GetCurrentUnits(Naval)
    local numTwo = aiBrain:GetCurrentUnits(categories.FACTORY * categories.NAVAL * categories.TECH2)
    if (numOne < (numTwo + 1) * aiBrain.MapSizeSCTA) then
        return true
    else
        return false
    end
end

function TAHaveUnitRatioGreaterThanNavalT3(aiBrain, Naval)
    local numOne = aiBrain:GetCurrentUnits(Naval)
    local numTwo = aiBrain:GetCurrentUnits(categories.FACTORY * categories.NAVAL * categories.TECH2)
    if (numOne < (numTwo + aiBrain.MapSizeSCTA)) then
        return true
    else
        return false
    end
    return false
end

--[[function TAFactoryCapCheckExpansion(aiBrain, TECH)
    local numUnits = aiBrain:GetCurrentUnits(TECH)
    if numUnits < 4 then
        return true
    end
    return false
end]]
----TAReclaim


function TAReclaimablesInArea(aiBrain, locType, Mass)

    if aiBrain:GetEconomyStoredRatio('MASS') < Mass then
        local ents = TAAIGetReclaimablesAroundLocation(aiBrain, locType)
        if ents and not table.empty(ents) then
            for k,v in ents do
                if IsProp(v) then return true else return false end
            end
        else
            return false
        end
    else
        return false
    end
    return false
end

--[[function TAAIRadarAroundLocation(aiBrain, locationType)
    local position, radius
    if aiBrain.HasPlatoonList then
        for _, v in aiBrain.PBM.Locations do
            if v.LocationType == locationType then
                position = v.Location
                radius = v.Radius
                break
            end
        end
    elseif aiBrain.BuilderManagers[locationType] then
        radius = aiBrain.BuilderManagers[locationType].FactoryManager.Radius
        position = aiBrain.BuilderManagers[locationType].FactoryManager:GetLocationCoords()
    end

    if not position then
        return false
    end

    local Radar = aiBrain:GetUnitsAroundPoint((categories.STRUCTURE + categories.RADAR) - categories.FACTORY, position, 50, 'Ally')
    if Radar < 3 then
        return true
    else 
        return false
    end
end]]

function TAAIGetReclaimablesAroundLocation(aiBrain, locationType)
    local position, radius
    if aiBrain.HasPlatoonList then
        for _, v in aiBrain.PBM.Locations do
            if v.LocationType == locationType then
                position = v.Location
                radius = v.Radius
                break
            end
        end
    elseif aiBrain.BuilderManagers[locationType] then
        radius = aiBrain.BuilderManagers[locationType].FactoryManager.Radius
        position = aiBrain.BuilderManagers[locationType].FactoryManager:GetLocationCoords()
    end

    if not position then
        return false
    end

    local x1 = position[1] - radius * 2
    local x2 = position[1] + radius * 2
    local z1 = position[3] - radius * 2
    local z2 = position[3] + radius * 2
    local rect = Rect(x1, z1, x2, z2)

    return GetReclaimablesInRect(rect)
end

function TAAIReclaimablesAroundEngineer(aiBrain, engineer)
    local position = engineer:GetPosition()
    local x1 = position[1] - 20
    local x2 = position[1] + 20
    local z1 = position[3] - 20
    local z2 = position[3] + 20
    local rect = Rect(x1, z1, x2, z2)

    return GetReclaimablesInRect(rect)
end


local TAAITaunts = {
    {99, 100, 101, 102, 103}, -- Seraphim
}
local AIChatText = import('/lua/AI/sorianlang.lua').AIChatText

function TAAIRandomizeTaunt(aiBrain)
    tauntid = Random(1,table.getn(TAAITaunts[1]))
    TAAISendChat('all', aiBrain.Nickname, '/'..TAAITaunts[1][tauntid])
end

function TAAISendChat(aigroup, ainickname, aiaction, targetnickname, extrachat)
        if aiaction and AIChatText[aiaction] then
            local ranchat = Random(1, table.getn(AIChatText[aiaction]))
            local chattext
            if targetnickname then
                chattext = string.gsub(AIChatText[aiaction][ranchat],'%[target%]', targetnickname)
            elseif extrachat then
                chattext = string.gsub(AIChatText[aiaction][ranchat],'%[extra%]', extrachat)
            else
                chattext = AIChatText[aiaction][ranchat]
            end
            table.insert(Sync.AIChat, {group=aigroup, text=chattext, sender=ainickname})
        else
            table.insert(Sync.AIChat, {group=aigroup, text=aiaction, sender=ainickname})
        end
end

function TACanBuildOnMassLessThanDistanceLand(aiBrain, locationType, distance, threatMin, threatMax, threatRings, threatType, maxNum )
    local engineerManager = aiBrain.BuilderManagers[locationType].EngineerManager
    if not engineerManager or locationType == 'Naval Area' then
        return false
    end
    local position = engineerManager:GetLocationCoords()
    local markerTable = AIUtils.AIGetSortedMassLocations(aiBrain, maxNum, threatMin, threatMax, threatRings, threatType, position)
    if markerTable[1] and VDist3( markerTable[1], position ) < distance then
        local dist = VDist3( markerTable[1], position )
        return true
    end
    return false
end

function TAFindAssistUnits(aiBrain, locationType, category, range)
    --LOG('IEXISTTABRAIN')
    local engineerManager = aiBrain.BuilderManagers[locationType].EngineerManager
    if aiBrain.TAFactoryAssistance and engineerManager then
    local Engineering = aiBrain:GetUnitsAroundPoint(categories.ENGINEER * (categories.ARM + categories.CORE) - categories.COMMAND, engineerManager:GetLocationCoords(), range, 'Ally')
        if Engineering > 2 then 
        local Assist = aiBrain:GetUnitsAroundPoint(category, engineerManager:GetLocationCoords(), range, 'Ally')
            for _, Escort in Assist do
                    if Escort and Escort.DesiresAssist and Escort.SCTAAIBrain
                     and table.getn(Escort:GetGuards()) <= Escort.NumAssistees and not Escort.Escorting then
                        return true 
        --LOG('IEXISTTABRAIN2')
    --WaitSeconds(3)
    --Escort.Escorting = nil
                    end
            end
        end
    end
    return false
end

--[[function TAFindAssistUnits(aiBrain, locationType, category, range)
    --LOG('IEXISTTABRAIN')
    local engineerManager = aiBrain.BuilderManagers[locationType].EngineerManager
    if aiBrain.TAFactoryAssistance and engineerManager then
    local Unfinished = aiBrain:GetUnitsAroundPoint(categories.STRUCTURE, engineerManager:GetLocationCoords(), range, 'Ally')
        if Engineering > 2 then 
        local Assist = aiBrain:GetUnitsAroundPoint(category, engineerManager:GetLocationCoords(), range, 'Ally')
            for _, Escort in Assist do
                    if Escort and Escort.DesiresAssist and Escort.SCTAAIBrain
                     and table.getn(Escort:GetGuards()) <= Escort.NumAssistees and not Escort.Escorting then
                        return true 
        --LOG('IEXISTTABRAIN2')
    --WaitSeconds(3)
    --Escort.Escorting = nil
                    end
            end
        end
    end
    return false
end]]

--[[function TACanBuildOnMassLessThanDistanceNaval(aiBrain, locationType, distance, threatMin, threatMax, threatRings, threatType, maxNum )
    local engineerManager = aiBrain.BuilderManagers[locationType].EngineerManager
    if not (locationType == 'Naval Area' or engineerManager) then
        return false
    end
    local position = engineerManager:GetLocationCoords()
    local markerTable = AIUtils.AIGetSortedMassLocationsNavalSCTA(aiBrain, maxNum, threatMin, threatMax, threatRings, threatType, position)
    if markerTable[1] and AIAttackUtils.CanGraphAreaToSCTA(position, markerTable[1], 'Water') and VDist3( markerTable[1], position ) < distance then
        local dist = VDist3( markerTable[1], position )
        return true
    end
    return false
end]]

function TAKite(vec1, vec2, distance)
    -- Courtesy of chp2001
    -- note the distance param is {distance, distance - weapon range}
    -- vec1 is friendly unit, vec2 is enemy unit
    distanceFrac = distance[2] / distance[1]
    x = vec1[1] * (1 - distanceFrac) + vec2[1] * distanceFrac
    y = vec1[2] * (1 - distanceFrac) + vec2[2] * distanceFrac
    z = vec1[3] * (1 - distanceFrac) + vec2[3] * distanceFrac
    return {x,y,z}
end

function TAGetAssistees(aiBrain, locationType, assisteeType, buildingCategory, assisteeCategory)
    if assisteeType == 'Factory' then
        -- Sift through the factories in the location
        local manager = aiBrain.BuilderManagers[locationType].FactoryManager
        return manager:TAGetFactoriesWantingAssistance(buildingCategory, assisteeCategory)
    elseif assisteeType == 'Engineer' then
        local manager = aiBrain.BuilderManagers[locationType].EngineerManager
        return manager:TAGetEngineersWantingAssistance(buildingCategory, assisteeCategory)
    else
        WARN('*AI ERROR: Invalid assisteeType - ' .. assisteeType)
    end

    return false
end

--[[function MassFabManagerThreadSCTAI(aiBrain)
    while aiBrain.Result ~= "defeat" do
        while math.abs(aiBrain:GetEconomyIncome('ENERGY')-aiBrain:GetEconomyUsage('ENERGY'))<150 and not aiBrain:GetEconomyStoredRatio('ENERGY')<0.9 do
            WaitSeconds(2)
        end
        local fabs = aiBrain:GetListOfUnits(categories.MASSFABRICATION * categories.STRUCTURE,false,false)
        if table.getn(fabs)<1 then 
            WaitSeconds(20) 
            continue 
        end
        for k, v in fabs do
            if v:GetScriptBit('RULEUTC_ProductionToggle') then
                if aiBrain:GetEconomyIncome('ENERGY')-aiBrain:GetEconomyUsage('ENERGY')<0 or aiBrain:GetEconomyStoredRatio('ENERGY')<0.9 then
                    v:SetScriptBit('RULEUTC_ProductionToggle', false)
                    WaitTicks(1)
                end
            else
                if aiBrain:GetEconomyIncome('ENERGY')-aiBrain:GetEconomyUsage('ENERGY')>150 then
                    v:SetScriptBit('RULEUTC_ProductionToggle', true)
                    WaitTicks(1)
                end
            end
        end
        WaitSeconds(2)
    end
end

function MexManagerThreadSCTAI(aiBrain)
    while aiBrain.Result ~= "defeat" do
        local mex = aiBrain:GetListOfUnits(categories.MASSEXTRACTION * categories.STRUCTURE, false,false)
        if table.getn(mex) < 1 then 
            WaitSeconds(20) 
            continue 
        end
        for k, v in mex do
            if not v:GetFractionComplete == 1 then continue end
            if not v:IsUnitState('Upgrading') then
                if aiBrain:GetEconomyIncome('ENERGY').8 - aiBrain:GetEconomyUsage('ENERGY') < 0 or aiBrain:GetEconomyStoredRatio('ENERGY') < 0.9 then --do we want to upgrade
                    IssueUpgrade({v}, self:GetBlueprint().General.UpgradesTo)
                    WaitSeconds(2)
                end
            else
                if not v:IsPaused() then
                    if aiBrain:GetEconomyIncome('ENERGY') - aiBrain:GetEconomyUsage('ENERGY') > 150 then--if power stalling or mass stalling bad then pause
                        v:SetPaused(true)
                        WaitTicks(1)
                    end
                else
                    if aiBrain:GetEconomyIncome('ENERGY') - aiBrain:GetEconomyUsage('ENERGY') > 150 then--if not power stalling or mass stalling bad then unpause
                        v:SetPaused(false)
                        WaitTicks(1)
                    end
                end
            end
        end
        WaitSeconds(4)--do the loop every 4 seconds
    end
end]]