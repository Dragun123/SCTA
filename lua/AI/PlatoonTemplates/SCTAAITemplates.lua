--[[
    File    :   /lua/AI/PlattonTemplates/SCTAAITemplates.lua
    Author  :   SoftNoob
    Summary :
        Responsible for defining a mapping from AIBuilders keys -> Plans (Plans === platoon.lua functions)
]]
local RAIDAIR = (categories.armfig + categories.corveng + categories.GROUNDATTACK)
local RAIDER = (categories.armpw + categories.corak + categories.armflash + categories.corgator)
local SPECIAL = (RAIDER + categories.EXPERIMENTAL + categories.ENGINEER + categories.SCOUT)
local GROUND = categories.MOBILE * categories.LAND
local TACATS = (categories.ANTISHIELD + (categories.AMPHIBIOUS - categories.BOMB))
local RANGE = (categories.ARTILLERY + categories.SILO + categories.ANTIAIR + categories.SNIPER + categories.BOMB)

PlatoonTemplate {
    Name = 'T1LandScoutFormSCTA',
    Plan = 'ScoutingAISCTA',
    ---PlatoonType = 'Scout',
    GlobalSquads = {
        { GROUND * categories.SCOUT, 1, 1, 'scout', 'none' },
    }
}

PlatoonTemplate {
    Name = 'GuardSCTA',
    Plan = 'None',
    ---PlatoonType = 'Scout',
    GlobalSquads = {
        { GROUND - SPECIAL, 1, 1, 'guard', 'none' }
    },
}

PlatoonTemplate {
    Name = 'StrikeForceSCTATerrain',
    Plan = 'SCTAArtyHuntAI', -- The platoon function to use.
    ---PlatoonType = 'Scout',
    GlobalSquads = {
        { categories.AMPHIBIOUS * categories.LAND - SPECIAL, -- ---PlatoonType of units.
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
        { (GROUND * categories.ANTISHIELD - categories.AMPHIBIOUS - categories.EXPERIMENTAL) + categories.FIELDENGINEER, -- ---PlatoonType of units.
          2, -- Min number of units.
          10, -- Max number of units.
          'Attack', -- platoon ---PlatoonTypes: 'support', 'Attack', 'scout',
          'none' }, -- platoon move formations: 'None', 'AttackFormation', 'GrowthFormation',
    },
}

PlatoonTemplate {
    Name = 'LABSCTA',
    Plan = 'HuntAILABSCTA', -- The platoon function to use.
    ---PlatoonType = 'Scout',
    GlobalSquads = {
        {RAIDER + RAIDAIR + (categories.AMPHIBIOUS - categories.COMMAND), -- ---PlatoonType of units.
          1, -- Min number of units.
          1, -- Max number of units.
          'Attack', -- platoon ---PlatoonTypes: 'support', 'Attack', 'scout',
          'none' }, -- platoon move formations: 'None', 'AttackFormation', 'GrowthFormation',
    },
}

----Aggressive Platoons.
----Primary 'Defense' Platoon Protect Bases and Scout Around Mexes
PlatoonTemplate {
    Name = 'AntiAirSCTA',
    Plan = 'SCTAStrikeForceAI', -- The platoon function to use.
    ---PlatoonType = 'LandForm',
    GlobalSquads = {
        { GROUND * categories.ANTIAIR - categories.ANTISHIELD, 2, 20, 'Artillery', 'none' },
    },
}

---SCTA "Unique" Formations

PlatoonTemplate {
    Name = 'StrikeForceSCTAHover',
    Plan = 'TAHunt', -- The platoon function to use.
    ---PlatoonType = 'LandForm',
    GlobalSquads = {
        { GROUND * (categories.HOVER + categories.AMPHIBIOUS) - categories.COMMAND, 2, 10, 'Attack', 'none' }, -- platoon move formations: 'None', 'AttackFormation', 'GrowthFormation',
    },
}

PlatoonTemplate {
    Name = 'LandRocketAttackSCTA',
    Plan = 'HuntSCTAAI',
    GlobalSquads = {
        { (GROUND * RANGE * categories.TECH1) + categories.FIELDENGINEER, 2, 10, 'Artillery', 'none' }
    },
}


PlatoonTemplate {
    Name = 'LandAttackSCTAMid',
    Plan = 'AttackSCTAForceAI',
    GlobalSquads = {
        { (GROUND * RANGE) + categories.FIELDENGINEER, 5, 20, 'Artillery', 'none' }
    },
}



PlatoonTemplate {
    Name = 'StrikeForceSCTAEarly',
    Plan = 'SCTAStrikeForceAIEarly',
    GlobalSquads = {
        { GROUND * categories.TECH1 - SPECIAL, 2, 10, 'Attack', 'none' }
    },
}

PlatoonTemplate {
    Name = 'StrikeForceSCTAMid',
    Plan = 'SCTAStrikeForceAI',
    GlobalSquads = {
        { GROUND - SPECIAL, 5, 20, 'Attack', 'none' },
        { (GROUND * RANGE) + categories.FIELDENGINEER, 0, 10, 'Artillery', 'none' },
    },
}

PlatoonTemplate {
    Name = 'StrikeForceSCTAEndgame',
    Plan = 'SCTAStrikeForceAIEndgame', -- The platoon function to use.
    GlobalSquads = {
        { GROUND - SPECIAL, 5, 30, 'Attack', 'none' },
        { (GROUND * RANGE) + categories.FIELDENGINEER, 0, 15, 'Artillery', 'none' },
    },
}


PlatoonTemplate {
    Name = 'T4ExperimentalSCTA',
    Plan = 'ExperimentalAIHubSorian', 
    ---PlatoonType = 'CommandTA',
    GlobalSquads = {
        { categories.EXPERIMENTAL * categories.MOBILE - categories.SUBCOMMANDER, 1, 1, 'Attack', 'none' }
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
    Name = 'T1LandAntiArtySCTA',
    FactionSquads = {
        Arm = {
            { 'armjeth', 1, 1, 'Attack', 'none' },
        },
        Core = {
            { 'corlevlr', 1, 1, 'Attack', 'none' },
        },
    }
}

PlatoonTemplate {
    Name = 'T2LandAuxTerrain',
    FactionSquads = {
        Arm = {
            { 'armspid', 1, 1, 'Attack', 'none' },
        },
        Core = {
            { 'coramph', 1, 1, 'Attack', 'none' },
        },
    }
}

PlatoonTemplate {
    Name = 'T3LandDFBotSCTA',
    FactionSquads = {
        Arm = {
            { 'armsnipe', 1, 1, 'Attack', 'none' },
        },
        Core = {
            { 'cormort', 1, 1, 'Attack', 'none' },
        },
    }
}

PlatoonTemplate {
    Name = 'T3LandHOVERSCTA',
    FactionSquads = {
        Arm = {
            { 'armanac', 1, 1, 'Attack', 'none' },
            { 'armsh', 1, 1, 'Attack', 'none' },
        },
        Core = {
            { 'corsnap', 1, 1, 'Attack', 'none' },
            { 'corsh', 1, 1, 'Attack', 'none' },
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
    Name = 'T3HOVERMISSILESCTA',
    FactionSquads = {
        Arm = {
            { 'armmh', 1, 1, 'Attack', 'none' }
        },
        Core = {
            { 'cormh', 1, 1, 'Attack', 'none' }
        },
    }
}


