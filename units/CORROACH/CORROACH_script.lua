#CORE Roach - Crawling Bomb
#CORROACH
#
#Script created by Raevn


local TAKamiCounter = import('/mods/SCTA-master/lua/TAMotion.lua').TAKamiCounter
local TABomb = import('/mods/SCTA-master/lua/TAweapon.lua').TABomb
local TAKami = import('/mods/SCTA-master/lua/TAweapon.lua').TAKami

CORROACH = Class(TAKamiCounter) {
	Weapons = {
			DeathWeapon = Class(TABomb) {},
			Suicide = Class(TAKami) {},
		},
}
TypeClass = CORROACH