#ARM Stumpy - Medium Assault Tank
#ARMSTUMP
#
#Blueprint created by Raevn

local TATreads = import('/mods/SCTAFix/lua/TATread.lua').TATreads
local TAweapon = import('/mods/SCTAFix/lua/TAweapon.lua').TAweapon

ARMSTUMP = Class(TATreads) {

	Weapons = {
		ARM_LIGHTCANNON = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				
			end,
		},
	},
}
TypeClass = ARMSTUMP