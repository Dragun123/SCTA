#COR Crasher - Missile Kbot
#CORCRASH
#
#Script created by Raevn

local TAWalking = import('/mods/SCTA-master/lua/TAMotion.lua').TAWalking
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon


CORCRASH = Class(TAWalking) {
	Weapons = {
		CORKBOT_MISSILE = Class(TAweapon) {},
	},
}

TypeClass = CORCRASH
