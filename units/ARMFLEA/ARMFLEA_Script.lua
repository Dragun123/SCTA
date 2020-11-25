#ARM Flea - Fast Light Scout Kbot
#ARMFLEA
#
#Script created by Raevn

local TAWalking = import('/mods/SCTA-master/lua/TAMotion.lua').TAWalking
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon


ARMFLEA = Class(TAWalking) {
	
	Weapons = {
		ARMFLEA_WEAPON = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				
			end,
		},
	},
}

TypeClass = ARMFLEA
