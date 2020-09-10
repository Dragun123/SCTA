#ARM Stingray - Floating Heavy Laser Tower
#ARMFHLT
#
#Script created by Raevn

local TAunit = import('/mods/SCTAFix/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTAFix/lua/TAweapon.lua').TAweapon

CORFHLT = Class(TAunit) {
	Weapons = {
		CORFHLT_LASER = Class(TAweapon) {},
	},
}

TypeClass = CORFHLT
