#ARM Jeffy - Fast Attack Vehicle
#ARMFAV
#
#Blueprint created by Raevn

local TATreads = import('/mods/SCTAFix/lua/TATread.lua').TATreads
local TAweapon = import('/mods/SCTAFix/lua/TAweapon.lua').TAweapon

ARMFAV = Class(TATreads) {

	Weapons = {
		ARM_LASER = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
			end,
		},
	},
}

TypeClass = ARMFAV