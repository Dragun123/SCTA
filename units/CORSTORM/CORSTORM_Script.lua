#CORE Storm - Rocket Kbot
#CORSTORM
#
#Script created by Raevn

local TAWalking = import('/mods/SCTA-master/lua/TAMotion.lua').TAWalking
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon


CORSTORM = Class(TAWalking) {
	Weapons = {
		CORKBOT_ROCKET = Class(TAweapon) {},
	},
}

TypeClass = CORSTORM
