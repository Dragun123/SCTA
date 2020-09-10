#ARM Stingray - Floating Heavy Laser Tower
#ARMFHLT
#
#Script created by Raevn

local TAunit = import('/mods/SCTA/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTA/lua/TAweapon.lua').TAweapon

CORFHLT = Class(TAunit) {
	Weapons = {
		CORFHLT_LASER = Class(TAweapon) {},
	},
}

TypeClass = CORFHLT
