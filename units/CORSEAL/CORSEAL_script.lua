#CORE Crock - Amphibious Tank
#CORSEAL
#
#Script created by Raevn

local TATreads = import('/mods/SCTA-master/lua/TAMotion.lua').TATreads
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon

CORSEAL = Class(TATreads) {

	Weapons = {
		CORE_MEDIUMCANNON = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				
			end,
		},
	},
}
TypeClass = CORSEAL