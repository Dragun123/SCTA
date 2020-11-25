#ARM Drake Gantry - Builds Drake
#ARMGANT
#
#Script created by Raevn

local TAFactory = import('/mods/SCTA-master/lua/TAFactory.lua').TAFactory
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')

ARMGANT = Class(TAFactory) {
	pauseTime = 5,
	hideUnit = true,


	OnCreate = function(self)
		self.Spinners = {
			door1 = CreateRotator(self, 'door1', 'z', nil, 0, 0, 0),
			door2 = CreateRotator(self, 'door2', 'z', nil, 0, 0, 0),
		}
		self.Sliders = {
			plate = CreateSlider(self, 'buildpad'),
		}
		for k, v in self.Sliders do
			self.Trash:Add(v)
		end
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
		TAFactory.OnCreate(self)
	end,


	Open = function(self)
				--TURN door1 to x-axis <-88.64> SPEED <129.82>
				self.Spinners.door1:SetGoal(-90)
				self.Spinners.door1:SetSpeed(131.80)
		
				--TURN door2 to z-axis <90.00> SPEED <131.80>
				self.Spinners.door2:SetGoal(90)
				self.Spinners.door2:SetSpeed(131.80)
		
				--SLEEP <683>
				WaitSeconds(0.7)
				self.Sliders.plate:SetGoal(0,0,2.3)
				self.Sliders.plate:SetSpeed(7)
		TAFactory.Open(self)
	end,

	Close = function(self)
		--TURN door1 to x-axis <-88.64> SPEED <129.82>
		self.Spinners.door1:SetGoal(0)
		self.Spinners.door1:SetSpeed(131.80)

		--TURN door2 to z-axis <90.00> SPEED <131.80>
		self.Spinners.door2:SetGoal(0)
		self.Spinners.door2:SetSpeed(131.80)

		--SLEEP <683>
		WaitSeconds(0.7)

		self.Sliders.plate:SetGoal(0,0,0)
		self.Sliders.plate:SetSpeed(7)
TAFactory.Close(self)
end,

}

TypeClass = ARMGANT