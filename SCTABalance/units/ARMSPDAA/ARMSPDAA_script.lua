#ARM Spider - Spider Assault Vehicle
#ARMBULL
#
#Script created by Raevn

local TAunit = import('/mods/SCTAFix/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTAFix/lua/TAweapon.lua').TAweapon

ARMSPIDAA = Class(TAunit) {

	Weapons = {
			ARMAH_WEAPON = Class(TAweapon) {},
			ARMAH2_WEAPON = Class(TAweapon) {},
		},
	}
TypeClass = ARMSPIDAA
