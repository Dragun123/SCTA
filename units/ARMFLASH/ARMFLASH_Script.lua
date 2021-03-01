#ARM Flash - Fast Assault Tank
#ARMFLASH
#
#Script created by Raevn

local TAunit = import('/mods/SCTA-master/lua/TAunit.lua').TAunit
local Projectile = import('/lua/sim/DefaultWeapons.lua').DefaultProjectileWeapon

ARMFLASH = Class(TAunit) {
	Weapons = {
		EMG = Class(Projectile) {
			OnWeaponFired = function(self)
				Projectile.OnWeaponFired(self)
				
			end,
		},
	},
}

TypeClass = ARMFLASH
