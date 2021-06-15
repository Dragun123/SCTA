#ARM Eraser - Mobile Radar Jammer
#ARMASER
#
#Script created by Raevn

local TACounter = import('/mods/SCTA-master/lua/TAMotion.lua').TACounter

ARMASER = Class(TACounter) {
	OnCreate = function(self)
		TACounter.OnCreate(self)
		self.Spinners = {
			ltong = CreateRotator(self, 'LeftFork', 'y', nil, 0, 0, 0),
			rtong = CreateRotator(self, 'RightFork', 'y', nil, 0, 0, 0),
			fork = CreateRotator(self, 'ForkPivot', 'z', nil, 0, 0, 0),
		}
		self.Sliders = {
			ltong = CreateSlider(self, 'LeftFork'),
			rtong = CreateSlider(self, 'RightFork'),
			tongend = CreateSlider(self, 'ForkEnd'),
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
		for k, v in self.Sliders do
			self.Trash:Add(v)
		end
	end,



	OnIntelDisabled = function(self)
		TACounter.OnIntelDisabled(self)
		self.Spinners.fork:SetGoal(0)
		self.Sliders.ltong:SetGoal(0,0,0)
		self.Sliders.ltong:SetSpeed(4)
		--MOVE rtong to y-axis <0> SPEED <4.00>;
		self.Sliders.rtong:SetGoal(0,0,0)
		self.Sliders.rtong:SetSpeed(4)
		 
		--TURN ltong to y-axis <0> SPEED <174.54>;
		self.Spinners.ltong:SetGoal(0)
		self.Spinners.ltong:SetSpeed(171)

		--TURN rtong to y-axis <-0.3> SPEED <170.98>;
		self.Spinners.rtong:SetGoal(0)
		self.Spinners.rtong:SetSpeed(171)

		--MOVE tongend to y-axis <0> SPEED <4.00>;
		self.Sliders.tongend:SetGoal(0,0,0)
		self.Sliders.tongend:SetSpeed(4)
	end,

	OnIntelEnabled = function(self)
		self.Sliders.tongend:SetGoal(0,0,0)
		self.Sliders.tongend:SetSpeed(3)

		--MOVE ltong to y-axis <-2.99> SPEED <3.00>;
		self.Sliders.ltong:SetGoal(1.75,-0,0)
		self.Sliders.ltong:SetSpeed(3)

		--MOVE rtong to y-axis <-2.99> SPEED <3.00>;
		self.Sliders.rtong:SetGoal(-1.75,-0,0)
		self.Sliders.rtong:SetSpeed(3)
		--TURN ltong to y-axis <-119.17> SPEED <157.26>;
		self.Spinners.ltong:SetGoal(-90)
		self.Spinners.ltong:SetSpeed(155)

		--TURN rtong to y-axis <116.71> SPEED <154.01>;
		self.Spinners.rtong:SetGoal(90)
		self.Spinners.rtong:SetSpeed(155)

		TACounter.OnIntelEnabled(self)
		self.Spinners.fork:ClearGoal()
	end,
}
TypeClass = ARMASER