#Generic TA Air unit
local TAunit = import('/mods/SCTA-master/lua/TAunit.lua').TAunit
local FireSelfdestructWeapons = import('/lua/selfdestruct.lua').FireSelfdestructWeapons


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


TATransportAir = Class(TAair)
{
    KillingInProgress = false,


    Kill = function(self)
        if self.Dead or self.KillingInProgress then
            return
        end
        self.KillingInProgress = true
        --LOG('TAUnit.Kill ' .. self:GetBlueprint().General.UnitName)

        -- allow cargo to fire self destruct weapons (SelfDestructed flag is set in selfdestruct.lua)
        if self.SelfDestructed and EntityCategoryContains(categories.AIRTRANSPORT, self) then
            --LOG('  yes self destruct:' .. self:GetBlueprint().General.UnitName)
            local cargo = self:GetCargo()
            --pcall(function() cargo = self:GetCargo() end)
            for _,unit in cargo or { } do
                --LOG('  firing cargo self-d weapons:' .. unit:GetBlueprint().General.UnitName)
                FireSelfdestructWeapons(unit)
            end
        end

        TAair.Kill(self)

    end,
}

TASeaair = Class(TAair) 
{
	OnCreate = function(self)
		TAair.OnCreate(self)
		self:DisableIntel('RadarStealth')
    end,

	OnMotionVertEventChange = function(self, new, old )
		---TAair.OnMotionVertEventChange(self, new, old)
			if (new == 'Down' or new == 'Bottom') then
						self:PlayUnitSound('Landing')
				self:CloseWings(self)
				ForkThread(self.OnLayerChange, self, new, old)
			elseif (new == 'Up' or new == 'Top') then
						self:PlayUnitSound('TakeOff')
				self:OpenWings(self)
			end
		end,

	OnLayerChange = function(self, new, old)
		--TAair.OnLayerChange(self, new, old)
		if( old != 'None' ) then
            if( self.AT1 ) then
                self.AT1:Destroy()
                self.AT1 = nil
			end
            local myBlueprint = self:GetBlueprint()
			if( new == 'Water' ) then
				self:EnableIntel('Vision')
                self:EnableIntel('WaterVision')
				self:EnableIntel('RadarStealth')
				self.Sliders.chassis:SetSpeed(12)
				self.Sliders.chassis:SetGoal(0,-12,0)
			elseif( new == 'Air' ) then
				self:EnableIntel('Vision')
                self:DisableIntel('WaterVision')
				self.Sliders.chassis:SetSpeed(12)
				self.Sliders.chassis:SetGoal(0,0,0)
				self:DisableIntel('RadarStealth')
				--ForkThread(self.OnMotionVertEventChange, self, new, old)
			end
		end
    end,

}
