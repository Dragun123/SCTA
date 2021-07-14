--[[
    File    :   /lua/AI/PlattonTemplates/SCTAAITemplates.lua
    Author  :   SoftNoob
    Summary :
        Responsible for defining a mapping from AIBuilders keys -> Plans (Plans === platoon.lua functions)
]]
RAIDAIR = (categories.armfig + categories.corveng + categories.GROUNDATTACK)
RAIDER = (categories.armpw + categories.corak + categories.armflash + categories.corgator)
SPECIAL = (RAIDER + categories.EXPERIMENTAL + categories.ENGINEER + categories.SCOUT + categories.BOMB)
GROUND = (categories.MOBILE * categories.LAND - categories.TRANSPORTFOCUS)
RANGE = (categories.ARTILLERY + categories.SILO + categories.ANTIAIR + categories.SNIPER)

PlatoonTemplate {
    Name = 'T1LandScoutFormSCTA',
    Plan = 'ScoutingAISCTA',
    ---PlatoonType = 'Scout',
    GlobalSquads = {
        { GROUND * categories.SCOUT, 1, 1, 'Scout', 'none' },
    }
}

PlatoonTemplate {
    Name = 'GuardSCTA',
    Plan = 'None',
    ---PlatoonType = 'Scout',
    GlobalSquads = {
        { GROUND - SPECIAL, 1, 1, 'Guard', 'none' }
    },
}

PlatoonTemplate {
    Name = 'StrikeForceSCTATerrain',
    Plan = 'SCTAArtyHuntAI', -- The platoon function to use.
    ---PlatoonType = 'Scout',
    GlobalSquads = {
        { ((categories.AMPHIBIOUS * GROUND) - SPECIAL) + categories.BOMB, -- ---PlatoonType of units.
          1, -- Min number of units.
          5, -- Max number of units.
          'Attack', -- platoon ---PlatoonTypes: 'support', 'Attack', 'scout',
          'none' }, -- platoon move formations: 'None', 'AttackFormation', 'GrowthFormation',
    },
}

PlatoonTemplate {
    Name = 'AttackForceSCTALaser',
    Plan = 'TAHunt', -- The platoon function to use.
    ---PlatoonType = 'Scout',
    GlobalSquads = {
        { ((GROUND * categories.ANTISHIELD) - categories.AMPHIBIOUS) - SPECIAL, 2, 10, 'Artillery', 'none' }, 
        { categories.FIELDENGINEER, 0, 2, 'Support', 'none' },
    },
}

PlatoonTemplate {
    Name = 'LABSCTA',
    Plan = 'HuntAILABSCTA', -- The platoon function to use.
    ---PlatoonType = 'Scout',
    GlobalSquads = {
        {RAIDER + RAIDAIR + ((categories.AMPHIBIOUS + categories.HOVER) - SPECIAL),
          1, -- Min number of units.
          1, -- Max number of units.
          'Attack', -- platoon ---PlatoonTypes: 'support', 'Attack', 'scout',
          'none' }, -- platoon move formations: 'None', 'AttackFormation', 'GrowthFormation',
    },
}

----Aggressive Platoons.
----Primary 'Defense' Platoon Protect Bases and Scout Around Mexes


---SCTA "Unique" Formations

PlatoonTemplate {
    Name = 'StrikeForceSCTAHover',
    Plan = 'TAHunt', -- The platoon function to use.
    ---PlatoonType = 'LandForm',
    GlobalSquads = {
        { ((GROUND * (categories.HOVER + categories.AMPHIBIOUS)) - SPECIAL) + categories.BOMB, 2, 10, 'Artillery', 'none' }, -- platoon move formations: 'None', 'AttackFormation', 'GrowthFormation',
    },
}

PlatoonTemplate {
    Name = 'LandRocketAttackSCTA',
    Plan = 'HuntSCTAAI',
    GlobalSquads = {
        { (GROUND * RANGE * categories.TECH1) - categories.AMPHIBIOUS, 2, 10, 'Artillery', 'none' },
    },
}


PlatoonTemplate {
    Name = 'LandAttackSCTAMid',
    Plan = 'AttackSCTAForceAI',
    GlobalSquads = {
        { (GROUND * RANGE) - categories.AMPHIBIOUS, 5, 20, 'Artillery', 'none' },
        { categories.FIELDENGINEER, 0, 2, 'Support', 'none' },
    },
}



