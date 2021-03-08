#Generic TA unit
local Unit = import('/lua/sim/Unit.lua').Unit
local FireState = import('/lua/game.lua').FireState
local explosion = import('/lua/defaultexplosions.lua')
local scenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')
local Game = import('/lua/game.lua')
local util = import('/lua/utilities.lua')

TAunit = Class(Unit) 
{

    --LOGDBG = function(self, msg)
        --LOG(self._UnitName .. "(" .. self.Sync.id .. "):" .. msg)
   ---end,

	OnCreate = function(self)
		local bp = self:GetBlueprint()
        --self._UnitName = bp.General.UnitName
        ---self:LOGDBG('TAUnit.OnCreate')
        Unit.OnCreate(self)
		self:SetFireState(FireState.GROUND_FIRE)
        end,

	OnStopBeingBuilt = function(self,builder,layer)
        ---self:LOGDBG('TAUnit.OnStopBeingBuilt')
		Unit.OnStopBeingBuilt(self,builder,layer)
		self:SetDeathWeaponEnabled(true)
		---self:SetConsumptionActive(true)	
	end,

	OnDamage = function(self, instigator, amount, vector, damageType)
		Unit.OnDamage(self, instigator, amount * (self.Pack or 1), vector, damageType)
	end,

	OnIntelDisabled = function(self)
		Unit.OnIntelDisabled()
		if EntityCategoryContains(categories.JAM, self) and (not self:IsIntelEnabled('Jammer') or not self:IsIntelEnabled('RadarStealth')) then
			self.TAIntelOn = nil	
		elseif EntityCategoryContains(categories.TACLOAK, self) and not self:IsIntelEnabled('Cloak') then
		self:PlayUnitSound('Uncloak')
		self.CloakOn = nil
		self:SetMesh(self:GetBlueprint().Display.MeshBlueprint, true)
		end
	end,

	OnIntelEnabled = function(self)
		Unit.OnIntelEnabled()
		if not IsDestroyed(self) then
			if EntityCategoryContains(categories.JAM, self) and (self:IsIntelEnabled('Jammer') or self:IsIntelEnabled('RadarStealth')) then
				self.TAIntelOn = true
				ForkThread(self.TAIntelMotion, self)
			elseif EntityCategoryContains(categories.TACLOAK, self) and self:IsIntelEnabled('Cloak') then
			self.CloakOn = true
			self:PlayUnitSound('Cloak')
			self:SetMesh(self:GetBlueprint().Display.CloakMeshBlueprint, true)
			ForkThread(self.CloakDetection, self)
			end
		end
	end,

	TAIntelMotion = function(self) 
		while not self.Dead do
            coroutine.yield(11)
            if self.TAIntelOn and self:IsUnitState('Moving') then
                self:SetConsumptionPerSecondEnergy(self:GetBlueprint().Economy.TAConsumptionPerSecondEnergy)
			elseif self.TAIntelOn then
                self:SetConsumptionPerSecondEnergy(self:GetBlueprint().Economy.MaintenanceConsumptionPerSecondEnergy)
            end
		end
    end,

	CloakDetection = function(self)
		local GetUnitsAroundPoint = moho.aibrain_methods.GetUnitsAroundPoint
		local brain = moho.entity_methods.GetAIBrain(self)
		local cat = categories.SELECTABLE * categories.MOBILE
		local getpos = moho.entity_methods.GetPosition
		while not self.Dead do
			coroutine.yield(11)
			local bp = self:GetBlueprint()
			if self.CloakOn and self:IsUnitState('Moving') then
                self:SetConsumptionPerSecondEnergy(bp.Economy.TAConsumptionPerSecondEnergy)
			elseif self.CloakOn then
                self:SetConsumptionPerSecondEnergy(bp.Economy.MaintenanceConsumptionPerSecondEnergy)
			local dudes = GetUnitsAroundPoint(brain, cat, getpos(self), 4, 'Enemy')
			if self.CloakOn and self:IsUnitState('Building') then
				self:DisableIntel('Cloak')
				self:UpdateConsumptionValues()
                self:SetMesh(bp.Display.MeshBlueprint, true)
			elseif dudes[1] and self.CloakOn then
				self:DisableIntel('Cloak')
				self:SetMesh(bp.Display.MeshBlueprint, true)
			elseif not dudes[1] and self.CloakOn then
				self:EnableIntel('Cloak')
				---self:UpdateConsumptionValues()
				self:SetMesh(bp.Display.CloakMeshBlueprint, true)
			end
		end
		end
	end,



	ShouldWatchIntel = function(self)
		local bp = self:GetBlueprint()
        if bp.Intel.FreeIntel then
            return false
        end
        local bpVal = bp.Economy.MaintenanceConsumptionPerSecondEnergy or bp.Economy.MaintenanceConsumptionPerSecondEnergy
        local watchPower = false
        if bpVal and bpVal > 0 then
            local intelTypeTbl = {'JamRadius', 'SpoofRadius'}
            local intelTypeBool = {'RadarStealth', 'SonarStealth', 'Cloak'}
            local intelTypeNum = {'RadarRadius', 'SonarRadius', 'OmniRadius', 'RadarStealthFieldRadius', 'SonarStealthFieldRadius', 'CloakFieldRadius', }
            local bpInt = bp.Intel
            if bpInt then
                for _, v in intelTypeTbl do
                    for ki, vi in bpInt[v] do
                        if vi > 0 then
                            watchPower = true
                            break
                        end
                    end
                    if watchPower then break end
                end
                for _, v in intelTypeBool do
                    if bpInt[v] then
                        watchPower = true
                        break
                    end
                end
                for _, v in intelTypeNum do
                    if bpInt[v] > 0 then
                        watchPower = true
                        break
                    end
                end
            end
        end
        return watchPower
    end,

	OnScriptBitSet = function(self, bit)
		if bit == 2 or bit == 5 and EntityCategoryContains(categories.JAM, self) then
			--self:SetMaintenanceConsumptionActive()
			self:DisableUnitIntel('ToggleBit2', 'Jammer')
			self:DisableUnitIntel('ToggleBit5', 'RadarStealth')
            self:DisableUnitIntel('ToggleBit5', 'RadarStealthField')
			if self.TAIntelThread then KillThread(self.TAIntelThread) end
			self.TAIntelThread = self:ForkThread(self.TAIntelMotion)	
		end
		if bit == 8 then
			self:DisableUnitIntel('ToggleBit8', 'Cloak')
			if self.CloakThread then KillThread(self.CloakThread) end
			self.CloakThread = self:ForkThread(self.CloakDetection)	
		end
		Unit.OnScriptBitSet(self, bit)
	end,

	OnScriptBitClear = function(self, bit)
		if bit == 2 or bit == 5 and EntityCategoryContains(categories.JAM, self) then
			--self:SetMaintenanceConsumptionInactive()
			if self.TAIntelThread then
				KillThread(self.TAIntelThread)
				self.TAIntelOn = nil
			end
		end
		if bit == 8 then
			if self.CloakThread then
				KillThread(self.CloakThread)
				self.CloakOn = nil
			end
		end
		Unit.OnScriptBitClear(self, bit)
	end,
}
