#ARM Fido - Assault Kbot
#ARMFIDO
#
#Script created by Raevn


local TAWalking = import('/mods/SCTA-master/lua/TAMotion.lua').TAWalking
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon


ARMFIDO = Class(TAWalking) {

	Weapons = {
		GAUSS = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				
			end,
		},
	},
}
TypeClass = ARMFIDO