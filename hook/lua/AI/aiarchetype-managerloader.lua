#****************************************************************************
#**
#**  File     :  /lua/AI/aiarchetype-rushland.lua
#**
#**  Summary  : Rush AI
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
TAExecutePlan = ExecutePlan
TASetupMainBase = SetupMainBase
--WARN('['..string.gsub(debug.getinfo(1).source, ".*\\(.*.lua)", "%1")..', line:'..debug.getinfo(1).currentline..'] * SCTAAI: offset aiarchtype.lua' )

function ExecutePlan(aiBrain)
    if not aiBrain.SCTAAI then
        return TAExecutePlan(aiBrain)
    end
    aiBrain:SetConstantEvaluate(false)
    local behaviors = import('/lua/ai/AIBehaviors.lua')
    --WaitSeconds(1)
    coroutine.yield(11)
    if not aiBrain.BuilderManagers.MAIN.FactoryManager:HasBuilderList() then

        -- Debug for Platoon names. Option can only be true if AI uveso is active. Without AI-Uveso this if-then does nothing.
        if (aiBrain[ScenarioInfo.Options.AIPLatoonNameDebug] or ScenarioInfo.Options.AIPLatoonNameDebug == 'all') and not aiBrain.BuilderManagers.MAIN.FactoryManager:HasBuilderList() then
            aiBrain:ForkThread(LocationRangeManagerThread, aiBrain)
        end

        aiBrain:SetResourceSharing(true)


        SetupMainBase(aiBrain)

        --Get units out of pool and assign them to the managers
        local mainManagers = aiBrain.BuilderManagers.MAIN

        local pool = aiBrain:GetPlatoonUniquelyNamed('ArmyPool')
        for k,v in pool:GetPlatoonUnits() do
            if EntityCategoryContains(categories.ENGINEER, v) then
                mainManagers.EngineerManager:AddUnit(v)
            elseif EntityCategoryContains(categories.FACTORY, v) then
                mainManagers.FactoryManager:AddFactory(v)
            end
        end

            aiBrain:ForkThread(UnitCapWatchThread)
        end
end

function SetupMainBase(aiBrain)
    if not aiBrain.SCTAAI then
        return TASetupMainBase(aiBrain)
    end
    local base, returnVal, baseType = GetHighestBuilder(aiBrain)

    local per = ScenarioInfo.ArmySetup[aiBrain.Name].AIPersonality
    ScenarioInfo.ArmySetup[aiBrain.Name].AIBase = base
    if per != 'SCTAAI' then
        ScenarioInfo.ArmySetup[aiBrain.Name].AIPersonality = baseType
    end

    --LOG('*AI DEBUG: ARMY ', repr(aiBrain:GetArmyIndex()), ': Initiating Archetype using ' .. base)
    AIAddBuilderTable.AddGlobalBaseTemplate(aiBrain, 'MAIN', base)
    aiBrain:ForceManagerSort()
end

