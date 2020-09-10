#CORE Enforcer - Destroyer
#CORROY
#
#Script created by Raevn

local TAunit = import('/mods/SCTAFix/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTAFix/lua/TAweapon.lua').TAweapon

CORROY = Class(TAunit) {
	Weapons = {
		CORE_ROY = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				
			end,
		},
		COREDEPTHCHARGE = Class(TAweapon) {},
	},
}

TypeClass = CORROY
