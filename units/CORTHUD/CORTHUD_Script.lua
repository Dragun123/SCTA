#CORE Thud - Artillery Kbot
#CORTHUD
#
#Script created by Raevn

local TAunit = import('/mods/SCTAFix/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTAFix/lua/TAweapon.lua').TAweapon

CORTHUD = Class(TAunit) {
	

	Weapons = {
		CORE_THUD = Class(TAweapon) {

			OnWeaponFired = function(self)
				
				TAweapon.OnWeaponFired(self)
			end,
		},
	},
}

TypeClass = CORTHUD