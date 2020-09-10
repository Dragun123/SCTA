#CORE Immolator - Plasma Tower
#CORPLAS
#
#Script created by Raevn

local TAunit = import('/mods/SCTAFix/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTAFix/lua/TAweapon.lua').TAweapon

CORPLAS = Class(TAunit) {
	Weapons = {
		CORPLAS_WEAPON = Class(TAweapon) {},
	},
}

TypeClass = CORPLAS
