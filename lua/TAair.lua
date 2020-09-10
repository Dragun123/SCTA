#Generic TA Air unit
local TAunit = import('/mods/SCTA/lua/TAunit.lua').TAunit

TAair = Class(TAunit) 
{
	OnCreate = function(self)
        TAunit.OnCreate(self)
        self.HasFuel = true
    end,

	OnMotionVertEventChange = function(self, new, old )
		if (new == 'Bottom' and old == 'Down' and EntityCategoryContains(categories.TRANSPORTATION, self)) then
	                self:PlayUnitSound('Landing')
			self:CloseWings(self)
		elseif (new == 'Down' and old == 'Top' and not EntityCategoryContains(categories.TRANSPORTATION, self)) then
	                self:PlayUnitSound('Landing')
			self:CloseWings(self)
		elseif (new == 'Bottom') then
                	self:PlayUnitSound('TakeOff')
			self:OpenWings(self)
		elseif (new == 'Up' or new == 'Top') then
			self:OpenWings(self)
		end

		TAunit.OnMotionVertEventChange(self, new, old)
	end,

	OnStopBeingBuilt = function(self,builder,layer)
		TAunit.OnStopBeingBuilt(self,builder,layer)
		self:OpenWings(self)
				self:PlayUnitSound('TakeOff')
				local bp = self:GetBlueprint()
				self:SetCollisionShape(
					'Sphere', 
					bp.CollisionSphereOffsetX or 0, 
					bp.CollisionSphereOffsetY or 0, 
					bp.CollisionSphereOffsetZ or 0, 
					bp.SizeSphere or 1.5 
				)      
	end,

	OpenWings = function(self)
	end,

	CloseWings = function(self)
	end,

	OnRunOutOfFuel = function(self)
		self.HasFuel = false
        # penalize movement for running out of fuel
        self:SetSpeedMult(0.25)     # change the speed of the unit by this mult
        self:SetAccMult(0.25)       # change the acceleration of the unit by this mult
        self:SetTurnMult(0.25)      # change the turn ability of the unit by this mult
    end,

	OnGotFuel = function(self)
		self.HasFuel = true
        # revert these values to the blueprint values
        self:SetSpeedMult(1)
        self:SetAccMult(1)
        self:SetTurnMult(1)
	end,
}

TypeClass = TAair
