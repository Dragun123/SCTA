local util = import('/lua/utilities.lua')
local PlantsCat = ((categories.FACTORY + categories.GATE) * (categories.ARM + categories.CORE))
----This Code Here represents the various TA Building effects. 
----Furthermore unlike the basegame code I test if I am dead. It might be worthwhile to removed it. That test things to consider. 
CreateTABuildingEffects = function(builder, unitBeingBuilt, BuildEffectBones, BuildEffectsBag)
    WaitSeconds(0.75)
    local selfPosition = builder:GetPosition()
    local targetPosition = unitBeingBuilt:GetPosition()
    local distance = util.GetDistanceBetweenTwoVectors(selfPosition, targetPosition)
        for _, vBone in BuildEffectBones do
        BuildEffectsBag:Add(CreateAttachedEmitter(builder, vBone, builder.Army, '/mods/SCTA-master/effects/emitters/nanolathe.bp' ):ScaleEmitter(0.1):SetEmitterCurveParam('LIFETIME_CURVE',distance,0))
        end
end
    

CreateTAAirBuildingEffects = function(builder, unitBeingBuilt, BuildEffectBones, BuildEffectsBag)
    WaitSeconds(0.75)
    for _, vBone in BuildEffectBones do
        BuildEffectsBag:Add(CreateAttachedEmitter(builder, vBone, builder.Army, '/mods/SCTA-master/effects/emitters/nanolathe.bp' ):ScaleEmitter(0.1))
        end
    end



CreateTAFactBuildingEffects = function(builder, unitBeingBuilt, BuildEffectBones, BuildEffectsBag)
    WaitSeconds(0.5)
    for _, vBone in BuildEffectBones do
        BuildEffectsBag:Add(CreateAttachedEmitter(builder, vBone, builder.Army, '/mods/SCTA-master/effects/emitters/nanolathe.bp' ):ScaleEmitter(0.05))
        end
    end

CreateTASeaFactBuildingEffects = function(builder, unitBeingBuilt, BuildEffectBones, BuildEffectsBag)
    WaitSeconds(0.1)
    for _, vBone in BuildEffectBones do
        BuildEffectsBag:Add(CreateAttachedEmitter(builder, vBone, builder.Army, '/mods/SCTA-master/effects/emitters/nanolathe.bp' ):ScaleEmitter(0.08):SetEmitterCurveParam('LIFETIME_CURVE',10,0))
        end
    end

CreateTAGantBuildingEffects = function(builder, unitBeingBuilt, BuildEffectBones, BuildEffectsBag)
    WaitSeconds(0.75)
    for _, vBone in BuildEffectBones do
        BuildEffectsBag:Add( CreateAttachedEmitter( builder, vBone, builder.Army,  '/mods/SCTA-master/effects/emitters/nanolathe.bp' ):ScaleEmitter(0.18):OffsetEmitter(0,0,-0.2))
        end
    end


TAReclaimEffects = function(reclaimer, reclaimed, BuildEffectBones, ReclaimEffectsBag)
    WaitSeconds(1)
    local selfPosition = reclaimer:GetPosition()
    local targetPosition = reclaimed:GetPosition()
    local distance = util.GetDistanceBetweenTwoVectors(selfPosition, targetPosition)
        for _, vBone in BuildEffectBones do
            ReclaimEffectsBag:Add( CreateAttachedEmitter( reclaimer, vBone, reclaimer:GetArmy(),  '/mods/SCTA-master/effects/emitters/reclaimnanolathe.bp' ):ScaleEmitter(0.05):OffsetEmitter(0,0,1.5):SetEmitterCurveParam('LIFETIME_CURVE',distance,0):SetEmitterCurveParam('Z_POSITION_CURVE',distance * 10,0))
        end
    end

TACommanderReclaimEffects = function(reclaimer, reclaimed, BuildEffectBones, ReclaimEffectsBag)
        WaitSeconds(1)
        local selfPosition = reclaimer:GetPosition()
        local targetPosition = reclaimed:GetPosition()
        local distance = util.GetDistanceBetweenTwoVectors(selfPosition, targetPosition)
            for _, vBone in BuildEffectBones do
                ReclaimEffectsBag:Add( CreateAttachedEmitter( reclaimer, vBone, reclaimer:GetArmy(),  '/mods/SCTA-master/effects/emitters/reclaimnanolathe.bp' ):ScaleEmitter(0.1):OffsetEmitter(0,0,1):SetEmitterCurveParam('LIFETIME_CURVE',distance,0):SetEmitterCurveParam('Z_POSITION_CURVE',distance * 10,0))
            end
        end



TAAirReclaimEffects = function(reclaimer, reclaimed, BuildEffectBones, ReclaimEffectsBag)
    WaitSeconds(1)
    local selfPosition = reclaimer:GetPosition()
    local targetPosition = reclaimed:GetPosition()
    local distance = util.GetDistanceBetweenTwoVectors(selfPosition, targetPosition)
        for _, vBone in BuildEffectBones do
            ReclaimEffectsBag:Add( CreateAttachedEmitter( reclaimer, vBone, reclaimer:GetArmy(), '/mods/SCTA-master/effects/emitters/reclaimnanolathe.bp' ):ScaleEmitter(0.05):OffsetEmitter(0.1,0,1):SetEmitterCurveParam('LIFETIME_CURVE',distance,0):SetEmitterCurveParam('Z_POSITION_CURVE',distance * 10,0))
        end
    end


