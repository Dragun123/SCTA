do

    local TAStratIconTranslation = {
        icon_bot1_artillery = 'land_artillery',
        icon_bot2_artillery = 'land_artillery',
        icon_bot3_artillery = 'land_artillery',
        icon_fighter1_missile = 'fighter_directfire',
        icon_fighter2_missile = 'fighter_directfire',
        icon_fighter3_missile = 'fighter_directfire',
        icon_bot3_engineer = 'land_engineer',
        icon_bot2_engineer = 'land_engineer',
        icon_bot1_engineer = 'land_engineer',
}

aStratIconTranslation = table.merged(aStratIconTranslation, TAStratIconTranslation)



    local TAStratIconTranslationFull = {
        icon_bot1_artillery = '1/land_artillery',
        icon_bot2_artillery = '2/land_artillery',
        icon_bot3_artillery = '3/land_artillery',
        icon_bot1_missile = '1/land_missile',
        icon_bot2_missile = '2/land_missile',
        icon_fighter1_missile = '1/fighter_directfire',
        icon_fighter2_missile = '2/fighter_directfire',
        icon_fighter3_missile = '3/fighter_directfire',
        icon_bot1_engineer = '1/land_engineer',
        icon_bot2_engineer = '2/land_engineer',
        icon_bot3_engineer = '3/land_engineer',
    }

aStratIconTranslationFull = table.merged(aStratIconTranslationFull, TAStratIconTranslationFull)


    local TASpecificStratIcons = {
        armestor = 'structure_energystorage',
        armmstor = 'structure_massstorage',
        armmakr = 'structure_massfab',
        armmmkr = 'structure_massfab',
        armmanni = '2/bot_sniper',
        armscram = '3/ship_counterintel',
        armbull = '3/bot_armored',
    
        corestor = 'structure_energystorage',
        cormstor = 'structure_massstorage',
        cormakr = 'structure_massfab',
        cormmmkr = 'structure_massfab',
        corvipe = '2/bot_sniper',
    }

aSpecificStratIcons = table.merged(aSpecificStratIcons, TASpecificStratIcons)

end