#***************************************************************************
#*
#**  File     :  /lua/ai/LandPlatoonTemplates.lua
#**
#**  Summary  : Global platoon templates
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
SKY = categories.AIR * categories.MOBILE
STEALTH = categories.armhawk + categories.corvamp

PlatoonTemplate {
    Name = 'SCTATorpedosBombers',
    Plan = 'BomberAISCTANaval',
    --Type = 'SeaForm',
    GlobalSquads = {
        { SKY * categories.BOMBER * categories.ANTINAVY, 1, 10, 'Attack', 'GrowthFormation' },
    }
}

PlatoonTemplate {
    Name = 'SCTABomberAttack',
    Plan = 'BomberAISCTA',
    ---PlatoonType = 'Scout',
    GlobalSquads = {
        { SKY * (categories.GROUNDATTACK + categories.BOMBER) - categories.ANTINAVY, 1, 100, 'Attack', 'GrowthFormation' },
    }
}

PlatoonTemplate {
    Name = 'IntieAISCTA',
    Plan = 'InterceptorAISCTA',
    ---PlatoonType = 'AirForm',
    GlobalSquads = {
        { SKY * categories.ANTIAIR * categories.TECH1 - categories.BOMBER, 2, 100, 'Attack', 'none' },
    }
}

PlatoonTemplate {
    Name = 'IntieAISCTAEnd',
    Plan = 'InterceptorAISCTAEnd',
    ---PlatoonType = 'AirForm',
    GlobalSquads = {
        { SKY * categories.ANTIAIR - categories.BOMBER - categories.GROUNDATTACK, 2, 100, 'Attack', 'none' },
    }
}

PlatoonTemplate {
    Name = 'IntieAIStealthSCTA',
    Plan = 'InterceptorAISCTAStealth',
    ---PlatoonType = 'AirForm',
    GlobalSquads = {
        { (SKY * (categories.BOMBER + categories.GROUNDATTACK) - categories.ANTINAVY), 1, 100, 'Attack', 'GrowthFormation' },
        { STEALTH, 0, 10, 'Artillery', 'GrowthFormation' },
    }
}

PlatoonTemplate {
    Name = 'T1AirScoutFormSCTA',
    Plan = 'ScoutingAISCTA',
    ---PlatoonType = 'Scout',
    GlobalSquads = {
        { SKY * categories.SCOUT * categories.OVERLAYRADAR, 1, 1, 'Scout', 'None' },
    }
}

PlatoonTemplate {
    Name = 'T1AirScoutSCTA',
    FactionSquads = {
        Arm = {
            { 'armpeep', 1, 1, 'Scout', 'GrowthFormation' },
            { 'armca', 1, 1, 'Support', 'None' },
        },
        Core = {
            { 'corfink', 1, 1, 'Scout', 'GrowthFormation' },
            { 'corca', 1, 1, 'Support', 'None' },
        },
    }
}

PlatoonTemplate {
    Name = 'T1AirFighterSCTA',
    FactionSquads = {
        Arm = {
            { 'armfig', 1, 1, 'Attack', 'GrowthFormation' },
        },
        Core = {
            { 'corveng', 1, 1, 'Attack', 'GrowthFormation' },
        },
    }
}

PlatoonTemplate {
    Name = 'T1AirBomberSCTA',
    FactionSquads = {
        Arm = {
            { 'armthund', 1, 1, 'Attack', 'GrowthFormation' },
        },
        Core = {
            { 'corshad', 1, 1, 'Attack', 'GrowthFormation' },
        },
    }
}


PlatoonTemplate {
    Name = 'T2AirFighterSCTA',
    FactionSquads = {
        Arm = {
            { 'armhawk', 1, 1, 'Attack', 'GrowthFormation' },
        },
        Core = {
            { 'corvamp', 1, 1, 'Attack', 'GrowthFormation' },
        },
    }
}

PlatoonTemplate {
    Name = 'T2GunshipSCTA',
    FactionSquads = {
        Arm = {
            { 'armbrawl', 1, 1, 'Attack', 'GrowthFormation' },
        },
        Core = {
            { 'corape', 1, 1, 'Attack', 'GrowthFormation' },
        },
    }
}

PlatoonTemplate {
    Name = 'T3AirBomberSCTA',
    FactionSquads = {
        Arm = {
            { 'armpnix', 1, 1, 'Attack', 'GrowthFormation' },
        },
        Core = {
            { 'corhurc', 1, 1, 'Attack', 'GrowthFormation' },
        },
    }
}

PlatoonTemplate {
    Name = 'T2AirScoutSCTA',
    FactionSquads = {
        Arm = {
            { 'armawac', 1, 1, 'Scout', 'GrowthFormation' },
            { 'armhawk', 1, 2, 'Attack', 'GrowthFormation' },
            { 'armaca', 1, 1, 'Support', 'None' },
        },
        Core = {
            { 'corawac', 1, 1, 'Scout', 'GrowthFormation' },
            { 'corvamp', 1, 2, 'Attack', 'GrowthFormation' },
            { 'coraca', 1, 1, 'Support', 'None' },
        },
    }
}

PlatoonTemplate {
    Name = 'T3AirFighterSCTA',
    FactionSquads = {
        Arm = {
            { 'armsfig', 1, 1, 'Attack', 'GrowthFormation' },
        },
        Core = {
            { 'corsfig', 1, 1, 'Attack', 'GrowthFormation' },
        },
    }
}

PlatoonTemplate {
    Name = 'SCTATransport',
    FactionSquads = {
        Arm = {
            { 'armatlas', 1, 1, 'Support', 'GrowthFormation' }
        },
        Core = {
            { 'corvalk', 1, 1, 'Support', 'GrowthFormation' }
        },
    }
}

PlatoonTemplate {
    Name = 'SCTATorpedosBomber',
    FactionSquads = {
        Arm = {
            { 'armlance', 1, 1, 'Attack', 'GrowthFormation' }
        },
        Core = {
            { 'cortitan', 1, 1, 'Attack', 'GrowthFormation' }
        },
    }
}

PlatoonTemplate {
    Name = 'SCTATorpedosBomberT3',
    FactionSquads = {
        Arm = {
            { 'armseap', 1, 1, 'Attack', 'GrowthFormation' }
        },
        Core = {
            { 'corseap', 1, 1, 'Attack', 'GrowthFormation' }
        },
    }
}