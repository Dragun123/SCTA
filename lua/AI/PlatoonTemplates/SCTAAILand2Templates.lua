#***************************************************************************
#*
#**  File     :  /lua/ai/LandPlatoonTemplates.lua
#**
#**  Summary  : Global platoon templates
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
-----SecondaryLand

PlatoonTemplate {
    Name = 'T1LandDFBotSCTA2',
    FactionSquads = {
        Arm = {
            { 'armck', 1, 1, 'support', 'None' }, 
            { 'armflash', 1, 2, 'attack', 'none' },
        },
        Core = {
            { 'corcv', 1, 1, 'support', 'None' },
            { 'corgator', 1, 2, 'attack', 'none' },
        },
    }
}

PlatoonTemplate {
    Name = 'T1LandScoutSCTA2',
    FactionSquads = {
        Arm = {
            { 'armfav', 1, 1, 'scout', 'none' }
        },
        Core = {
            { 'corcv', 1, 1, 'support', 'None' },
            { 'corfav', 1, 1, 'scout', 'none' },
        },
    }
}



PlatoonTemplate {
    Name = 'T1LandAASCTA2',
    FactionSquads = {
        Arm = {
            { 'armsam', 1, 1, 'attack', 'none' },
        },
        Core = {
            { 'cormist', 1, 1, 'attack', 'none' }
        },
    }
}

PlatoonTemplate {
    Name = 'T1LandDFTankSCTA2Early',
    FactionSquads = {
        Arm = {
            { 'armstump', 1, 2, 'attack', 'none' },
        },
        Core = {
            { 'corraid', 1, 2, 'attack', 'none' },
            { 'corcv', 1, 1, 'support', 'None' },
        },
    }
}

PlatoonTemplate {
    Name = 'T1LandDFTankSCTA2',
    FactionSquads = {
        Arm = {
            { 'armstump', 1, 2, 'attack', 'none' },
            { 'armck', 1, 1, 'support', 'None' },
        },
        Core = {
            { 'corraid', 1, 2, 'attack', 'none' },
        },
    }
}

PlatoonTemplate {
    Name = 'T2LandAuxFact2',
    FactionSquads = {
        Arm = {
            { 'armjam', 1, 1, 'support', 'none' },
        },
        Core = {
            { 'coreter', 1, 1, 'support', 'none' },
        },
    }
}

PlatoonTemplate {
    Name = 'T2LandAuxTerrain2',
    FactionSquads = {
        Arm = {
            { 'armcroc', 1, 1, 'attack', 'none' },
        },
        Core = {
            { 'corseal', 1, 1, 'attack', 'none' },
        },
    }
}

PlatoonTemplate {
    Name = 'T2LandMissileSCTA2',
    FactionSquads = {
        Arm = {
            { 'armmerl', 1, 1, 'attack', 'none' },
            { 'armack', 1, 1, 'support', 'None' },
        },
        Core = {
            { 'corvroc', 1, 1, 'attack', 'none' },
            { 'cornecro', 1, 1, 'support', 'None' },
        },
    }
}

PlatoonTemplate {
    Name = 'T2LandAASCTA2',
    FactionSquads = {
        Arm = {
            { 'armyork', 1, 1, 'attack', 'none' },
        },
        Core = {
            { 'corsent', 1, 1, 'attack', 'none' }
        },
    }
}


PlatoonTemplate {
    Name = 'T2LandDFTank2SCTA',
    FactionSquads = {
        Arm = {
            { 'armlatnk', 1, 3, 'attack', 'none' },
        },
        Core = {
            { 'correap', 1, 3, 'attack', 'none' },
        },
    }
}

PlatoonTemplate {
    Name = 'T3LandDFTank2SCTA',
    FactionSquads = {
        Arm = {
            { 'armbull', 1, 3, 'attack', 'none' },
        },
        Core = {
            { 'corgol', 1, 3, 'attack', 'none' },
        },
    }
}

PlatoonTemplate {
    Name = 'T3LandDFVehicleSCTA',
    FactionSquads = {
        Arm = {
            { 'armmart', 1, 1, 'attack', 'none' },
        },
        Core = {
            { 'cormart', 1, 1, 'attack', 'none' },
        },
    }
}