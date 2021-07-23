#CORE Fortitude Missile Defense - Anti Missile Defense System
#CORFMD
#
#Script created by Raevn

local TAStructure = import('/mods/SCTA-master/lua/TAStructure.lua').TAStructure
local TAAntiNukeWeapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAAntiNukeWeapon
local nukeFiredOnGotTarget = false

CORFMD = Class(TAStructure) {

	OnStopBeingBuilt = function(self,builder,layer)
        TAStructure.OnStopBeingBuilt(self,builder,layer)
		TAStructure.Fold(self)
	end,

	Weapons = {
		FMD_ROCKET = Class(TAAntiNukeWeapon) {
				OnWeaponFired = function(self)
					TAAntiNukeWeapon.OnWeaponFired(self)
					self.unit:HideBone('dummy', true)
				end,
	
				PlayFxWeaponUnpackSequence = function(self)
					TAAntiNukeWeapon.PlayFxWeaponUnpackSequence(self)
					self.unit:ShowBone('dummy', true)
				end,
		},
	},
}

TypeClass = CORFMD
