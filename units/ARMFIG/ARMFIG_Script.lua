#ARM Freedom Fighter - Fighter
#ARMFIG
#
#Script created by Raevn

local TAair = import('/mods/SCTA-master/lua/TAair.lua').TAair
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon

ARMFIG = Class(TAair) {
	OnCreate = function(self)
		TAair.OnCreate(self)
		---self:SetMaintenanceConsumptionActive()
		self.Sliders = {
			wing1 = CreateSlider(self, 'wing1'),
			wing2 = CreateSlider(self, 'wing2'),
		}
		self.Spinners = {
			base = CreateRotator(self, 0, 'z', nil, 0, 0, 0),
			wing1 = CreateRotator(self, 'wing1', 'z', nil, 0, 0, 0),
			wing2 = CreateRotator(self, 'wing2', 'z', nil, 0, 0, 0),
		}
		for k, v in self.Sliders do
			self.Trash:Add(v)
		end
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
		self.moving = nil
		ForkThread(self.RollThread, self)
	end,

	RollThread = function(self)
		while not IsDestroyed(self) do
			if self.moving then
				if math.random(10) == 5 then
					--TURN base to z-axis <239.99> SPEED <120.02>
					self.Spinners.base:SetGoal(240)
					self.Spinners.base:SetSpeed(120)

					WaitFor(self.Spinners.base)

					--TURN base to z-axis <119.99> SPEED <180.04>
					self.Spinners.base:SetGoal(120)
					self.Spinners.base:SetSpeed(120)

					WaitFor(self.Spinners.base)

					--TURN base to z-axis <0> SPEED <120.02>
					self.Spinners.base:SetGoal(0)
					self.Spinners.base:SetSpeed(120)
				
				end
			end
			WaitSeconds(2)
		end
	end,

	OpenWings = function(self)
		--MOVE wing1 to x-axis <-2.40> SPEED <1.00>;
		self.Sliders.wing1:SetGoal(2.4,0,0)
		self.Sliders.wing1:SetSpeed(1)

		--MOVE wing2 to x-axis <2.44> SPEED <1.00>;
		self.Sliders.wing2:SetGoal(-2.4,0,0)
		self.Sliders.wing2:SetSpeed(1)

		--TURN wing1 to z-axis <0.89> SPEED <0.61>;
		self.Spinners.wing1:SetGoal(0.89)
		self.Spinners.wing1:SetSpeed(0.61)

		--TURN wing2 to z-axis <-2.69> SPEED <1.85>;
		self.Spinners.wing2:SetGoal(-2.69)
		self.Spinners.wing2:SetSpeed(1.85)

		self.moving = true
	end,

	CloseWings = function(self)

		self.moving = nil

		--MOVE wing1 to x-axis <0> SPEED <1.00>;
		self.Sliders.wing1:SetGoal(0,0,0)
		self.Sliders.wing1:SetSpeed(1)

		--MOVE wing2 to x-axis <0> SPEED <1.00>;
		self.Sliders.wing2:SetGoal(0,0,0)
		self.Sliders.wing2:SetSpeed(1)

		--TURN wing1 to z-axis <0> SPEED <0.61>;
		self.Spinners.wing1:SetGoal(0)
		self.Spinners.wing1:SetSpeed(0.61)

		--TURN wing2 to z-axis <0> SPEED <1.85>;
		self.Spinners.wing2:SetGoal(0)
		self.Spinners.wing2:SetSpeed(1.85)
	end,

	Weapons = {
		ARMVTOL_MISSILE = Class(TAweapon) {},
		
	},
}

TypeClass = ARMFIG