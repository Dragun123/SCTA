#CORE A.K. - Infantry Kbot
#CORAK
#
#Script created by Raevn

local TAWalking = import('/mods/SCTA/lua/TAWalking.lua').TAWalking
local TAweapon = import('/mods/SCTA/lua/TAweapon.lua').TAweapon

CORAK = Class(TAWalking) {
	
	Weapons = {
		CORE_LASER = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				TAWalking.ShowMuzzleFlare(self, 0.1)
			end,
		},
	},
}

TypeClass = CORAK
