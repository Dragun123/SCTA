#ARM Tiny - Low Damage, Med. Range Mine
#ARMMINE1
#
#Script created by Raevn

local TAMine = import('/mods/SCTA-master/lua/TAStructure.lua').TAMine
local TAKami = import('/mods/SCTA-master/lua/TAweapon.lua').TAKami
local TABomb = import('/mods/SCTA-master/lua/TAweapon.lua').TABomb

MINE1 = Class(TAMine) {
	Weapons = {
		MINE = Class(TAKami) {},
		DeathWeapon = Class(TABomb) {},

	},
}
TypeClass = MINE1