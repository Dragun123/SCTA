#ARM Lurker - Submarine
#ARMCRUS
#
#Script created by Raevn

local TAunit = import('/mods/SCTAFix/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTAFix/lua/TAweapon.lua').TAweapon

ARMSUB = Class(TAunit) {
    Weapons = {
        ARM_TORPEDO = Class(TAweapon) {
	},
    },
}


TypeClass = ARMSUB