#ARM Zeus - Assault Kbot
#ARMZEUS
#
#Script created by Raevn

local TAWalking = import('/mods/SCTA-master/lua/TAMotion.lua').TAWalking
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon


ARMZEUS = Class(TAWalking) {

	Weapons = {
		LIGHTNING = Class(TAweapon) {
		},
	},
}
TypeClass = ARMZEUS