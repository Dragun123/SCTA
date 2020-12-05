#ARM Adv. Construction Aircraft - Tech Level 2
#ARMACA
#
#Script created by Raevn

local TAAirConstructor = import('/mods/SCTA-master/lua/TAAirConstructor.lua').TAAirConstructor
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')

CORCSA = Class(TAAirConstructor) {

	OnCreate = function(self)
		TAAirConstructor.OnCreate(self)
		self.Spinners = {
			nozzle1 = CreateRotator(self, 'nano1', 'x', nil, 0, 0, 0),
			nozzle2 = CreateRotator(self, 'nano2', 'x', nil, 0, 0, 0),
			wing1 = CreateRotator(self, 'rightwing', 'z', nil, 0, 0, 0),
			wing2 = CreateRotator(self, 'leftwing', 'z', nil, 0, 0, 0),
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
	end,

	OnMotionVertEventChange = function(self, new, old )
		if (new == 'Down' or new == 'Bottom') then
                	self:PlayUnitSound('Landing')
			self:CloseWings(self)
		elseif (new == 'Up' or new == 'Top') then
                	self:PlayUnitSound('TakeOff')
			self:OpenWings(self)
		end
	end,

	OnStopBeingBuilt = function(self,builder,layer)
		TAAirConstructor.OnStopBeingBuilt(self,builder,layer)
		self:OpenWings(self)
	end,

	OpenWings = function(self)
		--MOVE winga to x-axis <5.59> SPEED <5.00>;
		self.Spinners.wing1:SetGoal(70)
		self.Spinners.wing1:SetSpeed(70)

		--MOVE wing2 to x-axis <-5.65> SPEED <5.00>;
		self.Spinners.wing2:SetGoal(-70)
		self.Spinners.wing2:SetSpeed(70)
	end,

	CloseWings = function(self)
		self.Spinners.wing1:SetGoal(0)
		self.Spinners.wing1:SetSpeed(70)

		--MOVE wing2 to x-axis <-5.65> SPEED <5.00>;
		self.Spinners.wing2:SetGoal(0)
		self.Spinners.wing2:SetSpeed(70)
	end,

	Aim = function(self, target)
		local selfPosition = self:GetPosition('nano1') 
		local targetPosition = target:GetPosition()
		local distance = VDist2(selfPosition.x, selfPosition.z, targetPosition.x, targetPosition.z)
		TAAirConstructor.Aim(self, target)
		
		self.Spinners.nozzle1:SetGoal(TAutils.GetAngleTA(0, targetPosition.y, distance, selfPosition.y))
		self.Spinners.nozzle1:SetSpeed(160.03)

		WaitFor(self.Spinners.nozzle1)

		self.Spinners.nozzle2:SetGoal(TAutils.GetAngleTA(0, targetPosition.y, distance, selfPosition.y))
		self.Spinners.nozzle2:SetSpeed(160.03)

		WaitFor(self.Spinners.nozzle2)

	end,
}

TypeClass = CORCSA