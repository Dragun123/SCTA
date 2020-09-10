#CORE A.K. - Infantry Kbot
#CORAK
#
#Script created by Raevn

local TAWalking = import('/mods/SCTAFix/lua/TAWalking.lua').TAWalking
local TAweapon = import('/mods/SCTAFix/lua/TAweapon.lua').TAweapon

CORAK = Class(TAWalking) {
	
	Weapons = {
		CORE_LASER = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				
			end,
		},
	},
}

TypeClass = CORAK
