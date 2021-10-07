#ARM Zipper - Fast Attack Kbot
#ARMFAST
#
#Script created by Raevn


local TAWalking = import('/mods/SCTA-master/lua/TAMotion.lua').TAWalking
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon

CORFAST = Class(TAWalking) {
	Weapons = {
		ARM_FAST = Class(TAweapon) {
		},
	},
}
TypeClass = CORFAST