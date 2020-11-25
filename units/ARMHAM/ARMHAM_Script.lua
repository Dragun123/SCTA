#ARM Hammer - Artillery Kbot
#ARMHAM
#
#Script created by Raevn

local TAWalking = import('/mods/SCTA-master/lua/TAMotion.lua').TAWalking
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon

ARMHAM = Class(TAWalking) {
	

	Weapons = {
		ARM_HAM = Class(TAweapon) {
			OnWeaponFired = function(self)		
				TAweapon.OnWeaponFired(self)
			end,
		},
	},
}

TypeClass = ARMHAM
