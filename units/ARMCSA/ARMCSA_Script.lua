#ARM Adv. Construction Aircraft - Tech Level 2
#ARMACA
#
#Script created by Raevn

local TAAirConstructor = import('/mods/SCTA-master/lua/TAAirConstructor.lua').TAAirConstructor
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')

ARMCSA = Class(TAAirConstructor) {
    Flying = true,
	IsWaiting = false,

	OnCreate = function(self)
		TAAirConstructor.OnCreate(self)
		self.Spinners = {
			nozzle1 = CreateRotator(self, 'nanopoint', 'x', nil, 0, 0, 0),
			nozzle2 = CreateRotator(self, 'nanopoint2', 'x', nil, 0, 0, 0),
		}
		self.Sliders = {
			wing1 = CreateSlider(self, 'Rwing'),
			wing2 = CreateSlider(self, 'Lwing'),
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
		for k, v in self.Sliders do
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

	OnStopBeingBuilt = function(self, builder, layer)
		TAAirConstructor.OnStopBeingBuilt(self,builder,layer)
		self:OpenWings(self)
	end,

	OpenWings = function(self)
		--MOVE wing1 to x-axis <5.59> SPEED <5.00>;
		self.Sliders.wing1:SetGoal(-5.59,0,0)
		self.Sliders.wing1:SetSpeed(5)

		--MOVE wing2 to x-axis <-5.65> SPEED <5.00>;
		self.Sliders.wing2:SetGoal(5.65,0,0)
		self.Sliders.wing2:SetSpeed(5)
	end,

	CloseWings = function(self)
		--MOVE wing1 to x-axis <0> SPEED <5.00>;
		self.Sliders.wing1:SetGoal(0,0,0)
		self.Sliders.wing1:SetSpeed(5)

		--MOVE wing2 to x-axis <0> SPEED <5.00>;
		self.Sliders.wing2:SetGoal(0,0,0)
		self.Sliders.wing2:SetSpeed(5)
	end,

	Aim = function(self, target)
		local selfPosition = self:GetPosition('nanopoint') 
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

TypeClass = ARMCSA