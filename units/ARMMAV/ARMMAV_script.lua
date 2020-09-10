#ARM Fido - Assault Kbot
#ARMFIDO
#
#Script created by Raevn

local TAunit = import('/mods/SCTA/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTA/lua/TAweapon.lua').TAweapon

ARMMAV = Class(TAunit) {
	Weapons = {
		EMG = Class(TAweapon) {
		OnWeaponFired = function(self)
			TAweapon.OnWeaponFired(self)
		end,
	},
	},
}
TypeClass = ARMMAV