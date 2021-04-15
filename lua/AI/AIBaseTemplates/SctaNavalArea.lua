BaseBuilderTemplate {
    BaseTemplateName = 'SCTANavalExpansion',
    Builders = {
        'SCTAAINavalBuilder',
        'SCTANavalFormer',

        -- Buildings etc
        'SCTAExpansionBuilders',
        'SCTAAIEngineerNavalMiscBuilder',
    },
    BaseSettings = {
        EngineerCount = {
            Tech1 = 6, 
            Tech2 = 4, 
            Tech3 = 1, 
            SCU = 0,
        },
        FactoryCount = {
            Land = 2,
            Air = 1,
            Sea = 4,
            Gate = 0,
        },
        MassToFactoryValues = {
            T1Value = 4,
            T2Value = 12,
            T3Value = 18
        },
    },

    ExpansionFunction = function(aiBrain, location, markerType)
        if not aiBrain.SCTAAI then   
        return -1
        elseif markerType != 'Naval Area' or 'Naval Defensive Point' then
            return 35, 'SCTANavalExpansion' 
        else
            --LOG('Return sctaai personality')
        return 10, 'SCTAAI'
        end
    end,
}

