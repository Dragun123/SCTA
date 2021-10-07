#ARM Invader - Crawling Bomb
#ARMVADER
#
#Script created by Raevn

local TAKamiCounter = import('/mods/SCTA-master/lua/TAMotion.lua').TAKamiCounter
local TABomb = import('/mods/SCTA-master/lua/TAweapon.lua').TABomb
local TAKami = import('/mods/SCTA-master/lua/TAweapon.lua').TAKami

ARMVADER = Class(TAKamiCounter) {
	Weapons = {
		DeathWeapon = Class(TABomb) {},
		Suicide = Class(TAKami) {},
	},
}
TypeClass = ARMVADER