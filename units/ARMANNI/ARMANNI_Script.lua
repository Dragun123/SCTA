#ARM Annihilator - Energy Weapon
#ARMANNI
#
#Script created by Raevn

local TAStructure = import('/mods/SCTA-master/lua/TAStructure.lua').TAStructure
local TAPopLaser = import('/mods/SCTA-master/lua/TAweapon.lua').TAPopLaser

ARMANNI = Class(TAStructure) {

	OnStopBeingBuilt = function(self,builder,layer)
		TAStructure.OnStopBeingBuilt(self,builder,layer)
		TAStructure.Fold(self)
	end,

	Weapons = {
		ARM_TOTAL_ANNIHILATOR = Class(TAPopLaser) {
			PlayFxWeaponUnpackSequence = function(self)
				TAPopLaser.PlayFxWeaponUnpackSequence(self)
			end,	

			PlayFxWeaponPackSequence = function(self)
				TAPopLaser.PlayFxWeaponPackSequence(self)
			end,
		},
	},
}

TypeClass = ARMANNI
