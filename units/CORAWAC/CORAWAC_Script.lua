#COR Vulture - Radar Plane
#CORAWAC
#
#Script created by Raevn

local TAair = import('/mods/SCTA/lua/TAair.lua').TAair

CORAWAC = Class(TAair) {

	OnCreate = function(self)
		TAair.OnCreate(self)
		self.Spinners = {
			radar = CreateRotator(self, 'radar', 'y', nil, 0, 0, 0),
			Rwing = CreateRotator(self, 'Rwing', 'z', nil, 0, 0, 0),
			Lwing = CreateRotator(self, 'Lwing', 'z', nil, 0, 0, 0),
		}
		
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
	end,

	OnStopBeingBuilt = function(self,builder,layer)
		TAair.OnStopBeingBuilt(self,builder,layer)
		self.Spinners.radar:SetSpeed(60)
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

	OpenWings = function(self)
		--TURN Rwing to z-axis <-90.12> SPEED <61.86>;
		self.Spinners.Rwing:SetGoal(90)
		self.Spinners.Rwing:SetSpeed(61)

		--TURN Lwing to z-axis <90.12> SPEED <61.86>;
		self.Spinners.Lwing:SetGoal(-90)
		self.Spinners.Lwing:SetSpeed(61)
	end,

	CloseWings = function(self)
		--TURN Rwing to z-axis <0> SPEED <61.95>;
		self.Spinners.Rwing:SetGoal(0)
		self.Spinners.Rwing:SetSpeed(61)

		--TURN Lwing to z-axis <0> SPEED <61.95>;
		self.Spinners.Lwing:SetGoal(0)
		self.Spinners.Lwing:SetSpeed(61)
	end,
}

TypeClass = CORAWAC