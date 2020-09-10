#ARM Sentinel - Heavy Laser Tower
#ARMHLT
#
#Script created by Raevn

local TAunit = import('/mods/SCTAFix/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTAFix/lua/TAweapon.lua').TAweapon

ARMHLT = Class(TAunit) {
	Weapons = {
		ARM_LASERH1 = Class(TAweapon) {},
	},
}

TypeClass = ARMHLT
