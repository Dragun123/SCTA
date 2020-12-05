#CORE Construction Kbot - Tech Level 1
#CORCK
#
#Script created by Raevn

local TAconstructor = import('/mods/SCTA-master/lua/TAconstructor.lua').TAconstructor
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')

CORCK = Class(TAconstructor) {
	,

	OnCreate = function(self)
		self.Spinners = {
			torso = CreateRotator(self, 'torso', 'y', nil, 0, 0, 0),
			nanogun = CreateRotator(self, 'BuildNozzle', 'z', nil, 0, 0, 0),
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
		self.AnimManip = CreateAnimator(self)
		self.Trash:Add(self.AnimManip)
		TAconstructor.OnCreate(self)
	end,

	Open = function(self)
		self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationOpen)
		self.AnimManip:SetRate(1 * (self:GetBlueprint().Display.AnimationOpenRate or 0.2))	
				--TURN nanogun to z-axis <-180.00> SPEED <209.84>;
		TAconstructor.Open(self)
	end,

	Aim = function(self,target)
		#Aim at build job
		local selfPosition = self:GetPosition('torso') 
		local targetPosition = target:GetPosition()
		TAconstructor.Aim(self, target)
		WaitFor(self.AnimManip)		
		--TURN torso to y-axis buildheading SPEED <160.03>;
		self.Spinners.torso:SetGoal(TAutils.GetAngleTA(selfPosition.x, selfPosition.z, targetPosition.x, targetPosition.z) - (self:GetHeading() * 180) / math.pi)
		self.Spinners.torso:SetSpeed(160.03)
		WaitFor(self.Spinners.torso)

		local distance = VDist2(selfPosition.x, selfPosition.z, targetPosition.x, targetPosition.z)
		selfPosition = self:GetPosition('BuildNozzle') 

		self.Spinners.nanogun:SetGoal(90 + TAutils.GetAngleTA(0, selfPosition.y, distance, targetPosition.y))
		self.Spinners.nanogun:SetSpeed(45.01)

		WaitFor(self.Spinners.nanogun)
	end,

	Close = function(self)
		self.Spinners.torso:SetGoal(0)
		self.Spinners.torso:SetSpeed(160.03)
		WaitFor(self.Spinners.torso)
		--SLEEP <469>;
		WaitSeconds(0.4)

		--TURN nanogun to z-axis <0> SPEED <190.71>;
		self.Spinners.nanogun:SetGoal(0)
		self.Spinners.nanogun:SetSpeed(190.71)
		--SLEEP <463>;
		WaitSeconds(0.4)
		self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationOpen)
		self.AnimManip:SetRate(-1 * (self:GetBlueprint().Display.AnimationOpenRate or 0.2))
		

		TAconstructor.Close(self)
	end,
}

TypeClass = CORCK