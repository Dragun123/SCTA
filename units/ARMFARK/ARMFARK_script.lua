#ARM FARK - Fast Assist-Repair Kbot
#ARMFARK
#
#Script created by Raevn

local TAconstructor = import('/mods/SCTA-master/lua/TAconstructor.lua').TAconstructor
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')

ARMFARK = Class(TAconstructor) {

	OnCreate = function(self)
		self.Spinners = {
			Lshoulder = CreateRotator(self, 'Lshoulder', 'x', nil, 0, 0, 0),
			Rshoulder = CreateRotator(self, 'Rshoulder', 'x', nil, 0, 0, 0),
			torsox = CreateRotator(self, 'torso', 'y', nil, 0, 0, 0),
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
		TAconstructor.OnCreate(self)
	end,

	Open = function(self)
		--TURN Lshoulder to x-axis <-10.94> SPEED <59.18>;
		self.Spinners.Lshoulder:SetGoal(-90)
		self.Spinners.Lshoulder:SetSpeed(45)

		--TURN Rshoulder to x-axis <-10.64> SPEED <57.53>;
		self.Spinners.Rshoulder:SetGoal(-90)
		self.Spinners.Rshoulder:SetSpeed(45)

		WaitSeconds(0.2)

		TAconstructor.Open(self)
	end,

	Aim = function(self, target)
		local selfPosition = self:GetPosition('torso') 
		local targetPosition = target:GetPosition()
			
		--TURN torso to y-axis buildheading SPEED <160.03>;
		self.Spinners.torsox:SetGoal(TAutils.GetAngle(selfPosition.x, selfPosition.z, targetPosition.x, targetPosition.z) - (self:GetHeading() * 180) / math.pi)
		self.Spinners.torsox:SetSpeed(160.03)
		WaitFor(self.Spinners.torsox)
		TAconstructor.Aim(self, target)
	end,

	Close = function(self)
		--TURN torso to x-axis <0> SPEED <139.89>;
		self.Spinners.torsox:SetGoal(0)
		self.Spinners.torsox:SetSpeed(140)

		--TURN Lshoulder to x-axis <-10.94> SPEED <54.74>;
		self.Spinners.Lshoulder:SetGoal(0)
		self.Spinners.Lshoulder:SetSpeed(45)

		--TURN Rshoulder to x-axis <-10.64> SPEED <53.21>;
		self.Spinners.Rshoulder:SetGoal(0)
		self.Spinners.Rshoulder:SetSpeed(45)
		WaitSeconds(0.2)

		TAconstructor.Close(self)
	end,
}

TypeClass = ARMFARK