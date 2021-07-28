#ARM Ambusher - Pop-up Heavy Cannon
#ARMAMB
#
#Script created by Raevn

local TAPop = import('/mods/SCTA-master/lua/TAStructure.lua').TAPop
local TAHide = import('/mods/SCTA-master/lua/TAweapon.lua').TAHide

CORTOAST = Class(TAPop) {

	Weapons = {
		ARMAMB_GUN = Class(TAHide) {
			OnWeaponFired = function(self)
				TAHide.OnWeaponFired(self)	
			end,

			PlayFxWeaponUnpackSequence = function(self)
				TAHide.PlayFxWeaponUnpackSequence(self)
			end,	

			PlayFxWeaponPackSequence = function(self)
				TAHide.PlayFxWeaponPackSequence(self)
			end,	
		},
	},
}

TypeClass = CORTOAST
