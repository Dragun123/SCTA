#ARM Retaliator - Nuclear Missile Launcher
#ARMSILO
#
#Script created by Raevn

local TAStructure = import('/mods/SCTA-master/lua/TAStructure.lua').TAStructure
local TIFStrategicMissileWeapon = import('/lua/terranweapons.lua').TIFStrategicMissileWeapon

ARMSILO = Class(TAStructure) {


	Weapons = {
		NUCLEAR_MISSILE = Class(TIFStrategicMissileWeapon) {
		},
	},
}

TypeClass = ARMSILO
