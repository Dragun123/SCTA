#ARM Skeeter - Scout Ship
#ARMPT
#
#Script created by Raevn

local TAunit = import('/mods/SCTAFix/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTAFix/lua/TAweapon.lua').TAweapon

ARMPT = Class(TAunit) {
	Weapons = {
		ARMPT_LASER = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				
			end,
		},
		ARMKBOT_MISSILE = Class(TAweapon) {},
	},
}

TypeClass = ARMPT
