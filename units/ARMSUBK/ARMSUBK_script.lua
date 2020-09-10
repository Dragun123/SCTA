#ARM Pirahna - Submarine Killer
#ARMSUBK
#
#Script created by Raevn

local TAunit = import('/mods/SCTAFix/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTAFix/lua/TAweapon.lua').TAweapon

ARMSUBK = Class(TAunit) {
    Weapons = {
        ARMSMART_TORPEDO = Class(TAweapon) {
	},
    },
}


TypeClass = ARMSUBK