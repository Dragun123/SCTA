#ARM Warrior - Medium Infantry Kbot
#ARMWAR
#
#Script created by Raevn

local TAunit = import('/mods/SCTA/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTA/lua/TAweapon.lua').TAweapon

ARMWAR = Class(TAunit) {
	
	Weapons = {
		ARMWAR_EMG = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				
			end,
		},
		ARMWAR_LCANNON = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				
			end,
		},
	},
}

TypeClass = ARMWAR
