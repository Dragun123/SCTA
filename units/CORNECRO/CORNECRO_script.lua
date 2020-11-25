#ARM FARK - Fast Assist-Repair Kbot
#ARMFARK
#
#Script created by Raevn

local TANecro = import('/mods/SCTA-master/lua/TAconstructor.lua').TANecro
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')

CORNECRO = Class(TANecro) {

	OnCreate = function(self)
		self.Spinners = {
			Rshoulder = CreateRotator(self, 'Rlathe', 'x', nil, 0, 0, 0),
			torsox = CreateRotator(self, 'torso', 'y', nil, 0, 0, 0),
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
		TANecro.OnCreate(self)
	end,

	Open = function(self)

		--TURN Rshoulder to x-axis <-10.64> SPEED <57.53>;
		self.Spinners.Rshoulder:SetGoal(-90)
		self.Spinners.Rshoulder:SetSpeed(45)
		WaitSeconds(0.2)

		TANecro.Open(self)
	end,

	Aim = function(self, target)
		local selfPosition = self:GetPosition('torso') 
		local targetPosition = target:GetPosition()
			
		--TURN torso to y-axis buildheading SPEED <160.03>;
		self.Spinners.torsox:SetGoal(TAutils.GetAngle(selfPosition.x, selfPosition.z, targetPosition.x, targetPosition.z) - (self:GetHeading() * 180) / math.pi)
		self.Spinners.torsox:SetSpeed(160.03)
		WaitFor(self.Spinners.torsox)
		TANecro.Aim(self, target)
	end,

	Close = function(self)

		self.Spinners.torsox:SetGoal(0)
		self.Spinners.torsox:SetSpeed(140)
		--TURN Rshoulder to x-axis <-10.64> SPEED <53.21>;
		self.Spinners.Rshoulder:SetGoal(0)
		self.Spinners.Rshoulder:SetSpeed(45)
		WaitSeconds(0.2)

		TANecro.Close(self)
	end,
}

TypeClass = CORNECRO