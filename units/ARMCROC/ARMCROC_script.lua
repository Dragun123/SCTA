#ARM Triton - Amphibious Tank
#ARMCROC
#
#Script created by Raevn

local TAunit = import('/mods/SCTAFix/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTAFix/lua/TAweapon.lua').TAweapon

ARMCROC = Class(TAunit) {

	Weapons = {
		ARM_MEDIUMCANNON = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				
			end,
		},
	},
}
TypeClass = ARMCROC