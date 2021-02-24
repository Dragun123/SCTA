#ARM Spider - Spider Assault Vehicle
#ARMBULL
#
#Script created by Raevn

local TACloaker = import('/mods/SCTA-master/lua/TAMotion.lua').TACloaker
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon

ARMSPID = Class(TACloaker) {

	Weapons = {
		ARM_PARALYZER = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				
			end,
		},
	},
}
TypeClass = ARMSPID
