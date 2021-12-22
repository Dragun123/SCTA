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
            { 'armck', 1, 1, 'Support', 'None' }, 
            { 'armflash', 1, 2, 'Attack', 'none' },
        },
        Core = {
            { 'corcv', 1, 1, 'Support', 'None' },
            { 'corgator', 1, 2, 'Attack', 'none' },
        },
    }
}


PlatoonTemplate {
    Name = 'T1LandAASCTA2',
    FactionSquads = {
        Arm = {
            { 'armsam', 1, 1, 'Attack', 'none' },
        },
        Core = {
            { 'cormist', 1, 1, 'Attack', 'none' }
        },
    }
}

PlatoonTemplate {
    Name = 'T1LandDFTankSCTA2Early',
    FactionSquads = {
        Arm = {
            { 'armstump', 1, 2, 'Attack', 'none' },
        },
        Core = {
            { 'corraid', 1, 3, 'Attack', 'none' },
            { 'corcv', 1, 1, 'Support', 'None' },
        },
    }
}

PlatoonTemplate {
    Name = 'T1LandDFTankSCTA2',
    FactionSquads = {
        Arm = {
            { 'armstump', 1, 3, 'Attack', 'none' },
            { 'armck', 1, 1, 'Support', 'None' },
        },
        Core = {
            { 'corraid', 1, 2, 'Attack', 'none' },
        },
    }
}

PlatoonTemplate {
    Name = 'T2LandAuxFact2',
    FactionSquads = {
        Arm = {
            { 'armjam', 1, 1, 'Support', 'none' },
        },
        Core = {
            { 'coreter', 1, 1, 'Support', 'none' },
        },
    }
}

PlatoonTemplate {
    Name = 'T2LandAuxTerrain2',
    FactionSquads = {
        Arm = {
            { 'armcroc', 2, 1, 'Attack', 'none' },
            { 'armspid', 1, 1, 'Attack', 'none' },
        },
        Core = {
            { 'corseal', 1, 1, 'Attack', 'none' },
        },
    }
}

PlatoonTemplate {
    Name = 'T2LandMissileSCTA2',
    FactionSquads = {
        Arm = {
            { 'armmerl', 1, 1, 'Attack', 'none' },
        },
        Core = {
            { 'corvroc', 1, 1, 'Attack', 'none' },
            { 'cornecro', 1, 1, 'Support', 'None' },
        },
    }
}

PlatoonTemplate {
    Name = 'T2LandAASCTA2',
    FactionSquads = {
        Arm = {
            { 'armyork', 1, 1, 'Attack', 'none' },
            { 'armfark', 1, 1, 'Support', 'None' },
        },
        Core = {
            { 'corsent', 1, 1, 'Attack', 'none' },
        },
    }
}


PlatoonTemplate {
    Name = 'T2LandDFTank2SCTA',
    FactionSquads = {
        Arm = {
            { 'armbull', 1, 2, 'Attack', 'none' },
        },
        Core = {
            { 'correap', 1, 2, 'Attack', 'none' },
        },
    }
}

PlatoonTemplate {
    Name = 'T3LandDFTank2SCTA',
    FactionSquads = {
        Arm = {
            { 'armlatnk', 1, 1, 'Attack', 'none' },
        },
        Core = {
            { 'corgol', 1, 1, 'Attack', 'none' },
        },
    }
}

PlatoonTemplate {
    Name = 'T3LandDFVehicleSCTA',
    FactionSquads = {
        Arm = {
            { 'armmart', 1, 1, 'Attack', 'none' },
        },
        Core = {
            { 'cormart', 1, 1, 'Attack', 'none' },
        },
    }
}