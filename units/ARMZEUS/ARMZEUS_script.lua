#ARM Zeus - Assault Kbot
#ARMZEUS
#
#Script created by Raevn

local TAunit = import('/mods/SCTAFix/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTAFix/lua/TAweapon.lua').TAweapon

ARMZEUS = Class(TAunit) {

	Weapons = {
		LIGHTNING = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				
			end,

			PlayFxWeaponUnpackSequence = function(self)
				TAweapon.PlayFxWeaponUnpackSequence(self)
			end,	

			PlayFxWeaponPackSequence = function(self)
				TAweapon.PlayFxWeaponPackSequence(self)
			end,	
		},
	},
}
TypeClass = ARMZEUS