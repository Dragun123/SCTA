#CORE Raider - Medium Assault Tank
#CORRAID
#
#Blueprint created by Raevn

local TAunit = import('/mods/SCTAFix/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTAFix/lua/TAweapon.lua').TAweapon

CORRAID = Class(TAunit) {

	Weapons = {
		CORE_LIGHTCANNON = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				
			end,
		},
	},
}
TypeClass = CORRAID