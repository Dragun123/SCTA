#CORE Construction Vehicle - Tech Level 1
#CORCV
#
#Script created by Raevn

local TAconstructor = import('/mods/SCTA-master/lua/TAconstructor.lua').TAconstructor
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')

CORCV = Class(TAconstructor) {

	OnCreate = function(self)
		self.Spinners = {
			gun = CreateRotator(self, 'muzzle', 'x', nil, 0, 0, 0),
			turret = CreateRotator(self, 'turret', 'y', nil, 0, 0, 0),
		}
		self.AnimManip = CreateAnimator(self)
		self.Trash:Add(self.AnimManip)
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
		TAconstructor.OnCreate(self)
	end,

	Open = function(self)
		self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationOpen)
		self.AnimManip:SetRate(1 * (self:GetBlueprint().Display.AnimationOpenRate or 0.2))		
		TAconstructor.Open(self)
	end,

	Aim = function(self, target)
		local selfPosition = self:GetPosition('turret') 
		local targetPosition = target:GetPosition()
		
		TAconstructor.Aim(self, target)
		WaitFor(self.AnimManip)		
		--TURN turret to y-axis buildheading SPEED <160.03>;
		self.Spinners.turret:SetGoal(TAutils.GetAngleTA(selfPosition.x, selfPosition.z, targetPosition.x, targetPosition.z) - (self:GetHeading() * 180) / math.pi)
		self.Spinners.turret:SetSpeed(160.03)
		WaitFor(self.Spinners.turret)

		local distance = VDist2(selfPosition.x, selfPosition.z, targetPosition.x, targetPosition.z)
		selfPosition = self:GetPosition('muzzle') 

		self.Spinners.gun:SetGoal(270 + TAutils.GetAngleTA(0, selfPosition.y, distance, targetPosition.y))
		self.Spinners.gun:SetSpeed(160.03)
		WaitFor(self.Spinners.gun)
	end,

	Close = function(self)
		self.Spinners.gun:SetGoal(0)
		self.Spinners.gun:SetSpeed(160.03)
		WaitFor(self.Spinners.gun)

		self.Spinners.turret:SetGoal(0)
		self.Spinners.turret:SetSpeed(160.03)
		WaitFor(self.Spinners.turret)


		--SLEEP <584>;
		WaitSeconds(0.6)
		self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationOpen)
		self.AnimManip:SetRate(-1 * (self:GetBlueprint().Display.AnimationOpenRate or 0.2))
		--SLEEP <9>
		TAconstructor.Close(self)
	end,
}
TypeClass = CORCV