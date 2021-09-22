WARN('['..string.gsub(debug.getinfo(1).source, ".*\\(.*.lua)", "%1")..', line:'..debug.getinfo(1).currentline..'] * SCTAAI: offset aibuildstructures.lua' )

TAAIBuildAdjacency = AIBuildAdjacency

function AIExecuteBuildStructureSCTAAI(aiBrain, builder, buildingType, closeToBuilder, relative, buildingTemplate, baseTemplate, reference, NearMarkerType)
    local factionIndex = aiBrain:GetFactionIndex()
    local whatToBuild = aiBrain:DecideWhatToBuild( builder, buildingType, buildingTemplate)
    if not whatToBuild then
        return
    end
    local relativeTo
    if closeToBuilder then
        relativeTo = closeToBuilder:GetPosition()
    elseif builder.BuilderManagerData and builder.BuilderManagerData.EngineerManager then
        relativeTo = builder.BuilderManagerData.EngineerManager:GetLocationCoords()
    else
        local startPosX, startPosZ = aiBrain:GetArmyStartPos()
        relativeTo = {startPosX, 0, startPosZ}
    end
    local location = false
    if IsResource(buildingType) then
        location = aiBrain:FindPlaceToBuild(buildingType, whatToBuild, baseTemplate, relative, closeToBuilder, 'Enemy', relativeTo[1], relativeTo[3], 5)
    else
        location = aiBrain:FindPlaceToBuild(buildingType, whatToBuild, baseTemplate, relative, closeToBuilder, nil, relativeTo[1], relativeTo[3])
    end
    if not location and reference then
        for num,offsetCheck in RandomIter({1,2,3,4,5,6,7,8}) do
            location = aiBrain:FindPlaceToBuild( buildingType, whatToBuild, BaseTmplFile['MovedTemplates'..offsetCheck][factionIndex], relative, closeToBuilder, nil, relativeTo[1], relativeTo[3])
            if location then
                break
            end
        end
    end
    if location then
        local relativeLoc = BuildToNormalLocation(location)
        if relative then
            relativeLoc = {relativeLoc[1] + relativeTo[1], relativeLoc[2] + relativeTo[2], relativeLoc[3] + relativeTo[3]}
        end
        AddToBuildQueue(aiBrain, builder, whatToBuild, NormalToBuildLocation(relativeLoc), false)
        return
    end
end

function AIBuildAdjacency( aiBrain, builder, buildingType , closeToBuilder, relative, buildingTemplate, baseTemplate, reference, NearMarkerType)
    if not aiBrain.SCTAAI then
        return TAAIBuildAdjacency( aiBrain, builder, buildingType , closeToBuilder, relative, buildingTemplate, baseTemplate, reference, NearMarkerType)
    end
    AIExecuteBuildStructureSCTAAI( aiBrain, builder, buildingType, builder, false,  buildingTemplate, baseTemplate )
end


function AIBuildBaseTemplateOrderedSCTAAI(aiBrain, builder, buildingType , closeToBuilder, relative, buildingTemplate, baseTemplate, reference, NearMarkerType)
    local factionIndex = aiBrain:GetFactionIndex()
    local whatToBuild = aiBrain:DecideWhatToBuild(builder, buildingType, buildingTemplate)
    if whatToBuild then
        if IsResource(buildingType) then
            return AIExecuteBuildStructureSCTAAI(aiBrain, builder, buildingType , closeToBuilder, relative, buildingTemplate, baseTemplate, reference)
        else
            for l,bType in baseTemplate do
                for m,bString in bType[1] do
                    if bString == buildingType then
                        for n,position in bType do
                            if n > 1 and aiBrain:CanBuildStructureAt(whatToBuild, BuildToNormalLocation(position)) then
                                 AddToBuildQueue(aiBrain, builder, whatToBuild, position, false)
                                 return DoHackyLogic(buildingType, builder)
                            end 
                        end 
                        break
                    end
                end 
            end 
        end 
    end
    return 
end

function TAAINewExpansionBase(aiBrain, baseName, position, builder, constructionData)
    local radius = constructionData.ExpansionRadius or 100
        if not aiBrain.BuilderManagers or aiBrain.BuilderManagers[baseName] or not builder.BuilderManagerData then
            #LOG('*AI DEBUG: ARMY ' .. aiBrain:GetArmyIndex() .. ': New Engineer for expansion base - ' .. baseName)
            builder.BuilderManagerData.EngineerManager:RemoveUnit(builder)
            aiBrain.BuilderManagers[baseName].EngineerManager:AddUnit(builder, true)
            return
        end

        aiBrain:AddBuilderManagers(position, radius, baseName, true)
        builder.BuilderManagerData.EngineerManager:RemoveUnit(builder)
        aiBrain.BuilderManagers[baseName].EngineerManager:AddUnit(builder, true)

        # Iterate through bases finding the value of each expansion
        local baseValues = {}
        local highPri = false
        for templateName, baseData in BaseBuilderTemplates do
            local baseValue = baseData.ExpansionFunction(aiBrain, position, constructionData.NearMarkerType)
            table.insert(baseValues, { Base = templateName, Value = baseValue })
            --SPEW('*AI DEBUG: AINewExpansionBase(): Scann next Base. baseValue= ' .. repr(baseValue) .. ' ('..repr(templateName)..')')
            if not highPri or baseValue > highPri then
                --SPEW('*AI DEBUG: AINewExpansionBase(): Possible next Base. baseValue= ' .. repr(baseValue) .. ' ('..repr(templateName)..')')
                highPri = baseValue
            end
        end

        # Random to get any picks of same value
        local validNames = {}
        for k,v in baseValues do
            if v.Value == highPri then
                table.insert(validNames, v.Base)
                --LOG('SCTAExpansion Data'..repr(validNames))
            end
        end
        --SPEW('*AI DEBUG: AINewExpansionBase(): validNames for Expansions ' .. repr(validNames))
        local pick = validNames[ Random(1, table.getn(validNames)) ]
        if not pick then
            LOG('*AI DEBUG: ARMY ' .. aiBrain:GetArmyIndex() .. ': Layer Preference - ' .. per .. ' - yielded no base types at - ' .. locationType)
        end

        --SPEW('*AI DEBUG: AINewExpansionBase(): ARMY ' .. aiBrain:GetArmyIndex() .. ': Expanding using - ' .. pick .. ' at location ' .. baseName)
        import('/lua/ai/AIAddBuilderTable.lua').AddGlobalBaseTemplate(aiBrain, baseName, pick)
end