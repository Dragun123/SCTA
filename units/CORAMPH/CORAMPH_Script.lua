#ARM Pelican - Amphibious Kbot
#ARMAMPH
#
#Script created by Axle

local TAunit = import('/mods/SCTAFix/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTAFix/lua/TAweapon.lua').TAweapon

CORAMPH = Class(TAunit) {

	Weapons = {
		armamph_weapon2 = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				
			end,
		},
	},
}

TypeClass = CORAMPH
