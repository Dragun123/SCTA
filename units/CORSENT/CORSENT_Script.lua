#ARM Phalanx - Mobile Flak Vehicle
#ARMYORK
#
#Script created by Raevn

local TAunit = import('/mods/SCTA-master/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon

CORSENT = Class(TAunit) {

	OnCreate = function(self)
		TAunit.OnCreate(self)
	end,

	Weapons = {
		ARMYORK_GUN = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				
			end,
		},
	},

	OnMotionHorzEventChange = function(self, new, old )
		TAunit.OnMotionHorzEventChange(self, new, old)
	end,
}

TypeClass = CORSENT
