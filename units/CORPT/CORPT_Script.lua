#CORE Searcher - Scout Ship
#CORPT
#
#Script created by Raevn

local TAunit = import('/mods/SCTAFix/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTAFix/lua/TAweapon.lua').TAweapon

CORPT = Class(TAunit) {
	Weapons = {
		CORPT_LASER = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				
			end,
		},
		CORKBOT_MISSILE = Class(TAweapon) {},
	},
}

TypeClass = CORPT
