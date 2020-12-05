#CORE Construction Ship - Tech Level 1
#CORCS
#
#Script created by Raevn

local TANecro = import('/mods/SCTA-master/lua/TAconstructor.lua').TANecro
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')

CORCS = Class(TANecro) {

	OnCreate = function(self)
		self.AnimManip = CreateAnimator(self)
		self.Spinners = {
			gun = CreateRotator(self, 'turret', 'y', nil, 0, 0, 0),
		}
		self.Trash:Add(self.AnimManip)
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
		TANecro.OnCreate(self)
	end,

	Open = function(self)
		TANecro.Open(self)
		self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationOpen)
		self.AnimManip:SetRate(1 * (self:GetBlueprint().Display.AnimationOpenRate or 0.2))
		TANecro.Open(self)
	end,

	Aim = function(self, target)
		local selfPosition = self:GetPosition('nano') 
		local targetPosition = target:GetPosition()
		
		TANecro.Aim(self, target)
		WaitFor(self.AnimManip)
		--TURN turret to y-axis buildheading SPEED <160.03>;
		self.Spinners.gun:SetGoal(TAutils.GetAngleTA(selfPosition.x, selfPosition.z, targetPosition.x, targetPosition.z) - (self:GetHeading() * 180) / math.pi)
		self.Spinners.gun:SetSpeed(160.03)

		WaitFor(self.Spinners.gun)

	end,

	Close = function(self)
		self.Spinners.gun:SetGoal(0)
		self.Spinners.gun:SetSpeed(160.03)
		WaitFor(self.Spinners.gun)
		TANecro.Close(self)
		self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationOpen)
		self.AnimManip:SetRate(-1 * (self:GetBlueprint().Display.AnimationOpenRate or 0.2))
	end,
}

TypeClass = CORCS