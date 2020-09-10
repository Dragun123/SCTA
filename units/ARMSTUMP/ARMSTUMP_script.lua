#ARM Stumpy - Medium Assault Tank
#ARMSTUMP
#
#Blueprint created by Raevn

local TATreads = import('/mods/SCTA/lua/TATread.lua').TATreads
local TAweapon = import('/mods/SCTA/lua/TAweapon.lua').TAweapon

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