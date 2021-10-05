    do

        local TAStratIconTranslation = {
            icon_bot1_artillery = 'bot_artillery',
            icon_bot1_counterintel = 'bot_counterintel',
            icon_bot1_missile = 'land_missile',
            icon_bot2_missile = 'land_missile',
            icon_bot2_artillery = 'bot_artillery',
            icon_bot2_counterintel = 'bot_counterintel',
            icon_bot3_artillery = 'bot_artillery',
            icon_bot3_counterintel = 'bot_counterintel',
            icon_fighter1_missile = 'fighter_missile',
            icon_fighter2_missile = 'fighter_missile',
            icon_fighter3_missile = 'fighter_missile',
            icon_land2_antimissile = 'land_antimissile',
            icon_land1_antimissile = 'land_antimissile',
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
    
    aStratIconTranslation = table.merged(aStratIconTranslation, TAStratIconTranslation)
    
    
    
        local TAStratIconTranslationFull = {
            icon_bot1_artillery = '1/land_artillery',
            icon_bot1_counterintel = '1/bot_counterintel',
            icon_bot2_artillery = '2/bot_artillery',
            icon_bot2_counterintel = '2/bot_counterintel',
            icon_bot3_artillery = '3/bot_artillery',
            icon_bot3_counterintel = '3/bot_counterintel',
            icon_bot1_missile = '1/land_missile',
            icon_bot2_missile = '2/land_missile',
            icon_fighter1_missile = '1/fighter_missile',
            icon_fighter2_missile = '2/fighter_missile',
            icon_fighter3_missile = '3/fighter_missile',
            icon_land3_transport = '3/structure_transport',
            icon_fighter1_engineer = '1/land_engineer',
            icon_fighter2_engineer = '2/land_engineer',
            icon_fighter3_engineer = '3/land_engineer',
            icon_bot1_engineer = '1/land_engineer',
            icon_bot2_engineer = '2/land_engineer',
            icon_ship1_engineer = '1/land_engineer',
            icon_sub2_engineer= '2/land_engineer',
            icon_land2_antimissile = '2/land_antimissile',
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
    
    aSpecificStratIcons = table.merged(aSpecificStratIcons, TASpecificStratIcons)

end