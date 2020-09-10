#ARM Crusader - Destroyer
#ARMROY
#
#Script created by Raevn

local TAunit = import('/mods/SCTAFix/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTAFix/lua/TAweapon.lua').TAweapon

ARMROY = Class(TAunit) {
	Weapons = {
		ARM_ROY = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				
			end,
		},
		ARMDEPTHCHARGE = Class(TAweapon) {},
	},
}

TypeClass = ARMROY
