#CORE The Can - Armored Assault Kbot
#CORCAN
#
#Script created by Raevn

local TAWalking = import('/mods/SCTA-master/lua/TAMotion.lua').TAWalking
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon


CORCAN = Class(TAWalking) {

	Weapons = {
		CORE_CANLASER = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				 #check flare time
			end,
		},
	},
}
TypeClass = CORCAN