
BaseBuilderTemplate {
    BaseTemplateName = 'SCTAAISTARTEXPANSION',
    Builders = {
        -- List all our builder grous here
        -- ACU
        'SCTAAICommanderBuilder',

        -- Unit Builders
        'SCTAAIEngineerBuilder',
        'SCTAAILandBuilder',
        'SCTAAIAirBuilder',
        'SCTAAILandFormers',
        'SCTAAIAirFormers',

        -- Buildings etc
        
        'SCTAExpansionBuilders',
        'SCTAAIEngineerEcoBuilder',
        'SCTAAIFactoryExpansions',
        'SCTAUpgrades',
        --Misc Function
        'SCTAAssisters',
    },
    BaseSettings = {
        EngineerCount = {
            Tech1 = 2, 
            Tech2 = 1, 
            Tech3 = 1, 
            SCU = 0,
        },
        FactoryCount = {
            Land = 4,
            Air = 2,
            Sea = 1,
            Gate = 0,
        },
        MassToFactoryValues = {
            T1Value = 4,
            T2Value = 12,
            T3Value = 18
        },
    },
    ExpansionFunction = function(aiBrain, location, markerType)   
        local per = ScenarioInfo.ArmySetup[aiBrain.Name].AIPersonality
        --LOG('Ai Personality is '..per)
        if not per == 'sctaaiarm' or per == 'sctaaicore' or per == 'sctaaiarmcheat' or per == 'sctaaicorecheat' then
            return -1
        end
        if markerType != 'Start Location' then
            return 10
        end
        --LOG('Return sctaai personality')
        return 1000, 'SCTAAISTARTEXPANSION'
    end,
}
