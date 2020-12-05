#ARM Phalanx - Mobile Flak Vehicle
#ARMYORK
#
#Script created by Raevn

local TATreads = import('/mods/SCTA-master/lua/TAMotion.lua').TATreads
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon

CORSENT = Class(TATreads) {

	OnCreate = function(self)
		TATreads.OnCreate(self)
	end,

	Weapons = {
		ARMYORK_GUN = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				
			end,
		},
	},

	OnMotionHorzEventChange = function(self, new, old )
		TATreads.OnMotionHorzEventChange(self, new, old)
	end,
}

TypeClass = CORSENT
