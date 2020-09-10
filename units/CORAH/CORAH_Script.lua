#COR Swatter - Anti-Air Hovercraft
#CORAH
#
#Script created by Raevn

local TAunit = import('/mods/SCTA/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTA/lua/TAweapon.lua').TAweapon

CORAH = Class(TAunit) {
	Weapons = {
		CORAH_WEAPON = Class(TAweapon) {}
	},
}

TypeClass = CORAH
