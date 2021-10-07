
local TACommander = import('/mods/SCTA-master/lua/TAconstructor.lua').TACommander
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon
local TADGun = import('/mods/SCTA-master/lua/TAweapon.lua').TADGun
local BareBonesWeapon = import('/lua/sim/DefaultWeapons.lua').BareBonesWeapon


CORDECOM = Class(TACommander) {
	
	Weapons = {
		COMLASER = Class(TAweapon) {
		},
		OverCharge = Class(TADGun) {
		},		
		AutoOverCharge = Class(TADGun) {
		},
		DeathWeapon = Class(BareBonesWeapon) {},
	},
}

TypeClass = CORDECOM