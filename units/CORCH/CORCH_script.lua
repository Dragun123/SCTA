#COR Construction Hovercraft - Tech Level 1
#CORCH
#
#Script created by Raevn

local TAconstructor = import('/mods/SCTA/lua/TAconstructor.lua').TAconstructor
local TAutils = import('/mods/SCTA/lua/TAutils.lua')

CORCH = Class(TAconstructor) {

	OnCreate = function(self)
		self.AnimManip = CreateAnimator(self)
		self.Spinners = {
			nanogun = CreateRotator(self, 'nanogun', 'y', nil, 0, 0, 0),
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
		self.Trash:Add(self.AnimManip)
		TAconstructor.OnCreate(self)
	end,

	Open = function(self)
			TAconstructor.Open(self)
			self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationOpen)
			self.AnimManip:SetRate(1 * (self:GetBlueprint().Display.AnimationOpenRate or 0.2))	
	end,

	Aim = function(self, target)
		local selfPosition = self:GetPosition('nanogun') 
		local targetPosition = target:GetPosition()
		
		WaitFor(self.AnimManip)
		--TURN turret to y-axis buildheading SPEED <160.03>;
		self.Spinners.nanogun:SetGoal(TAutils.GetAngle(selfPosition.x, selfPosition.z, targetPosition.x, targetPosition.z) - (self:GetHeading() * 180) / math.pi)
		self.Spinners.nanogun:SetSpeed(160.03)

		WaitFor(self.Spinners.nanogun)
		TAconstructor.Aim(self, target)
	end,

	Close = function(self)
		self.Spinners.nanogun:SetGoal(0)
		self.Spinners.nanogun:SetSpeed(160.03)
		WaitFor(self.Spinners.nanogun)
		TAconstructor.Close(self)
		self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationOpen)
		self.AnimManip:SetRate(-1 * (self:GetBlueprint().Display.AnimationOpenRate or 0.2))
	end,
}

TypeClass = CORCH