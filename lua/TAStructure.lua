#Generic TA unit
local TAunit = import('/mods/SCTA-master/lua/TAunit.lua').TAunit

TAStructure = Class(TAunit) 
{
	LandBuiltHiddenBones = {'Floatation'},
	MinConsumptionPerSecondEnergy = 1,
    MinWeaponRequiresEnergy = 0,
	
	DoTakeDamage = function(self, instigator, amount, vector, damageType)
	    -- Handle incoming OC damage
        if damageType == 'Overcharge' then
            local wep = instigator:GetWeaponByLabel('OverCharge')
            amount = wep:GetBlueprint().Overcharge.structureDamage
        end
        TAunit.DoTakeDamage(self, instigator, amount, vector, damageType)
    end,

	RotateTowardsEnemy = function(self)
        local bp = self:GetBlueprint()
        local brain = self:GetAIBrain()
        local pos = self:GetPosition()
        local x, y = GetMapSize()
        local threats = {{pos = {x / 2, 0, y / 2}, dist = VDist2(pos[1], pos[3], x, y), threat = -1}}
        local cats = EntityCategoryContains(categories.ANTIAIR, self) and categories.AIR or (categories.STRUCTURE + categories.LAND + categories.NAVAL)
        local units = brain:GetUnitsAroundPoint(cats, pos, 2 * (bp.AI.GuardScanRadius or 100), 'Enemy')
        for _, u in units do
            local blip = u:GetBlip(self.Army)
            if blip then
                local on_radar = blip:IsOnRadar(self.Army)
                local seen = blip:IsSeenEver(self.Army)

                if on_radar or seen then
                    local epos = u:GetPosition()
                    local threat = seen and (u:GetBlueprint().Defense.SurfaceThreatLevel or 0) or 1

                    table.insert(threats, {pos = epos, threat = threat, dist = VDist2(pos[1], pos[3], epos[1], epos[3])})
                end
            end
        end

        table.sort(threats, function(a, b)
            if a.threat <= 0 and b.threat <= 0 then
                return a.threat == b.threat and a.dist < b.dist or a.threat > b.threat
            elseif a.threat <= 0 then return false
            elseif b.threat <= 0 then return true
            else return a.dist < b.dist end
        end)

        local t = threats[1]
        local rad = math.atan2(t.pos[1]-pos[1], t.pos[3]-pos[3])
        local degrees = rad * (180 / math.pi)

        if EntityCategoryContains(categories.ARTILLERY * (categories.TECH3 + categories.EXPERIMENTAL), self) then
            degrees = math.floor((degrees + 45) / 90) * 90
        end

        self:SetRotation(degrees)
    end,

    OnStartBeingBuilt = function(self, builder, layer)
		if EntityCategoryContains(categories.STRUCTURE * (categories.DIRECTFIRE + categories.INDIRECTFIRE) * (categories.DEFENSE + categories.ARTILLERY), self) then
            self:RotateTowardsEnemy()
        end
        TAunit.OnStartBeingBuilt(self,builder,layer)
	end,

	OnStopBeingBuilt = function(self,builder,layer)
        TAunit.OnStopBeingBuilt(self,builder,layer)
        self:SetMaintenanceConsumptionActive()
    end,

	OnPaused = function(self)
        TAunit.OnPaused(self)
		self:UpdateConsumptionValues()
    end,

    OnUnpaused = function(self)
        TAunit.OnUnpaused(self)
		self:UpdateConsumptionValues()
    end,

	OnStopBuild = function(self, unitBeingBuilt, order)
		TAunit.OnStopBuild(self, unitBeingBuilt, order)
		if unitBeingBuilt:GetFractionComplete() == 1 and unitBeingBuilt:GetUnitId() == self:GetBlueprint().General.UpgradesTo then
			NotifyUpgrade(self, unitBeingBuilt)
			self:Destroy()
		end
	end,
	
	Fold = function(self)
		self.Pack = self:GetBlueprint().Defense.DamageModifier
	end,
	
	Unfold = function(self)
		self.Pack = nil
	end,

}

TAPop = Class(TAStructure) {
	OnCreate = function(self)
		TAStructure.OnCreate(self)
		self:SetWeaponEnabledByLabel('ARMAMB_GUN', false)
	end,
	
	Fold = function(self)
		TAStructure.Fold(self)
		self:EnableIntel('RadarStealth')
		self:SetWeaponEnabledByLabel('ARMAMB_GUN', true)
	end,

	OnStopBeingBuilt = function(self,builder,layer)
		TAStructure.OnStopBeingBuilt(self,builder,layer)
		ForkThread(self.Fold, self)
	end,
}

