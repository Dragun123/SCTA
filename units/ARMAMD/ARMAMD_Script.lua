#ARM Protector - Anti Missile Defense System
#ARMAMD
#
#Script created by Raevn

local TAStructure = import('/mods/SCTA-master/lua/TAStructure.lua').TAStructure
local TAAntiNukeWeapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAAntiNukeWeapon
local nukeFiredOnGotTarget = false

ARMAMD = Class(TAStructure) {
    OnStopBeingBuilt = function(self,builder,layer)
        TAStructure.OnStopBeingBuilt(self,builder,layer)
		TAStructure.Fold(self)
	end,

	Weapons = {
		AMD_ROCKET = Class(TAAntiNukeWeapon) {
            IdleState = State(TAAntiNukeWeapon.IdleState) {
                OnFire = function(self)
                    TAAntiNukeWeapon.IdleState.OnFire(self)
					self.unit:HideBone('Rocket_01', true)
				end,
			},

            OnWeaponFired = function(self)
                TAAntiNukeWeapon.OnWeaponFired(self)
                self.unit:HideBone('Rocket_01', true)
            end,

            PlayFxWeaponUnpackSequence = function(self)
                TAAntiNukeWeapon.PlayFxWeaponUnpackSequence(self)
                self.unit:ShowBone('Rocket_01', true)
            end,
		},
	},
}

TypeClass = ARMAMD
