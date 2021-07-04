#CORE Silencer - Nuclear Missile Launcher
#CORSILO
#
#Script created by Raevn

local TAStructure = import('/mods/SCTA-master/lua/TAStructure.lua').TAStructure
local TIFStrategicMissileWeapon = import('/lua/terranweapons.lua').TIFStrategicMissileWeapon


ARMEMP = Class(TAStructure) {
	Weapons = {
		EMBMSSL = Class(TIFStrategicMissileWeapon) {
			OnWeaponFired = function(self)
                TIFStrategicMissileWeapon.OnWeaponFired(self)
                self.unit:HideBone('muzzle', true)
            end,

            PlayFxWeaponUnpackSequence = function(self)
                TIFStrategicMissileWeapon.PlayFxWeaponUnpackSequence(self)
                self.unit:ShowBone('muzzle', true)
            end,
		},
	},
}

TypeClass = ARMEMP
