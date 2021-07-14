local util = import('/lua/utilities.lua')

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
    self.TARestrict = true
    if EntityCategoryContains(categories.TECH1 * categories.CONSTRUCTION - categories.FACTORY, self) and aiBrain.Plants < 10 then
        self:AddBuildRestriction(categories.TECH2) 
        return
    elseif EntityCategoryContains(categories.TECH2 * categories.CONSTRUCTION - categories.RESEARCH, self) and aiBrain.Labs < 4 then
        self:AddBuildRestriction(categories.TECH3)
        return
    --[[else
        return]]
    end
end

TABuildRestrictions = function(self)
    local aiBrain = self:GetAIBrain()
    local PlantsCat = ((categories.FACTORY + categories.GATE) * (categories.ARM + categories.CORE))
    if aiBrain.Level3 or NumberOfPlantsT2(aiBrain, PlantsCat * (categories.TECH2)) > 4 
    or self.FindHQType(aiBrain, PlantsCat * (categories.TECH3 + categories.EXPERIMENTAL)) then
                self:RemoveBuildRestriction(categories.TECH2)
                self:RemoveBuildRestriction(categories.TECH3)
                aiBrain.Level3 = true
                self.TARestrict = nil
        return  
    elseif aiBrain.Level2 or NumberOfPlantsT1(aiBrain, PlantsCat * (categories.TECH1)) > 10
    or self.FindHQType(aiBrain, PlantsCat * (categories.TECH2 + categories.EXPERIMENTAL)) then
                self:RemoveBuildRestriction(categories.TECH2)
                aiBrain.Level2 = true
                self.TARestrict = nil
        return    
    end
end



NumberOfPlantsT2 = function(aiBrain, category)
    -- Returns number of extractors upgrading
    aiBrain.DevelopmentCount = aiBrain:GetCurrentUnits(categories.RESEARCH * category)
    --LOG('*SCTADeveloment', aiBrain.DevelopmentCount)
    aiBrain.LabCount = aiBrain:GetCurrentUnits(categories.SUPPORTFACTORY * category)
    --LOG('*SCTALabsCount', aiBrain.LabCount)
    aiBrain.LabBuilding = aiBrain:NumCurrentlyBuilding(categories.ENGINEER, categories.SUPPORTFACTORY * category)
    --LOG('*SCTALabuilding', aiBrain.LabBuilding)
    aiBrain.DevelopmentBuilding = aiBrain:NumCurrentlyBuilding(categories.FACTORY, categories.RESEARCH * category)
    --LOG('*SCTADevelomentBuilding', aiBrain.DevelopmentBuilding)
    aiBrain.Labs = ((aiBrain.LabCount) + (aiBrain.DevelopmentCount * 2)) - aiBrain.LabBuilding - (aiBrain.DevelopmentBuilding * 2)
    --LOG('*SCTALabsOG', aiBrain.Labs)
    return aiBrain.Labs
end

NumberOfPlantsT1 = function(aiBrain, category)
    -- Returns number of extractors upgrading
    aiBrain.PlantCount = aiBrain:GetCurrentUnits(category)
    --LOG('*SCTAPlantCount', aiBrain.PlantCount)
    aiBrain.PlantBuilding = aiBrain:NumCurrentlyBuilding(categories.ENGINEER, category)
    --LOG('*SCTAPlantBuilding', aiBrain.PlantBuilding)
    aiBrain.Plants = aiBrain.PlantCount - aiBrain.PlantBuilding
    --LOG('*SCTAPlants', aiBrain.Plants)
    return aiBrain.Plants
end

--self.FindHQType(aiBrain, category)
FindHQType = function(aiBrain, category)
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


