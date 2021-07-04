#CORE Silencer - Nuclear Missile Launcher
#CORSILO
#
#Script created by Raevn

local TAStructure = import('/mods/SCTA-master/lua/TAStructure.lua').TAStructure
local TIFStrategicMissileWeapon = import('/lua/terranweapons.lua').TIFStrategicMissileWeapon


ARMEMP = Class(TAStructure) {
	Weapons = {
		EMBMSSL = Class(TIFStrategicMissileWeapon) {
		},
	},
}

TypeClass = ARMEMP
