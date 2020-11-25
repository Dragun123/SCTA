#CORE Krogoth - Experimental Kbot
#CORKROG
#
#Script created by Raevn

local TAWalking = import('/mods/SCTA-master/lua/TAMotion.lua').TAWalking
local Projectile = import('/lua/sim/DefaultWeapons.lua').DefaultProjectileWeapon
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon

CORKROG = Class(TAWalking) {
	
	Weapons = {
		CORKROG_FIRE = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
			end,
		},
		CORKROG_HEAD = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
			end,
		},
		CORKROG_ROCKET = Class(TAweapon) {},
	},
}

TypeClass = CORKROG
