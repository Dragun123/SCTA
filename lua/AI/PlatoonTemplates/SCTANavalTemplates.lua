#***************************************************************************
#*
#**  File     :  /lua/ai/LandPlatoonTemplates.lua
#**
#**  Summary  : Global platoon templates
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
NAVY = (categories.NAVAL * categories.MOBILE)

PlatoonTemplate {
    Name = 'SCTAPatrolBoatAttack',
    Plan = 'ScoutingAISCTA',
    ---Type = 'SeaForm',
    GlobalSquads = {
        { NAVY * categories.LIGHTBOAT, 1, 1, 'Attack', 'GrowthFormation' },
    }
}

PlatoonTemplate {
    Name = 'SCTAPatrolBoatHunt',
    Plan = 'NavalHuntSCTAAI',
    --Type = 'SeaForm',
    GlobalSquads = {
        { NAVY * categories.LIGHTBOAT, 2, 10, 'Attack', 'GrowthFormation' },
    }
}

PlatoonTemplate {
    Name = 'SCTASubHunter',
    Plan = 'SubHuntSCTAAI',
    --Type = 'SeaForm',
    GlobalSquads = {
        { NAVY * categories.SUBMERSIBLE - categories.ENGINEER, 1, 2, 'Attack', 'GrowthFormation' },
    }
}

PlatoonTemplate {
    Name = 'SCTANavalAssault',
    Plan = 'NavalForceAI',
    --Type = 'SeaForm',
    GlobalSquads = {
        {NAVY - categories.ENGINEER - categories.NAVALCARRIER, 2, 10, 'Attack', 'GrowthFormation' },
    },
}

PlatoonTemplate {
    Name = 'SCTAAirCarrier',
    Plan = 'None',
    --Type = 'SeaForm',
    GlobalSquads = {
        {categories.NAVALCARRIER, 1, 1, 'Attack', 'GrowthFormation' }
    },
}

PlatoonTemplate {
    Name = 'T1ScoutShipSCTA',
    FactionSquads = {
        Arm = {
            { 'armpt', 1, 2, 'Attack', 'GrowthFormation'},
        },
        Core = {
            { 'corpt', 1, 2, 'Attack', 'GrowthFormation' },
        },
    }
}

PlatoonTemplate {
    Name = 'T1FrigateSCTA',
    FactionSquads = {
        Arm = {
            { 'armroy', 1, 2, 'Attack', 'GrowthFormation'},
            { 'armpt', 1, 1, 'Attack', 'GrowthFormation'},
        },
        Core = {
            { 'corroy', 1, 2, 'Attack', 'GrowthFormation'},
            { 'corpt', 1, 1, 'Attack', 'GrowthFormation' },
        },
    }
}

PlatoonTemplate {
    Name = 'T2DestroyerSCTA',
    FactionSquads = {
        Arm = {
            { 'armcrus', 1, 1, 'Attack', 'GrowthFormation'},
            { 'armpt', 1, 2, 'Attack', 'GrowthFormation' },
        },
        Core = {
            { 'corcrus', 1, 1, 'Attack', 'GrowthFormation'},
            { 'corpt', 1, 2, 'Attack', 'GrowthFormation' },
        },
    }
}

PlatoonTemplate {
    Name = 'T2SubSCTA',
    FactionSquads = {
        Arm = {
            { 'armsubk', 1, 1, 'Attack', 'GrowthFormation'},
        },
        Core = {
            { 'corshark', 1, 1, 'Attack', 'GrowthFormation'},
        },
    }
}

PlatoonTemplate {
    Name = 'T1SubSCTA',
    FactionSquads = {
        Arm = {
            { 'armsub', 1, 1, 'Attack', 'GrowthFormation'},
        },
        Core = {
            { 'corsub', 1, 1, 'Attack', 'GrowthFormation'},
        },
    }
}

PlatoonTemplate {
    Name = 'T2CrusSCTA',
    FactionSquads = {
        Arm = {
            { 'armaas', 1, 1, 'Attack', 'GrowthFormation'},
            { 'armpt', 1, 2, 'Attack', 'GrowthFormation' },
        },
        Core = {
            { 'corarch', 1, 1, 'Attack', 'GrowthFormation'},
            { 'corpt', 1, 2, 'Attack', 'GrowthFormation' },
        },
    }
}

PlatoonTemplate {
    Name = 'BattleshipSCTA',
    FactionSquads = {
        Arm = {
            { 'armbats', 1, 1, 'Attack', 'GrowthFormation'},
            { 'armpt', 1, 4, 'Attack', 'GrowthFormation' },
            { 'armacsub', 1, 1, 'support', 'None' },
        },
        Core = {
            { 'corbats', 1, 1, 'Attack', 'GrowthFormation'},
            { 'corpt', 1, 4, 'Attack', 'GrowthFormation' },
            { 'coracsub', 1, 1, 'support', 'None' },
        },
    }
}

PlatoonTemplate {
    Name = 'MissileshipSCTA',
    FactionSquads = {
        Arm = {
            { 'armmship', 1, 1, 'Attack', 'GrowthFormation'},
        },
        Core = {
            { 'cormship', 1, 1, 'Attack', 'GrowthFormation'},
        },
    }
}

PlatoonTemplate {
    Name = 'CarrySCTA',
    FactionSquads = {
        Arm = {
            { 'armcarry', 1, 1, 'attack', 'GrowthFormation' }
        },
        Core = {
            { 'corcarry', 1, 1, 'attack', 'GrowthFormation' }
        },
    }
}