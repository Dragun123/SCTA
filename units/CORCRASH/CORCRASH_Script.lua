#COR Crasher - Missile Kbot
#CORCRASH
#
#Script created by Raevn

local TAunit = import('/mods/SCTAFix/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTAFix/lua/TAweapon.lua').TAweapon

CORCRASH = Class(TAunit) {
	Weapons = {
		CORKBOT_MISSILE = Class(TAweapon) {},
	},
}

TypeClass = CORCRASH
