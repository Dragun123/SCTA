#ARM Conqueror - Cruiser
#ARMCRUS
#
#Script created by Raevn

local TAunit = import('/mods/SCTAFix/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTAFix/lua/TAweapon.lua').TAweapon

ARMCRUS = Class(TAunit) {
	Weapons = {
		ARM_CRUS = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				
			end,
		},
		ARMDEPTHCHARGE = Class(TAweapon) {},
	},
}

TypeClass = ARMCRUS
