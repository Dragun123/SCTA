#CORE Commander - Commander
#CORCOM
#
#Script created by Raevn

local TARealCommander = import('/mods/SCTA-master/lua/TAconstructor.lua').TARealCommander
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon
local TADGun = import('/mods/SCTA-master/lua/TAweapon.lua').TADGun
local BareBonesWeapon = import('/lua/sim/DefaultWeapons.lua').BareBonesWeapon

#CORE Commander - Commander

CORCOM = Class(TARealCommander) {
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

TypeClass = CORCOM