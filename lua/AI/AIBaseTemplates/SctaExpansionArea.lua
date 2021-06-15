
BaseBuilderTemplate {
    BaseTemplateName = 'SCTAAIExpansion',
    Builders = {

        -- Unit Builders
        'SCTAAILandBuilder',
        'SCTAAIAirBuilder',
        'SCTAAILandFormers',
        'SCTAAIAirFormers',
        'SCTAAIT3Builder',

        'SCTAExpansionBuilders',
        'SCTAAIEngineerMiscBuilder',
        'SCTAAIFactoryExpansions',
        'SCTAAIEngineerEcoBuilder',
        'SCTAUpgrades',
    },
    BaseSettings = {
        EngineerCount = {
            Tech1 = 4, 
            Tech2 = 2, 
            Tech3 = 2, 
            SCU = 0,
        },
        FactoryCount = {
            Land = 6,
            Air = 3,
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
        --local per = ScenarioInfo.ArmySetup[aiBrain.Name].AIPersonality
        --LOG('Ai Personality is '..per)
        if not aiBrain.SCTAAI then
            return -1
        end
        if markerType ~= 'Expansion Area' then
                ---LOG('IEXISTSTART')
                return -1
            end
        --LOG('IEXISTEXPANDFAIL')
        --LOG('Return sctaai personality')
        return 15
    end,
}

