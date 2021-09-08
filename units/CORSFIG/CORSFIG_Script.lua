#CORE Avenger - Fighter
#ARMSFIG
#
#Script created by Raevn

local TASeaair = import('/mods/SCTA-master/lua/TAair.lua').TASeaair
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon

CORSFIG = Class(TASeaair) {
	OnCreate = function(self)
		TASeaair.OnCreate(self)
		self.Sliders = {
			chassis = CreateSlider(self, 0),
			wing1 = CreateSlider(self, 'Wing1'),
			wing2 = CreateSlider(self, 'Wing2'),
		}
		for k, v in self.Sliders do
			self.Trash:Add(v)
		end
	end,


	OpenWings = function(self)
		--MOVE winga to x-axis <5.59> SPEED <5.00>;
		self.Sliders.wing1:SetGoal(0,0,0)
		self.Sliders.wing1:SetSpeed(2)

		--MOVE wing2 to x-axis <-5.65> SPEED <5.00>;
		self.Sliders.wing2:SetGoal(0,0,0)
		self.Sliders.wing2:SetSpeed(2)
	end,

	CloseWings = function(self)
		--MOVE winga to x-axis <5.59> SPEED <5.00>;
		self.Sliders.wing1:SetGoal(2,0,0)
		self.Sliders.wing1:SetSpeed(2)

		--MOVE wing2 to x-axis <-5.65> SPEED <5.00>;
		self.Sliders.wing2:SetGoal(-2,0,0)
		self.Sliders.wing2:SetSpeed(2)
	end,

	Weapons = {
		CORVTOL_MISSILE = Class(TAweapon) {
			PlayFxRackReloadSequence = function(self)
				self.unit:HideBone('missle1', true)
				self.unit:HideBone('missle2', true)
				--WaitSeconds(0.1)
				coroutine.yield(2)
				self.unit:ShowBone('missle1', true)
				self.unit:ShowBone('missle2', true)
				TAweapon.PlayFxRackReloadSequence(self)
			end,
		},
	},
}

TypeClass = CORSFIG