#ARM Ambusher - Pop-up Heavy Cannon
#ARMAMB
#
#Script created by Raevn

local TAPop = import('/mods/SCTA-master/lua/TAStructure.lua').TAPop
local TAHide = import('/mods/SCTA-master/lua/TAweapon.lua').TAHide

ARMAMB = Class(TAPop) {
	OnCreate = function(self)
		TAPop.OnCreate(self)
		self.Spinners = {
			door1 = CreateRotator(self, 'door1', 'x', nil, 0, 0, 0),
			door2 = CreateRotator(self, 'door2', 'z', nil, 0, 0, 0),
			door3 = CreateRotator(self, 'door3', 'x', nil, 0, 0, 0),
			door4 = CreateRotator(self, 'door4', 'z', nil, 0, 0, 0),
			stand = CreateRotator(self, 'stand', 'y', nil, 0, 0, 0),
			gun = CreateRotator(self, 'gun', 'x', nil, 0, 0, 0),
		}
		self.Sliders = {
			door1 = CreateSlider(self, 'door1'),
			door2 = CreateSlider(self, 'door2'),
			door3 = CreateSlider(self, 'door3'),
			door4 = CreateSlider(self, 'door4'),
			stand = CreateSlider(self, 'stand'),
			turret = CreateSlider(self, 'turret'),
			barrel = CreateSlider(self, 'barrel'),
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
		for k, v in self.Sliders do
			self.Trash:Add(v)
		end
	end,



	Fold = function(self)
		TAPop.Fold(self)
			--MOVE barrel to z-axis <-7.90> SPEED <24.00>;
			self.Sliders.barrel:SetGoal(0,0,-7.9)
			self.Sliders.barrel:SetSpeed(24)
	
			--TURN gun to x-axis <-90.36> SPEED <281.57>;
			self.Spinners.gun:SetGoal(-90)
			self.Spinners.gun:SetSpeed(282)
	
			--MOVE turret to y-axis <-14.35> SPEED <44.00>;
			self.Sliders.turret:SetGoal(0,-14.35,0)
			self.Sliders.turret:SetSpeed(44)
	
			--SLEEP <321>;
			--WaitSeconds(1)
			coroutine.yield(11)

		--MOVE door1 to y-axis <0> SPEED <6.00>;
		self.Sliders.door1:SetGoal(0,0,0)
		self.Sliders.door1:SetSpeed(6)

		--MOVE door2 to y-axis <0> SPEED <6.00>;
		self.Sliders.door2:SetGoal(0,0,0)
		self.Sliders.door2:SetSpeed(6)

		--MOVE door3 to y-axis <0> SPEED <6.00>;
		self.Sliders.door3:SetGoal(0,0,0)
		self.Sliders.door3:SetSpeed(6)

		--MOVE door4 to y-axis <0> SPEED <6.00>;
		self.Sliders.door4:SetGoal(0,0,0)
		self.Sliders.door4:SetSpeed(6)
		self.Sliders.stand:SetGoal(0,-5.35,0)
		self.Sliders.stand:SetSpeed(7)

		--TURN stand to y-axis <295.36> SPEED <353.24>;
		self.Spinners.stand:SetGoal(295)
		self.Spinners.stand:SetSpeed(353)
		--SLEEP <509>;
		--WaitSeconds(1)
		coroutine.yield(11)

		--TURN door1 to x-axis <90.36> SPEED <225.96>;
		self.Spinners.door1:SetGoal(90)
		self.Spinners.door1:SetSpeed(226)

		--TURN door2 to z-axis <-90.36> SPEED <225.96>;
		self.Spinners.door2:SetGoal(90)
		self.Spinners.door2:SetSpeed(226)

		--TURN door3 to x-axis <-90.36> SPEED <225.96>;
		self.Spinners.door3:SetGoal(-90)
		self.Spinners.door3:SetSpeed(226)

		--TURN door4 to z-axis <90.36> SPEED <225.96>;
		self.Spinners.door4:SetGoal(-90)
		self.Spinners.door4:SetSpeed(226)
	end,

	Weapons = {
		ARMAMB_GUN = Class(TAHide) {
			OnWeaponFired = function(self)
				TAHide.OnWeaponFired(self)				
			end,

			PlayFxWeaponUnpackSequence = function(self)
				--MOVE door1 to y-axis <-3.40> SPEED <8.00>;
				self.unit.Sliders.door1:SetGoal(0,-3.4,0)
				self.unit.Sliders.door1:SetSpeed(8)

				--MOVE door2 to y-axis <-3.40> SPEED <8.00>;
				self.unit.Sliders.door2:SetGoal(0,-3.4,0)
				self.unit.Sliders.door2:SetSpeed(8)

				--MOVE door3 to y-axis <-3.40> SPEED <8.00>;
				self.unit.Sliders.door3:SetGoal(0,-3.4,0)
				self.unit.Sliders.door3:SetSpeed(8)

				--MOVE door4 to y-axis <-3.45> SPEED <8.00>;
				self.unit.Sliders.door4:SetGoal(0,-3.4,0)
				self.unit.Sliders.door4:SetSpeed(8)

				--TURN door1 to x-axis <0> SPEED <227.09>;
				self.unit.Spinners.door1:SetGoal(0)
				self.unit.Spinners.door1:SetSpeed(227)

				--TURN door2 to z-axis <0> SPEED <227.09>;
				self.unit.Spinners.door2:SetGoal(0)
				self.unit.Spinners.door2:SetSpeed(227)

				--TURN door3 to x-axis <0> SPEED <227.09>;
				self.unit.Spinners.door3:SetGoal(0)
				self.unit.Spinners.door3:SetSpeed(227)

				--TURN door4 to z-axis <0> SPEED <227.09>;
				self.unit.Spinners.door4:SetGoal(0)
				self.unit.Spinners.door4:SetSpeed(227)

				self.unit.Sliders.stand:SetGoal(0,0,0)
				self.unit.Sliders.stand:SetSpeed(2)

				--TURN stand to y-axis <0> SPEED <346.03>;
				self.unit.Spinners.stand:SetGoal(0)
				self.unit.Spinners.stand:SetSpeed(346)

				--MOVE turret to y-axis <0> SPEED <40.00>;
				self.unit.Sliders.turret:SetGoal(0,0,0)
				self.unit.Sliders.turret:SetSpeed(40)

				--TURN gun to x-axis <0> SPEED <253.18>;
				self.unit.Spinners.gun:SetGoal(0)
				self.unit.Spinners.gun:SetSpeed(253)


				--MOVE barrel to z-axis <0> SPEED <22.00>;
				self.unit.Sliders.barrel:SetGoal(0,0,0)
				self.unit.Sliders.barrel:SetSpeed(22)

				--WaitSeconds(1)
				coroutine.yield(11)

				TAHide.PlayFxWeaponUnpackSequence(self)
			end,	

			PlayFxWeaponPackSequence = function(self)
				self.unit.Sliders.barrel:SetGoal(0,0,-7.9)
				self.unit.Sliders.barrel:SetSpeed(24)

				--TURN gun to x-axis <-90.36> SPEED <281.57>;
				self.unit.Spinners.gun:SetGoal(-90)
				self.unit.Spinners.gun:SetSpeed(282)

				--MOVE turret to y-axis <-14.35> SPEED <44.00>;
				self.unit.Sliders.turret:SetGoal(0,-14.35,0)
				self.unit.Sliders.turret:SetSpeed(44)

				--SLEEP <321>;


				--MOVE door1 to y-axis <0> SPEED <6.00>;
				self.unit.Sliders.door1:SetGoal(0,0,0)
				self.unit.Sliders.door1:SetSpeed(6)

				--MOVE door2 to y-axis <0> SPEED <6.00>;
				self.unit.Sliders.door2:SetGoal(0,0,0)
				self.unit.Sliders.door2:SetSpeed(6)

				--MOVE door3 to y-axis <0> SPEED <6.00>;
				self.unit.Sliders.door3:SetGoal(0,0,0)
				self.unit.Sliders.door3:SetSpeed(6)

				--MOVE door4 to y-axis <0> SPEED <6.00>;
				self.unit.Sliders.door4:SetGoal(0,0,0)
				self.unit.Sliders.door4:SetSpeed(6)
				self.unit.Sliders.stand:SetGoal(0,-5.35,0)
				self.unit.Sliders.stand:SetSpeed(7)

				--TURN stand to y-axis <295.36> SPEED <353.24>;
				self.unit.Spinners.stand:SetGoal(295)
				self.unit.Spinners.stand:SetSpeed(353)

				--SLEEP <509>;
				--WaitSeconds(1)
				coroutine.yield(11)

				--TURN door1 to x-axis <-90.36> SPEED <225.96>;
				self.unit.Spinners.door1:SetGoal(90)
				self.unit.Spinners.door1:SetSpeed(226)

				--TURN door2 to z-axis <90.36> SPEED <225.96>;
				self.unit.Spinners.door2:SetGoal(90)
				self.unit.Spinners.door2:SetSpeed(226)

				--TURN door3 to x-axis <90.36> SPEED <225.96>;
				self.unit.Spinners.door3:SetGoal(-90)
				self.unit.Spinners.door3:SetSpeed(226)

				--TURN door4 to z-axis <-90.36> SPEED <225.96>;
				self.unit.Spinners.door4:SetGoal(-90)
				self.unit.Spinners.door4:SetSpeed(226)
				TAHide.PlayFxWeaponPackSequence(self)
			end,	
		},
	},
}

TypeClass = ARMAMB
