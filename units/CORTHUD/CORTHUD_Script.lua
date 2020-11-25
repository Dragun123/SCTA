#CORE Thud - Artillery Kbot
#CORTHUD
#
#Script created by Raevn

local TAWalking = import('/mods/SCTA-master/lua/TAMotion.lua').TAWalking
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon


CORTHUD = Class(TAWalking) {
	

	Weapons = {
		CORE_THUD = Class(TAweapon) {

			OnWeaponFired = function(self)
				
				TAweapon.OnWeaponFired(self)
			end,
		},
	},
}

TypeClass = CORTHUD