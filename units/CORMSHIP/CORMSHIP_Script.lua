#CORE Hydra - Missile Ship
#CORMSHIP
#
#Script created by Raevn

local TASea = import('/mods/SCTA-master/lua/TAMotion.lua').TASea
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon
local DefaultWeapon = import('/lua/sim/DefaultWeapons.lua').DefaultProjectileWeapon

CORMSHIP = Class(TASea) {
	OnCreate = function(self)
		TASea.OnCreate(self)
		self.Spinners = {
			dish = CreateRotator(self, 'dish', 'y', nil, 0, 0, 0),
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
		self.currentShot = 0
		self.Spinners.dish:SetSpeed(150)
	end,
	
	Weapons = {
		CORMSHIP_ROCKET = Class(TAweapon) {
			PlayFxRackReloadSequence = function(self)
				self.unit.currentShot = self.unit.currentShot + 1
				if self.unit.currentShot == 1 then
					self.unit:HideBone('rocket1', true)
					self.unit:HideBone('rocket2', true)
				elseif self.unit.currentShot == 2 then
					self.unit:HideBone('rocket3', true)
					self.unit:HideBone('rocket4', true)
					self.unit:ShowBone('rocket1', true)
					self.unit:ShowBone('rocket2', true)
				else
					self.unit:HideBone('rocket5', true)
					self.unit:HideBone('rocket6', true)
					self.unit:ShowBone('rocket3', true)
					self.unit:ShowBone('rocket4', true)
				--WaitSeconds(0.5)
				coroutine.yield(6)
					self.unit:ShowBone('rocket5', true)
					self.unit:ShowBone('rocket6', true)
					self.unit.currentShot = 0	
				end
				TAweapon.PlayFxRackReloadSequence(self)
			end,

			PlayFxWeaponUnpackSequence = function(self)
				self.unit:ShowBone('rocket1', true)
				self.unit:ShowBone('rocket2', true)
				self.unit:ShowBone('rocket3', true)
				self.unit:ShowBone('rocket4', true)
				self.unit:ShowBone('rocket5', true)
				self.unit:ShowBone('rocket6', true)
				self.unit.currentShot = 0
				TAweapon.PlayFxWeaponUnpackSequence(self)
			end,		
		},
		Turret01 = Class(DefaultWeapon) {},
	},
}

TypeClass = CORMSHIP
