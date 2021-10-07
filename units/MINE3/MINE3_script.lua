#ARM Focused Mine - Med. Damage, Small Range Mine
#ARMMINE3
#
#Script created by Raevn
local TAMine = import('/mods/SCTA-master/lua/TAStructure.lua').TAMine
local TAKami = import('/mods/SCTA-master/lua/TAweapon.lua').TAKami
local TABomb = import('/mods/SCTA-master/lua/TAweapon.lua').TABomb

MINE3 = Class(TAMine) {
	Weapons = {
		MINE = Class(TAKami) {},
		DeathWeapon = Class(TABomb) {},
	},
}
TypeClass = MINE3