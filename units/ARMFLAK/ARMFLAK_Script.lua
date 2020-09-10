#ARM Flakker - Anti-Air Flak Gun
#ARMFLAK
#
#Script created by Raevn

local TAunit = import('/mods/SCTAFix/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTAFix/lua/TAweapon.lua').TAweapon

ARMFLAK = Class(TAunit) {
	Weapons = {
		ARMFLAK_GUN = Class(TAweapon) {},
	},
}

TypeClass = ARMFLAK
