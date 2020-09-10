#ARM Torpedo Launcher - Torpedo Launcher
#ARMTL
#
#Script created by Raevn

local TAunit = import('/mods/SCTAFix/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTAFix/lua/TAweapon.lua').TAweapon

ARMTL = Class(TAunit) {

    Weapons = {
         COAX_TORPEDO = Class(TAweapon) {},
    },

}

TypeClass = ARMTL