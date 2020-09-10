#CORE Advanced Construction Sub - Tech Level 2
#CORACSUB
#
#Script created by Raevn

local TAconstructor = import('/mods/SCTAFix/lua/TAconstructor.lua').TAconstructor
local TAutils = import('/mods/SCTAFix/lua/TAutils.lua')

CORACSUB = Class(TAconstructor) {

	OnCreate = function(self)
		self.AnimManip = CreateAnimator(self)
		self.Spinners = {
			nanogun = CreateRotator(self, 'turret', 'y', nil, 0, 0, 0),
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
		local selfPosition = self:GetPosition('muzzle') 
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
		TAconstructor.Close(self)
	end,
}

TypeClass = CORACSUB