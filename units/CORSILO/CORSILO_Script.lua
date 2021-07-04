#CORE Silencer - Nuclear Missile Launcher
#CORSILO
#
#Script created by Raevn

local TAStructure = import('/mods/SCTA-master/lua/TAStructure.lua').TAStructure
local TIFStrategicMissileWeapon = import('/lua/terranweapons.lua').TIFStrategicMissileWeapon


CORSILO = Class(TAStructure) {
	Weapons = {
		CRBLMSSL = Class(TIFStrategicMissileWeapon) {
			OnWeaponFired = function(self)
                TIFStrategicMissileWeapon.OnWeaponFired(self)
                self.unit:HideBone('missile', true)
            end,

            PlayFxWeaponUnpackSequence = function(self)
                TIFStrategicMissileWeapon.PlayFxWeaponUnpackSequence(self)
                self.unit:ShowBone('missile', true)
            end,
		},
	},
}

TypeClass = CORSILO
