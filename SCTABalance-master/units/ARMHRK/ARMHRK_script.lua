#CORE Diplomat - Mobile Rocket Launcher
#ARMHRK
#
#Script created by Raevn

local TAWalking = import('/mods/SCTA-master/lua/TAMotion.lua').TAWalking
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon

ARMHRK = Class(TAWalking) {
	
	OnCreate = function(self)
		TAWalking.OnCreate(self)
		self.Spinners = {
			box = CreateRotator(self, 'box', 'x', nil, 0, 0, 0),
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
	end,

	Weapons = {
		CORTRUCK_ROCKET = Class(TAweapon) {

				PlayFxRackReloadSequence = function(self)
				self.unit:ShowBone('flare', true)
				TAweapon.PlayFxRackReloadSequence(self)
			end,

			PlayFxWeaponUnpackSequence = function(self)
				--TURN door1 to z-axis <-89.09> SPEED <143.51>;
				self.unit.Spinners.box:SetGoal(-90)
				self.unit.Spinners.box:SetSpeed(145)

				WaitSeconds(0.65)
				TAweapon.PlayFxWeaponUnpackSequence(self)
			end,

			PlayFxWeaponPackSequence = function(self)
					--TURN arm to x-axis <0> SPEED <175.41>;
					self.unit.Spinners.box:SetGoal(0)
					self.unit.Spinners.box:SetSpeed(175.41)
					--SLEEP <25>;
					WaitSeconds(0.025)
				TAweapon.PlayFxWeaponPackSequence(self)
			end,
		},
	},
}
TypeClass = ARMHRK
