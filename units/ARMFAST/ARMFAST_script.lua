#ARM Zipper - Fast Attack Kbot
#ARMFAST
#
#Script created by Raevn

local TAWalking = import('/mods/SCTA-master/lua/TAMotion.lua').TAWalking
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon

ARMFAST = Class(TAWalking) {

	OnCreate = function(self)
		self.Spinners = {
			rloarm = CreateRotator(self, 'Recoil', 'x', nil, 0, 0, 0),
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
		TAWalking.OnCreate(self)
	end,

	Weapons = {
		ARM_FAST = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				
				ForkThread(self.RecoilThread,self)
			end,

			RecoilThread = function(self)
				--TURN rloarm to x-axis <-49.99> NOW;
				self.unit.Spinners.rloarm:SetGoal(-50)
				self.unit.Spinners.rloarm:SetSpeed(5000)
				WaitFor(self.unit.Spinners.rloarm)
				self.unit.Spinners.rloarm:SetGoal(0)
				self.unit.Spinners.rloarm:SetSpeed(200)
			end,
		},
	},
}
TypeClass = ARMFAST