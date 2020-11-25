#ARM Flash - Fast Assault Tank
#ARMFLASH
#
#Script created by Raevn

local TATreads = import('/mods/SCTA-master/lua/TAMotion.lua').TATreads
local Projectile = import('/lua/sim/DefaultWeapons.lua').DefaultProjectileWeapon

ARMFLASH = Class(TATreads) {
	Weapons = {
		EMG = Class(Projectile) {
			OnWeaponFired = function(self)
				Projectile.OnWeaponFired(self)
				
			end,
		},
	},
}

TypeClass = ARMFLASH
