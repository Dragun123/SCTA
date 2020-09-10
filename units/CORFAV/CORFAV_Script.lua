#CORE Weasel - Scout
#CORFAV
#
#Blueprint created by Raevn

local TATreads = import('/mods/SCTAFix/lua/TATread.lua').TATreads
local TAweapon = import('/mods/SCTAFix/lua/TAweapon.lua').TAweapon

CORFAV = Class(TATreads) {

	Weapons = {
		CORE_LASER = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
			end,
		},
	},
}

TypeClass = CORFAV