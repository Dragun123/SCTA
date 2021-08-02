#ARM Panther - Lightning Tank
#ARMLATNK
#
#Script created by Raevn

local TAunit = import('/mods/SCTA-master/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon

ARMLATNK = Class(TAunit) {
	Weapons = {
		WEAPON = Class(TAweapon) {},
	},
}

TypeClass = ARMLATNK
