#ARM Adv. Aircraft Plant - Produces Aircraft
#ARMAAP
#
#Script created by Raevn

local TAFactory = import('/mods/SCTA-master/lua/TAFactory.lua').TAFactory
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')

ARMAAP = Class(TAFactory) {
	pauseTime = 5,
	hideUnit = true,


	OnCreate = function(self)
		self.Spinners = {
			pad = CreateRotator(self, 'pad', 'y', nil, 0, 0, 0),
			radar = CreateRotator(self, 'radar', 'y', nil, 0, 0, 0),
			nozzle1 = CreateRotator(self, 'Nozzle_01', 'y', nil, 0, 0, 0),
			nozzle2 = CreateRotator(self, 'Nozzle_02', 'y', nil, 0, 0, 0),
		}
		self.Sliders = {
			building1 = CreateSlider(self, 'building1'),
			building2 = CreateSlider(self, 'building2'),
			nanobox1 = CreateSlider(self, 'nanobox1'),
			nanobox2 = CreateSlider(self, 'nanobox2'),
			nano1 = CreateSlider(self, 'nano1'),
			nano2 = CreateSlider(self, 'nano2'),
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
		for k, v in self.Sliders do
			self.Trash:Add(v)
		end
		TAFactory.OnCreate(self)
	end,

	OnStopBeingBuilt = function(self,builder,layer)
		TAFactory.OnStopBeingBuilt(self,builder,layer)
		self.Spinners.radar:SetSpeed(45)
	end,

	Open = function(self)
		--MOVE building1 to x-axis <7.80> SPEED <15.00>;
		self.Sliders.building1:SetGoal(-7.8,0,0)
		self.Sliders.building1:SetSpeed(15)

		--MOVE building2 to x-axis <-7.85> SPEED <15.00>;
		self.Sliders.building2:SetGoal(7.8,0,0)
		self.Sliders.building2:SetSpeed(15)

		--SLEEP <514>;
		WaitSeconds(0.5)

		--MOVE nanobox1 to x-axis <7.70> SPEED <14.00>;
		self.Sliders.nanobox1:SetGoal(-7.7,0,0)
		self.Sliders.nanobox1:SetSpeed(14)

		--MOVE nanobox2 to x-axis <-7.75> SPEED <14.00>;
		self.Sliders.nanobox2:SetGoal(7.8,0,0)
		self.Sliders.nanobox2:SetSpeed(14)

		--SLEEP <518>;
		WaitSeconds(0.5)

		--MOVE nano2 to z-axis <4.00> SPEED <7.00>;
		self.Sliders.nano2:SetGoal(0,0,3.5)
		self.Sliders.nano2:SetSpeed(7)

		--MOVE nano1 to z-axis <3.54> SPEED <6.00>;
		self.Sliders.nano1:SetGoal(0,0,3.5)
		self.Sliders.nano1:SetSpeed(7)

		--SLEEP <519>;
		WaitSeconds(0.5)

		--SLEEP <26>;

		--SPIN pad around y-axis  SPEED <30.00>
		self.Spinners.pad:SetSpeed(0)

		TAFactory.Open(self)
	end,

	Aim = function(self, target)
		local selfPosition = self:GetPosition('Nozzle_01') 
		local targetPosition = self:GetPosition('pad') 
			
		self.Spinners.nozzle1:SetGoal(TAutils.GetAngleTA(selfPosition.x, selfPosition.z, targetPosition.x, targetPosition.z) - (self:GetHeading() * 180) / math.pi)
		self.Spinners.nozzle1:SetSpeed(160.03)

		selfPosition = self:GetPosition('Nozzle_02') 
		self.Spinners.nozzle2:SetGoal(TAutils.GetAngleTA(selfPosition.x, selfPosition.z, targetPosition.x, targetPosition.z) - (self:GetHeading() * 180) / math.pi)
		self.Spinners.nozzle2:SetSpeed(160.03)
	
		WaitFor(self.Spinners.nozzle1)
		WaitFor(self.Spinners.nozzle2)
		TAFactory.Aim(self, target)
	end,

	Close = function(self)
		--STOP-SPIN pad around y-axis 
		self.Spinners.pad:SetSpeed(0)

		--MOVE nano2 to z-axis <0> SPEED <7.00>;
		self.Sliders.nano2:SetGoal(0,0,0)
		self.Sliders.nano2:SetSpeed(7)

		--MOVE nano1 to z-axis <0> SPEED <6.00>;
		self.Sliders.nano1:SetGoal(0,0,0)
		self.Sliders.nano1:SetSpeed(7)

		--SLEEP <514>;
		WaitSeconds(0.5)

		--MOVE nanobox1 to x-axis <0> SPEED <14.00>;
		self.Sliders.nanobox1:SetGoal(0,0,0)
		self.Sliders.nanobox1:SetSpeed(14)

		--MOVE nanobox2 to x-axis <0> SPEED <14.00>;
		self.Sliders.nanobox2:SetGoal(0,0,0)
		self.Sliders.nanobox2:SetSpeed(14)

		--SLEEP <518>;
		WaitSeconds(0.5)

		--MOVE building1 to x-axis <0> SPEED <15.00>;
		self.Sliders.building1:SetGoal(0,0,0)
		self.Sliders.building1:SetSpeed(15)

		--MOVE building2 to x-axis <0> SPEED <15.00>;
		self.Sliders.building2:SetGoal(0,0,0)
		self.Sliders.building2:SetSpeed(15)

		--SLEEP <519>;
		WaitSeconds(0.5)

		--SLEEP <26>;
		ChangeState(self, self.IdleState)
		TAFactory.Close(self)
	end,
}

TypeClass = ARMAAP