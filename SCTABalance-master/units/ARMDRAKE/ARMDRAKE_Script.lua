#ARM Drake - Experimental Kbot
#ARMDRAKE
#
#Script created by Raevn

local TAWalking = import('/mods/SCTA-master/lua/TAMotion.lua').TAWalking
local Projectile = import('/lua/sim/DefaultWeapons.lua').DefaultProjectileWeapon
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon

ARMDRAKE = Class(TAWalking) {
	currentBarrel = 0,

	OnCreate = function(self)
		TAWalking.OnCreate(self)
		self.Spinners = {
			spindle = CreateRotator(self, 'lbarrel', 'z', nil, 0, 0, 0),
			spindle2 = CreateRotator(self, 'rbarrel', 'z', nil, 0, 0, 0),
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
	end,



	Weapons = {
		CORKROG_FIRE = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				
				self.unit.currentBarrel = self.unit.currentBarrel + 1
				if self.unit.currentBarrel == 4 then
					self.unit.currentBarrel = 0
				end

				self.unit.Spinners.spindle2:SetGoal(-90 * (self.unit.currentBarrel + 1))
				self.unit.Spinners.spindle2:SetSpeed(480)
				self.unit.Spinners.spindle:SetGoal(-90 * (self.unit.currentBarrel + 1))
				self.unit.Spinners.spindle:SetSpeed(480)
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

TypeClass = ARMDRAKE
