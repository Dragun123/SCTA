#ARM Jeffy - Fast Attack Vehicle
#CORMABM
#
#Blueprint created by Raevn

local TATreads = import('/mods/SCTAFix/lua/TATread.lua').TATreads
local AAMWillOWisp = import('/lua/aeonweapons.lua').AAMWillOWisp
CORMABM = Class(TATreads) {
	Weapons = {
			Turret01 = Class(AAMWillOWisp) {}
	},
}

TypeClass = CORMABM