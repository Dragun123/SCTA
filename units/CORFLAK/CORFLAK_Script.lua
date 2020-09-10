#ARM Flakker - Anti-Air Flak Gun
#ARMFLAK
#
#Script created by Raevn

local TAunit = import('/mods/SCTA/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTA/lua/TAweapon.lua').TAweapon

CORFLAK = Class(TAunit) {
	Weapons = {
		ARMFLAK_GUN = Class(TAweapon) {},
	},
}

TypeClass = CORFLAK
