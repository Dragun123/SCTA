#COR Swatter - Anti-Air Hovercraft
#CORAH
#
#Script created by Raevn

local TAunit = import('/mods/SCTAFix/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTAFix/lua/TAweapon.lua').TAweapon

CORAH = Class(TAunit) {
	Weapons = {
		CORAH_WEAPON = Class(TAweapon) {}
	},
}

TypeClass = CORAH
