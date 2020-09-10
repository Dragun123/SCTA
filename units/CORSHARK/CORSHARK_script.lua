#CORE Shark - Submarine Killer
#CORSHARK
#
#Script created by Raevn

local TAunit = import('/mods/SCTAFix/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTAFix/lua/TAweapon.lua').TAweapon

CORSHARK = Class(TAunit) {
    Weapons = {
        CORSMART_TORPEDO = Class(TAweapon) {
	},
    },
}


TypeClass = CORSHARK