TACaptureEffect = function(capturer, captive, BuildEffectBones, CaptureEffectsBag)  
    WaitSeconds(0.75)
    local selfPosition = capturer:GetPosition()
    local targetPosition = captive:GetPosition()
    local distance = util.GetDistanceBetweenTwoVectors(selfPosition, targetPosition)
    for _, vBone in BuildEffectBones do
        CaptureEffectsBag:Add( CreateAttachedEmitter( capturer, vBone, capturer:GetArmy(),  '/mods/SCTA-master/effects/emitters/reclaimnanolathe.bp' ):ScaleEmitter(0.1):OffsetEmitter(0,0,0.5):SetEmitterCurveParam('LIFETIME_CURVE',distance,0):SetEmitterCurveParam('Z_POSITION_CURVE',distance * 10,0))
    end
end


updateBuildRestrictions = function(self)
    local aiBrain = self:GetAIBrain()
    --Add build restrictions
    --EngiModFinalFORMTA
    ---Basicallys Stop Lower Tech from building UpperTech. Advanced Factories now full access to builds
    ---Will require another rebalancing of Seaplanes and Hovers
    --self.TARestrict = true
    if EntityCategoryContains(categories.TECH1 * categories.CONSTRUCTION - categories.FACTORY, self) and aiBrain.Plants < 10 then
        self:AddBuildRestriction(categories.TECH2) 
        return
    elseif EntityCategoryContains(categories.TECH2 * categories.CONSTRUCTION - categories.CONSTRUCTIONSORTDOWN, self) and aiBrain.Labs < 4 then
        self:AddBuildRestriction(categories.TECH3)
        return
    --[[else
        return]]
    end
end

TABuildRestrictions = function(self)
    --GetListOfUnits, there is a bug regarding removing BeingBuilt Unitss
    ---GetCurrentUnits - GetUnitsBuilding somehow results in game thinking you have two less than you actually do
    ---NumberOfPlantsX returns Number of Units. The checks associated with it such as Level3, Level2 and number of constructed factories are used for AI
    ----Find HQ Type is used primarily so that Supcom FAF players can work off gut instinct
    local aiBrain = self:GetAIBrain()
    if aiBrain.Level3 or NumberOfPlantsT2(aiBrain, PlantsCat * (categories.TECH2)) > 4 
    or TAHQType(aiBrain, PlantsCat * (categories.TECH3 + categories.EXPERIMENTAL)) then
                self:RemoveBuildRestriction(categories.TECH2)
                self:RemoveBuildRestriction(categories.TECH3)
                if not aiBrain.Level3 then
                aiBrain.Level3 = true
                end
                --self.TARestrict = nil
        return  
    elseif aiBrain.Level2 or NumberOfPlantsT1(aiBrain, PlantsCat * (categories.TECH1)) > 10
    or TAHQType(aiBrain, PlantsCat * (categories.TECH2 + categories.EXPERIMENTAL)) then
                self:RemoveBuildRestriction(categories.TECH2)
                if not aiBrain.Level2 then
                aiBrain.Level2 = true
                end
                --self.TARestrict = nil
        return    
    end
end



NumberOfPlantsT2 = function(aiBrain, category)
    ----NeedToIncorperateWhatJip Did Here
    ----Using ConstructionSortDown as its only relavent for the upgraded Factories
    ---Also apparently this was broken for like a year amazing
    -- Returns number of extractors upgrading
    local DevelopmentCount = aiBrain:GetCurrentUnits(categories.CONSTRUCTIONSORTDOWN * category)
    --LOG('*SCTADeveloment', aiBrain.DevelopmentCount)
    local LabCount = aiBrain:GetCurrentUnits(category - categories.CONSTRUCTIONSORTDOWN)
    --LOG('*SCTALabsCount', aiBrain.LabCount)
    local LabBuilding = aiBrain:NumCurrentlyBuilding(categories.ENGINEER, category - categories.CONSTRUCTIONSORTDOWN)
    --LOG('*SCTALabuilding', aiBrain.LabBuilding)
    local DevelopmentBuilding = aiBrain:NumCurrentlyBuilding(categories.FACTORY, categories.CONSTRUCTIONSORTDOWN * category)
    --LOG('*SCTADevelomentBuilding', aiBrain.DevelopmentBuilding)
    aiBrain.Labs = ((LabCount) + (DevelopmentCount * 2)) - LabBuilding - (DevelopmentBuilding * 2)
    --LOG('*SCTALabsOG', aiBrain.Labs)
    return aiBrain.Labs
end

NumberOfPlantsT1 = function(aiBrain, category)
    -- Returns number of extractors upgrading
    local PlantCount = aiBrain:GetCurrentUnits(category)
    --LOG('*SCTAPlantCount', aiBrain.PlantCount)
    local PlantBuilding = aiBrain:NumCurrentlyBuilding(categories.ENGINEER, category)
    --LOG('*SCTAPlantBuilding', aiBrain.PlantBuilding)
    aiBrain.Plants = PlantCount - PlantBuilding
    --LOG('*SCTAPlants', aiBrain.Plants)
    return aiBrain.Plants
end

--self.FindHQType(aiBrain, category)
TAHQType = function(aiBrain, category)
    for id, unit in aiBrain:GetListOfUnits(category, false, true) do
        if not unit:IsBeingBuilt() then
            return true
        end
    end
    return false
end

targetingFacilityData = {}

function registerTargetingFacility(army)
    if (targetingFacilityData[army]) then
        targetingFacilityData[army] = targetingFacilityData[army] + 1
    else
        targetingFacilityData[army] = 1
    end

end

function unregisterTargetingFacility(army)
    if (targetingFacilityData[army]) then
        targetingFacilityData[army] = targetingFacilityData[army] - 1
    else
        targetingFacilityData[army] = 0
    end
end

function ArmyHasTargetingFacility(army)
    return (targetingFacilityData[army] > 0 and GetArmyBrain(army):GetEconomyStored('ENERGY') > 0)
end


