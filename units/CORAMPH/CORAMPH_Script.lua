#ARM Pelican - Amphibious Kbot
#ARMAMPH
#
#Script created by Axle

local TASeaWalking = import('/mods/SCTA-master/lua/TAMotion.lua').TASeaWalking
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon


CORAMPH = Class(TASeaWalking) {

	Weapons = {
		WEAPON = Class(TAweapon) {},
	},
}

TypeClass = CORAMPH
