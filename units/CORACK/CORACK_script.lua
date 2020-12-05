#CORE Adv. Construction Kbot - Tech Level 2
#CORACK
#
#Script created by Raevn

local TAconstructor = import('/mods/SCTA-master/lua/TAconstructor.lua').TAconstructor
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')

CORACK = Class(TAconstructor) {

	OnCreate = function(self)
		self.Spinners = {
			nanogun1 = CreateRotator(self, 'unanocase', 'y', nil, 0, 0, 0),
			nanogun2 = CreateRotator(self, 'lnanocase', 'y', nil, 0, 0, 0),
			torso = CreateRotator(self, 'torso', 'y', nil, 0, 0, 0),
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
		TAconstructor.Open(self)
	end,

	Aim = function(self,target)

		#Aim at build job
		local selfPosition = self:GetPosition('torso') 
		local targetPosition = target:GetPosition()
		TAconstructor.Aim(self, target)
		WaitFor(self.AnimManip)	
		local distance = VDist2(selfPosition.x, selfPosition.z, targetPosition.x, targetPosition.z)
		selfPosition = self:GetPosition('unanospray') 

		self.Spinners.nanogun1:SetGoal(90 + TAutils.GetAngleTA(0, selfPosition.y, distance, targetPosition.y))
		self.Spinners.nanogun1:SetSpeed(190.01)

		local distance = VDist2(selfPosition.x, selfPosition.z, targetPosition.x, targetPosition.z)
		selfPosition = self:GetPosition('lnanospray') 
		
		self.Spinners.nanogun2:SetGoal(90 + TAutils.GetAngleTA(0, selfPosition.y, distance, targetPosition.y))
		self.Spinners.nanogun2:SetSpeed(190.01)
		--TURN torso to y-axis buildheading SPEED <160.03>;
		self.Spinners.torso:SetGoal(TAutils.GetAngleTA(selfPosition.x, selfPosition.z, targetPosition.x, targetPosition.z) - (self:GetHeading() * 180) / math.pi)
		self.Spinners.torso:SetSpeed(160.03)
		WaitFor(self.Spinners.torso)
		WaitFor(self.Spinners.nanogun2)
		WaitFor(self.Spinners.nanogun1)
	end,

	Close = function(self)
		self.Spinners.torso:SetGoal(0)
		self.Spinners.torso:SetSpeed(160.03)
		WaitSeconds(0.75)
		self.Spinners.nanogun1:SetGoal(0)
		self.Spinners.nanogun1:SetSpeed(190.71)
		--SLEEP <463>;
		WaitSeconds(0.4)
		self.Spinners.nanogun2:SetGoal(0)
		self.Spinners.nanogun2:SetSpeed(190.71)
		--SLEEP <463>;
		WaitSeconds(0.4)
		self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationOpen)
		self.AnimManip:SetRate(-1 * (self:GetBlueprint().Display.AnimationOpenRate or 0.2))
		TAconstructor.Close(self)
	end,
}

TypeClass = CORACK