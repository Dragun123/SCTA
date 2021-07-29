#ARM Wombat - Hovercraft Rocket Launcher
#ARMMH
#
#Script created by Raevn

local TASea = import('/mods/SCTA-master/lua/TAMotion.lua').TASea
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon

ARMMH = Class(TASea) {
	OnCreate = function(self)
		TASea.OnCreate(self)
		self.Spinners = CreateRotator(self, 'Box', 'x', nil, 0, 0, 0)
		self.Trash:Add(self.Spinners)
		end
	end,

	Weapons = {
		ARMMH_WEAPON = Class(TAweapon) {

			PlayFxWeaponUnpackSequence = function(self)


				--TURN box to x-axis <-90.00> SPEED <8.91>
				self.unit.Spinners:SetGoal(-90.00)
				self.unit.Spinners:SetSpeed(45)
				WaitFor(self.unit.Spinners)

				--SLEEP <16>

				TAweapon.PlayFxWeaponUnpackSequence(self)
			end,

			PlayFxWeaponPackSequence = function(self)
				self.unit.Spinners:SetGoal(0)
				self.unit.Spinners:SetSpeed(90)
				WaitFor(self.unit.Spinners)
				--SLEEP <13>
				TAweapon.PlayFxWeaponPackSequence(self)
			end,
		},
	},
}

TypeClass = ARMMH
