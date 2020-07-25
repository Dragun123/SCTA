#ARM Drake - Experimental Kbot
#ARMDRAKE
#
#Script created by Raevn

local TAWalking = import('/mods/SCTA-master/lua/TAWalking.lua').TAWalking
local Projectile = import('/lua/sim/DefaultWeapons.lua').DefaultProjectileWeapon
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon

ARMDRAKE = Class(TAWalking) {

	Weapons = {
		CORKROG_FIRE = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				end,
			},
		CORKROG_HEAD = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				TAWalking.ShowMuzzleFlare(self, 0.15)
			end,
		},
		CORKROG_ROCKET = Class(TAweapon) {},
	},
}

TypeClass = ARMDRAKE
