#ARM Zipper - Fast Attack Kbot
#ARMFAST
#
#Script created by Raevn


local TAWalking = import('/mods/SCTA-master/lua/TAMotion.lua').TAWalking
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon

CORFAST = Class(TAWalking) {

	OnCreate = function(self)
		self.Spinners = {
			llarm = CreateRotator(self, 'LLArm', 'x', nil, 0, 0, 0),
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
				--TURN llarm to x-axis <-49.99> NOW;
				self.unit.Spinners.llarm:SetGoal(-50)
				self.unit.Spinners.llarm:SetSpeed(5000)
				WaitFor(self.unit.Spinners.llarm)
				self.unit.Spinners.llarm:SetGoal(0)
				self.unit.Spinners.llarm:SetSpeed(200)
			end,
		},
	},
}
TypeClass = CORFAST