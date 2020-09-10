#ARM Jeffy - Fast Attack Vehicle
#ARMFAV
#
#Blueprint created by Raevn

local TATreads = import('/mods/SCTA/lua/TATread.lua').TATreads
local TAweapon = import('/mods/SCTA/lua/TAweapon.lua').TAweapon

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