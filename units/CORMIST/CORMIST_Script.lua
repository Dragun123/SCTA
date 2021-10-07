#CORE Slasher - Missile Launcher
#CORMIST
#
#Script created by Raevn

local TAunit = import('/mods/SCTA-master/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon

CORMIST = Class(TAunit) {
	
	OnCreate = function(self)
		TAunit.OnCreate(self)
		self.Sliders = {
			arms = CreateSlider(self, 'arms'),
			gun = CreateSlider(self, 'gun'),
		}
		for k, v in self.Sliders do
			self.Trash:Add(v)
		end
	end,

	Weapons = {
		CORTRUCK_MISSILE = Class(TAweapon) {

			PlayFxWeaponUnpackSequence = function(self)
				--MOVE arms to y-axis <3.19> SPEED <2.00>;
				self.unit.Sliders.arms:SetGoal(0,3.19,0)
				self.unit.Sliders.arms:SetSpeed(2)

				--MOVE gun to y-axis <2.4> SPEED <1.00>;
				self.unit.Sliders.gun:SetGoal(0,2,0)
				self.unit.Sliders.gun:SetSpeed(1)

				--SLEEP <1325>
				--WaitSeconds(1.325)
				coroutine.yield(14)

				--SLEEP <22>

				TAweapon.PlayFxWeaponUnpackSequence(self)
			end,
			
			PlayFxWeaponPackSequence = function(self)
				--MOVE arms to y-axis <0> SPEED <2.00>;
				self.unit.Sliders.arms:SetGoal(0,0,0)
				self.unit.Sliders.arms:SetSpeed(2)

				--MOVE gun to y-axis <0> SPEED <1.00>;
				self.unit.Sliders.gun:SetGoal(0,0,0)
				self.unit.Sliders.gun:SetSpeed(1)

				--SLEEP <1325>
				--WaitSeconds(1.325)
				coroutine.yield(14)

				--SLEEP <22>

				TAweapon.PlayFxWeaponPackSequence(self)
			end,
		},
	},
}

TypeClass = CORMIST
