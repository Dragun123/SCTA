#ARM Retaliator - Nuclear Missile Launcher
#ARMSILO
#
#Script created by Raevn

local TAStructure = import('/mods/SCTA-master/lua/TAStructure.lua').TAStructure
local TIFStrategicMissileWeapon = import('/lua/terranweapons.lua').TIFStrategicMissileWeapon

ARMSILO = Class(TAStructure) {


	Weapons = {
		NUCLEAR_MISSILE = Class(TIFStrategicMissileWeapon) {
			OnWeaponFired = function(self)
                TIFStrategicMissileWeapon.OnWeaponFired(self)
                self.unit:HideBone('Muzzle', true)
            end,

            PlayFxWeaponUnpackSequence = function(self)
                TIFStrategicMissileWeapon.PlayFxWeaponUnpackSequence(self)
                self.unit:ShowBone('Muzzle', true)
            end,
		},
	},
}

TypeClass = ARMSILO
