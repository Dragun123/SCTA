#CORE Adv. Shipyard - Produces Ships
#CORASY
#
#Script created by Raevn

local TAFactory = import('/mods/SCTA/lua/TAFactory.lua').TAFactory

CORASY = Class(TAFactory) {
	pauseTime = 5,
	hideUnit = false,
	isFactory = true,

	OnCreate = function(self)
		TAFactory.OnCreate(self)
		self.Spinners = {
			gun1 = CreateRotator(self, 'gun1', 'z', nil, 0, 0, 0),
			gun2 = CreateRotator(self, 'gun2', 'z', nil, 0, 0, 0),
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
	end,

	Open = function(self)
		--TURN gun1 to z-axis <-89.73> SPEED <60.07>;
		self.Spinners.gun1:SetGoal(90)
		self.Spinners.gun1:SetSpeed(60)

		--TURN gun2 to z-axis <89.73> SPEED <60.07>;
		self.Spinners.gun2:SetGoal(-90)
		self.Spinners.gun2:SetSpeed(60)

		--SLEEP <1494>;
		WaitSeconds(1.5)

		TAFactory.Open(self)
	end,

	Close = function(self)

		--TURN gun1 to z-axis <0> SPEED <60.35>;
		self.Spinners.gun1:SetGoal(0)
		self.Spinners.gun1:SetSpeed(60)

		--TURN gun2 to z-axis <0> SPEED <60.35>;
		self.Spinners.gun2:SetGoal(0)
		self.Spinners.gun2:SetSpeed(60)

		--SLEEP <1494>;
		WaitSeconds(1.5)

		--SLEEP <26>;
		TAFactory.Close(self)
	end,
}

TypeClass = CORASY