TAMass = Class(TAStructure) {
	CreateWreckage = function( self, overkillRatio )
		if not self.onMetalSpot then
			TAStructure.CreateWreckageProp(self, overkillRatio)
		else
			return nil
		end
	end,

	OnStopBeingBuilt = function(self, builder, layer)
		TAStructure.OnStopBeingBuilt(self, builder, layer)
		local markers = import('/lua/sim/ScenarioUtilities.lua').GetMarkers() 
		local unitPosition = self:GetPosition()  
		for k, v in pairs(markers) do 
			if(v.type == 'Mass') then 
                		local MassPosition = v.position 
                		if (MassPosition[1] < unitPosition[1] + 1) and (MassPosition[1] > unitPosition[1] - 1) then 
	                    		if (MassPosition[3] < unitPosition[3] + 1) and (MassPosition[3] > unitPosition[3] - 1) then
						self.onMetalSpot = true
	                    			break 
								end
	               		end 
            	end 
        	end		
		self:PlayUnitSound('Activate')
		self.Spinners.arms:SetTargetSpeed(self:GetProductionPerSecondMass() * 75)
	end,

	OnProductionPaused = function(self)
		TAStructure.OnProductionPaused(self)
		self.Spinners.arms:SetAccel(182)
		self.Spinners.arms:SetTargetSpeed(0)
		self:PlayUnitSound('Deactivate')
	end,

	OnProductionUnpaused = function(self)
		TAStructure.OnProductionUnpaused(self)
		self.Spinners.arms:SetAccel(91)
		self.Spinners.arms:SetTargetSpeed(self:GetProductionPerSecondMass() * 75)
		self:PlayUnitSound('Activate')
	end,

    OnStartBuild = function(self, unitbuilding, order)
        TAStructure.OnStartBuild(self, unitbuilding, order)
        self:AddCommandCap('RULEUCC_Stop')
    end,

    OnStopBuild = function(self, unitbuilding, order)
        TAStructure.OnStopBuild(self, unitbuilding, order)
        self:RemoveCommandCap('RULEUCC_Stop') 
    end,
	}

TATarg = Class(TAStructure) {
	OnIntelEnabled = function(self)
		TAStructure.OnIntelEnabled()
		if EntityCategoryContains(categories.OPTICS, self) and (self:IsIntelEnabled('Radar') or self:IsIntelEnabled('Sonar')) then
			import('/mods/SCTA-master/lua/TAutils.lua').registerTargetingFacility(self:GetArmy())
		end
	end,

	OnIntelDisabled = function(self)
		TAStructure.OnIntelDisabled()
			if EntityCategoryContains(categories.OPTICS, self) and not (self:IsIntelEnabled('Radar') or self:IsIntelEnabled('Sonar')) then
			import('/mods/SCTA-master/lua/TAutils.lua').unregisterTargetingFacility(self:GetArmy())
		end
	end,
}


TACloser = Class(TATarg) {
	OnStopBeingBuilt = function(self,builder,layer)
		TATarg.OnStopBeingBuilt(self,builder,layer)
		ChangeState(self, self.OpeningState)
	end,

	IdleClosedState = State {
		Main = function(self)
			if self.IsActive then
				while self.DamageSeconds > 0 do
					--WaitSeconds(1)
					coroutine.yield(11)
					self.DamageSeconds = self.DamageSeconds - 1
				end 
				--self.TAAnimating = nil
				ChangeState(self, self.OpeningState)
			end
		end,

		OnDamage = function(self, instigator, amount, vector, damageType)
			TATarg.OnDamage(self, instigator, amount, vector, damageType) 
			self.DamageSeconds = 8
		end,

	},

	IdleOpenState = State {
		Main = function(self)
		end,

		OnDamage = function(self, instigator, amount, vector, damageType)
			TATarg.OnDamage(self, instigator, amount, vector, damageType)
			self.DamageSeconds = 8
			ChangeState(self, self.ClosingState)
		end,

	},

	OpeningState = State {
		Main = function(self)
			TATarg.Unfold(self)
			self.IsActive = true
			--self:RequestRefreshUI()
			---self:SetPaused(false)
			--self.TAAnimating = nil
			self:PlayUnitSound('Activate')
			ChangeState(self, self.IdleOpenState)
		end,
	},


	ClosingState = State {
		Main = function(self)
			TATarg.Fold(self)
			--self:RequestRefreshUI()
			--self:SetPaused(true)
			self:PlayUnitSound('Deactivate')
			ChangeState(self, self.IdleClosedState)
		end,

	},

	OnScriptBitSet = function(self, bit)
		if bit == 3 then
			self.IsActive = nil
			--self.TAAnimating = nil
			ChangeState(self, self.ClosingState)
		end
		TATarg.OnScriptBitSet(self, bit)
	end,


	OnScriptBitClear = function(self, bit)
		if bit == 3 then
			self.IsActive = true
			--self.TAAnimating = nil
			----I could have it be so don't repeat animations but rather have less memory consumption
			----A potential graphical error
			ChangeState(self, self.OpeningState)
		end
		TATarg.OnScriptBitClear(self, bit)
	end,

	OnProductionUnpaused = function(self)
		TATarg.OnProductionUnpaused(self)
		self.IsActive = true
		--self.TAAnimating = nil
		ChangeState(self, self.OpeningState)
	end,

	OnProductionPaused = function(self)
		TATarg.OnProductionPaused(self)
		self.IsActive = nil
		--self.Closing = nil
		ChangeState(self, self.ClosingState)
	end,
}	
	
TACKFusion = Class(TAStructure) {
	OnStopBeingBuilt = function(self,builder,layer)
		TAStructure.OnStopBeingBuilt(self,builder,layer)
		self.MainCost = self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergy
		self.Mesh = self:GetBlueprint().Display.MeshBlueprint
		self.TACloak = true
		self.Structure = true
		self:SetScriptBit('RULEUTC_CloakToggle', false)
		TAStructure.OnIntelEnabled(self)
		self:RequestRefreshUI()
    end,
}

TAMine = Class(TACKFusion) {

	OnScriptBitSet = function(self, bit)
		TACKFusion.OnScriptBitSet(self, bit)
		if bit == 7 then
			self:ExplodeTA()
		end
	end,

	ExplodeTA = function(self)
		self:DisableUnitIntel('ToggleBit8', 'Cloak')
		self:GetWeaponByLabel('MINE'):FireWeapon()
	end,

	OnKilled = function(self, instigator, type, overkillRatio)
		if self.attacked then
			instigator = self
		end
		TACKFusion.OnKilled(self, instigator, type, overkillRatio)
	end,
}
