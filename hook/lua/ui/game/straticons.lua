    do
--LOG('TAIEXIST1')
        local TAStratIconTranslation = {
            icon_bot1_artillery = 'land_artillery',
            icon_bot1_counterintel = 'land_counterintel',
            icon_bot1_missile = 'land_missile',
            icon_bot2_missile = 'land_missile',
            icon_bot2_artillery = 'land_artillery',
            icon_bot2_counterintel = 'land_counterintel',
            icon_bot3_artillery = 'land_artillery',
            icon_bot3_counterintel = 'land_counterintel',
            icon_fighter1_missile = 'fighter_antiair',
            icon_fighter2_missile = 'fighter_antiair',
            icon_fighter3_missile = 'fighter_antiair',
            icon_land2_antimissile = 'structure_antimissile',
            icon_land1_antimissile = 'structure_antimissile',
            icon_fighter1_engineer = 'land_engineer',
            icon_fighter2_engineer = 'land_engineer',
            icon_fighter3_engineer = 'land_engineer',
            icon_land3_transport = 'structure_transport',
            icon_ship1_engineer = 'land_engineer',
            icon_sub2_engineer = 'land_engineer',
            icon_bot3_engineer = 'land_engineer',
            icon_bot2_engineer = 'land_engineer',
            icon_bot1_engineer = 'land_engineer',
            icon_structure3_sniper = 'bot_sniper',
            icon_structure2_sniper = 'bot_sniper',
            icon_land2_sniper = 'bot_sniper',
            icon_structure3_bomb = 'land_bomb',
            icon_structure2_bomb = 'land_bomb',
            icon_structure1_bomb = 'land_bomb',
            icon_factory1_bot = 'factory_land',
            icon_factory2_bot = 'factory_land',
            icon_sub3_counterintel = 'ship_counterintel',
    }
    --LOG('TAIEXIST2')
    aStratIconTranslation = table.merged(aStratIconTranslation, TAStratIconTranslation)
    
    ----icon here not in base game i.e. factory(x)_bot, structure(x)_bomb, and several bot icons are only here for completionist and do not translate
    ----All Engineers given the Land Engineer Build Icon
    ----Bot CIntel given Land CIntel Icon. Several others as well as such as artillery
    ----missiles given AA icon to indicate intended targets
    
        local TAStratIconTranslationFull = {
            icon_bot1_artillery = '1/land_artillery',
            icon_bot1_counterintel = '1/land_counterintel',
            icon_bot2_artillery = '2/land_artillery',
            icon_bot2_counterintel = '2/land_counterintel',
            icon_bot3_artillery = '3/land_artillery',
            icon_bot3_counterintel = '3/land_counterintel',
            icon_bot1_missile = '1/land_missile',
            icon_bot2_missile = '2/land_missile',
            icon_fighter1_missile = '1/fighter_antiair',
            icon_fighter2_missile = '2/fighter_antiair',
            icon_fighter3_missile = '3/fighter_antiair',
            icon_land3_transport = '3/structure_transport',
            icon_fighter1_engineer = '1/land_engineer',
            icon_fighter2_engineer = '2/land_engineer',
            icon_fighter3_engineer = '3/land_engineer',
            icon_bot1_engineer = '1/land_engineer',
            icon_bot2_engineer = '2/land_engineer',
            icon_ship1_engineer = '1/land_engineer',
            icon_sub2_engineer= '2/land_engineer',
            icon_land2_antimissile = '2/structure_antimissile',
            icon_structure3_sniper = '3/bot_sniper',
            icon_structure2_sniper = '2/bot_sniper',
            icon_land2_sniper = '2/bot_sniper',
            icon_structure3_bomb = '3/land_bomb',
            icon_structure2_bomb = '2/land_bomb',
            icon_structure1_bomb = '1/land_bomb',
            icon_factory1_bot = '1/factory_land',
            icon_factory2_bot = '2/factory_land',
            icon_sub3_counterintel = '3/ship_counterintel',
        }
        --LOG('TAIEXIST3')
    aStratIconTranslationFull = table.merged(aStratIconTranslationFull, TAStratIconTranslationFull)
    
    
        local TASpecificStratIcons = {
            armestor = 'structure_energystorage',
            armmstor = 'structure_massstorage',
            armmakr = 'structure_massfab',
            armmmkr = 'structure_massfab',
        
            corestor = 'structure_energystorage',
            cormstor = 'structure_massstorage',
            cormakr = 'structure_massfab',
            cormmmkr = 'structure_massfab',
        }
        --LOG('TAIEXIST4')
    aSpecificStratIcons = table.merged(aSpecificStratIcons, TASpecificStratIcons)

end