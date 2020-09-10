#CORE Storm - Rocket Kbot
#CORSTORM
#
#Script created by Raevn

local TAunit = import('/mods/SCTAFix/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTAFix/lua/TAweapon.lua').TAweapon

CORSTORM = Class(TAunit) {
	Weapons = {
		CORKBOT_ROCKET = Class(TAweapon) {},
	},
}

TypeClass = CORSTORM
