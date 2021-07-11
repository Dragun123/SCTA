#ARM Drake - Experimental Kbot
#ARMDRAKE
#
#Script created by Raevn

local TAWeaponFile = import('/mods/SCTA-master/lua/TAweapon.lua')
local TAWalking = import('/mods/SCTA-master/lua/TAMotion.lua').TAWalking
local TAweapon = TAWeaponFile.TAweapon
local TARotatingWeapon = TAWeaponFile.TARotatingWeapon

ARMDRAKE = Class(TAWalking) {
	Weapons = {
		CORKROG_FIRE = Class(TARotatingWeapon) {
				PlayRackRecoil = function(self, rackList) 
					if not self.Rotator then
						self.Rotator = CreateRotator(self.unit, 'lbarrel', 'z')
						self.Rotator2 = CreateRotator(self.unit, 'rbarrel', 'z')
					end
					self.MaxRound = 4
					self.Rotation = -90
					self.Speed = 480
					TARotatingWeapon.PlayRackRecoil(self, rackList)
				end, 
			},
		ARMDRAK_LASER = Class(TAweapon) {
		},
		CORKROG_ROCKET = Class(TAweapon) {},
	},
}

TypeClass = ARMDRAKE
