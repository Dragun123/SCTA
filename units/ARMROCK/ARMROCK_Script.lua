#ARM Rocko - Rocket Kbot
#ARMROCK
#
#Script created by Raevn

local TAWalking = import('/mods/SCTA-master/lua/TAMotion.lua').TAWalking
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon

ARMROCK = Class(TAWalking) {
	Weapons = {
		KBOT_ROCKET = Class(TAweapon) {},
	},
}

TypeClass = ARMROCK
