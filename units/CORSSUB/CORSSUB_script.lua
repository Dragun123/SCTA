#ARM Pirahna - Submarine Killer
#ARMSUBK
#
#Script created by Raevn

local TASeaCounter = import('/mods/SCTA-master/lua/TAMotion.lua').TASeaCounter
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon

CORSSUB = Class(TASeaCounter) {
    Weapons = {
        CORSMART_TORPEDO = Class(TAweapon) {
	},
    },
}


TypeClass = CORSSUB