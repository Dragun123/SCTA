#ARM Stumpy - Medium Assault Tank
#ARMSTUMP
#
#Blueprint created by Raevn

local TAWalking = import('/mods/SCTA-master/lua/TAMotion.lua').TAWalking
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon

CORMORT = Class(TAWalking) {

	Weapons = {
		CORE_MORT = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				 #check flare time
			end,
		},
	},
}
TypeClass = CORMORT