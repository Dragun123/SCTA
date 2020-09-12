#ARM Pelican - Amphibious Kbot
#ARMAMPH
#
#Script created by Axle

local TAWalking = import('/mods/SCTA-master/lua/TAWalking.lua').TAWalking
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon

ARMAMPH = Class(TAWalking) {

	Weapons = {
		armamph_weapon1 = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				
			end,
		},
		armamph_weapon2 = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				
			end,
		},
	},

}

TypeClass = ARMAMPH
