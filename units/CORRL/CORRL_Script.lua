#CORE Pulverizer - Missile Tower
#CORRL
#
#Script created by Raevn

local TAunit = import('/mods/SCTAFix/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTAFix/lua/TAweapon.lua').TAweapon

CORRL = Class(TAunit) {

	Weapons = {
		CORRL_MISSILE = Class(TAweapon) {},
	},
}

TypeClass = CORRL
