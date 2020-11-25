#ARM Scarab - Anti Missile
#ARMSCAB
#
#Blueprint created by Dragun

local TAWalking = import('/mods/SCTA-master/lua/TAMotion.lua').TAWalking
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon

ARMSCAB = Class(TAWalking) {
	Weapons = {
			Turret01 = Class(TAweapon) {}
	},
}

TypeClass = ARMSCAB