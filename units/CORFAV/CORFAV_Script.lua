#CORE Weasel - Scout
#CORFAV
#
#Blueprint created by Raevn

local TATreads = import('/mods/SCTA-master/lua/TAMotion.lua').TATreads
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon

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