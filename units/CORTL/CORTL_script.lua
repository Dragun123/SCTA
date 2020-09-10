#CORE Torpedo Launcher - Torpedo Launcher
#CORTL
#
#Script created by Raevn

local TAunit = import('/mods/SCTAFix/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTAFix/lua/TAweapon.lua').TAweapon

CORTL = Class(TAunit) {

    Weapons = {
         COAX_TORPEDO = Class(TAweapon) {},
    },

}

TypeClass = CORTL