#CORE Weasel - Scout
#CORFAV
#
#Blueprint created by Raevn

local TATreads = import('/mods/SCTA/lua/TATread.lua').TATreads
local TAweapon = import('/mods/SCTA/lua/TAweapon.lua').TAweapon

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