#ARM Pirahna - Submarine Killer
#ARMSUBK
#
#Script created by Raevn

local TAunit = import('/mods/SCTA/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTA/lua/TAweapon.lua').TAweapon

CORSSUB = Class(TAunit) {
    Weapons = {
        ARMSMART_TORPEDO = Class(TAweapon) {
	},
    },
}


TypeClass = CORSSUB