PlatoonTemplate {
    Name = 'StrikeForceSCTAEarly',
    Plan = 'SCTAStrikeForceAIEarly',
    GlobalSquads = {
        { (GROUND * categories.TECH1) - SPECIAL - RANGE, 2, 10, 'Attack', 'none' }
    },
}

PlatoonTemplate {
    Name = 'StrikeForceSCTAMid',
    Plan = 'SCTAStrikeForceAI',
    GlobalSquads = {
        { GROUND - SPECIAL - RANGE, 5, 20, 'Attack', 'none' },
        { (GROUND * RANGE) - categories.ANTIAIR, 0, 10, 'Artillery', 'none' },
        { (GROUND * categories.ANTIAIR) - categories.ANTISHIELD, 0, 10, 'Scout', 'none' },
        { categories.FIELDENGINEER, 0, 2, 'Support', 'none' },
    },
}

PlatoonTemplate {
    Name = 'StrikeForceSCTAEndgame',
    Plan = 'SCTAStrikeForceAIEndgame', -- The platoon function to use.
    GlobalSquads = {
        { GROUND - SPECIAL - RANGE, 5, 30, 'Attack', 'none' },
        { (GROUND * RANGE) - categories.ANTIAIR, 0, 15, 'Artillery', 'none' },
        { (GROUND * categories.ANTIAIR) - categories.ANTISHIELD, 0, 15, 'Scout', 'none' },
        { categories.FIELDENGINEER, 0, 2, 'Support', 'none' },
    },
}


PlatoonTemplate {
    Name = 'T4ExperimentalSCTA',
    Plan = 'ExperimentalAIHubSorian', 
    ---PlatoonType = 'CommandTA',
    GlobalSquads = {
        { (categories.EXPERIMENTAL * categories.MOBILE) - categories.SUBCOMMANDER, 1, 1, 'Attack', 'none' }
    },
}

PlatoonTemplate {
    Name = 'SCTAExperimental',
    FactionSquads = {
        Arm = {
            { 'armdrake', 1, 1, 'Attack', 'none' },
        },
        Core = {
            { 'corkrog', 1, 1, 'Attack', 'none' },
        },
    }
}

PlatoonTemplate {
    Name = 'T2LandAntiArtySCTA',
    FactionSquads = {
        Arm = {
            { 'armamph', 1, 1, 'Attack', 'none' },
        },
        Core = {
            { 'coramph', 1, 1, 'Attack', 'none' },
        },
    }
}

PlatoonTemplate {
    Name = 'T1LandScoutSCTA',
    FactionSquads = {
        Arm = {
            { 'armck', 1, 1, 'Support', 'None' },
            { 'armflea', 1, 1, 'Scout', 'none' },
        },
        Core = {
            { 'corcv', 1, 1, 'Support', 'None' },
            { 'corfav', 1, 1, 'Scout', 'none' },
        },
    }
}

PlatoonTemplate {
    Name = 'T3LandHOVERSCTA',
    FactionSquads = {
        Arm = {
            { 'armanac', 1, 1, 'Attack', 'none' },
        },
        Core = {
            { 'corsnap', 1, 1, 'Attack', 'none' },
        },
    }
}


PlatoonTemplate {
    Name = 'T3HOVERAASCTA',
    FactionSquads = {
        Arm = {
            { 'armah', 1, 1, 'Attack', 'none' }
        },
        Core = {
            { 'corah', 1, 1, 'Attack', 'none' }
        },
    }
}

PlatoonTemplate {
    Name = 'T3HOVERTransportSCTA',
    FactionSquads = {
        Arm = {
            { 'armthovr', 1, 1, 'Support', 'GrowthFormation' }
        },
        Core = {
            { 'corthovr', 1, 1, 'Support', 'GrowthFormation' }
        },
    }
}

PlatoonTemplate {
    Name = 'T3HOVERMISSILESCTA',
    FactionSquads = {
        Arm = {
            { 'armmh', 1, 1, 'Attack', 'none' },
            { 'armsh', 1, 1, 'Attack', 'none' },
        },
        Core = {
            { 'cormh', 1, 1, 'Attack', 'none' },
            { 'corsh', 1, 1, 'Attack', 'none' },
        },
    }
}


