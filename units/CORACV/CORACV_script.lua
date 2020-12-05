#CORE Adv. Construction Vehicle - Tech Level 2
#CORACV
#
#Blueprint created by Raevn

local TAconstructor = import('/mods/SCTA-master/lua/TAconstructor.lua').TAconstructor
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')

CORACV = Class(TAconstructor) {

	OnCreate = function(self)
		self.Spinners = {
			stand = CreateRotator(self, 'stand', 'y', nil, 0, 0, 0),
			gun = CreateRotator(self, 'gun', 'x', nil, 0, 0, 0),
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
		local selfPosition = self:GetPosition('stand') 
		local targetPosition = target:GetPosition()
		TAconstructor.Aim(self, target)
		WaitFor(self.AnimManip)	
		--TURN turret to y-axis buildheading SPEED <160.03>;
		self.Spinners.stand:SetGoal(TAutils.GetAngleTA(selfPosition.x, selfPosition.z, targetPosition.x, targetPosition.z) - (self:GetHeading() * 180) / math.pi)
		self.Spinners.stand:SetSpeed(160.03)
		WaitFor(self.Spinners.stand)

		local distance = VDist2(selfPosition.x, selfPosition.z, targetPosition.x, targetPosition.z)
		selfPosition = self:GetPosition('gun') 

		self.Spinners.gun:SetGoal(TAutils.GetAngleTA(0, selfPosition.y, distance, targetPosition.y) + 270)
		self.Spinners.gun:SetSpeed(160.03)
		WaitFor(self.Spinners.gun)
	end,

	Close = function(self)
		self.Spinners.gun:SetGoal(0)
		self.Spinners.gun:SetSpeed(160.03)

		self.Spinners.stand:SetGoal(0)
		self.Spinners.stand:SetSpeed(160.03)

		WaitFor(self.Spinners.gun)
		WaitFor(self.Spinners.stand)
		self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationOpen)
		self.AnimManip:SetRate(-1 * (self:GetBlueprint().Display.AnimationOpenRate or 0.2))

		TAconstructor.Close(self)
	end,
}

TypeClass = CORACV