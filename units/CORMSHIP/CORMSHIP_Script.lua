#CORE Hydra - Missile Ship
#CORMSHIP
#
#Script created by Raevn

local TAunit = import('/mods/SCTAFix/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTAFix/lua/TAweapon.lua').TAweapon

CORMSHIP = Class(TAunit) {
	currentShot = 0,

	OnCreate = function(self)
		TAunit.OnCreate(self)
		self.Spinners = {
			dish = CreateRotator(self, 'dish', 'y', nil, 0, 0, 0),
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
		self.Spinners.dish:SetSpeed(150)
	end,
	Weapons = {
		CORMSHIP_ROCKET = Class(TAweapon) {
    			PlayFxRackReloadSequence = function(self)
				self.unit.currentShot = self.unit.currentShot + 1
				if self.unit.currentShot == 6 then
					WaitSeconds(0.6)
					self.unit.currentShot = 0
				end
				TAweapon.PlayFxRackReloadSequence(self)
			end,

			PlayFxWeaponUnpackSequence = function(self)
				WaitSeconds(0.6)

				TAweapon.PlayFxWeaponUnpackSequence(self)
			end,	

			PlayFxWeaponPackSequence = function(self)
				WaitSeconds(0.5)
				TAweapon.PlayFxWeaponPackSequence(self)
			end,	
		},
		CORSHIP_MISSILE = Class(TAweapon) {},
	},
}

TypeClass = CORMSHIP
