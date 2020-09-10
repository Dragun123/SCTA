#ARM Penetrator - Mobile Energy Weapon
#ARMMANNI
#
#Script created by Raevn

local TAunit = import('/mods/SCTAFix/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTAFix/lua/TAweapon.lua').TAweapon

ARMMANNI = Class(TAunit) {

	Weapons = {
		ARMMANNI_WEAPON = Class(TAweapon) {},
	},
}
TypeClass = ARMMANNI
