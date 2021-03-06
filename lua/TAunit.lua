#Generic TA unit
local Unit = import('/lua/sim/Unit.lua').Unit
local FireState = import('/lua/game.lua').FireState
local TADeath = import('/mods/SCTA-master/lua/TADeath.lua')
local explosion = import('/lua/defaultexplosions.lua')
local Wreckage = import('/lua/wreckage.lua')

TAunit = Class(Unit) 
{

    --LOGDBG = function(self, msg)
	----AxleCodeUsedForDebugging
        --LOG(self._UnitName .. "(" .. self.Sync.id .. "):" .. msg)
   ---end,

	OnCreate = function(self)
        --self._UnitName = bp.General.UnitName
        ---self:LOGDBG('TAUnit.OnCreate')
        Unit.OnCreate(self)
			if self:GetAIBrain().SCTAAI then
				self:SetFireState(FireState.RETURN_FIRE)
				self.SCTAAIBrain = true
				----SCTAAIBrain is used for carious functions to check criteria including but not limited:
				--Radar Targeting, Capturing Self Destruct, and otherwise 
			else
				self:SetFireState(FireState.GROUND_FIRE)
			end
		---LOG(self:GetBlueprint().Physics.MotionType)
        end,

	OnStopBeingBuilt = function(self,builder,layer)
        ---self:LOGDBG('TAUnit.OnStopBeingBuilt')
		Unit.OnStopBeingBuilt(self,builder,layer)
		--Otherwise Memes with certain units (Roach and Invader through all SCTA Units get memed without this)
		self:SetDeathWeaponEnabled(true)
	end,

	OnDamage = function(self, instigator, amount, vector, damageType)
		Unit.OnDamage(self, instigator, amount * (self.Pack or 1), vector, damageType)
	end,

	OnStopBeingCaptured = function(self, captor)
        Unit.OnStopBeingCaptured(self, captor)
        if self.SCTAAIBrain then
            self:Kill()
        end
    end,

	OnIntelDisabled = function(self)
		Unit.OnIntelDisabled(self)
		if self.TACloak and not self:IsIntelEnabled('Cloak') then
			self:PlayUnitSound('Uncloak')
			self.CloakOn = nil
			self:SetMesh(self.Mesh, true)
			return
		elseif self.SpecIntel and (not self:IsIntelEnabled('Jammer') or not self:IsIntelEnabled('RadarStealth')) then
			self.TAIntelOn = nil
			return	
		end
	end,

	OnIntelEnabled = function(self)
		Unit.OnIntelEnabled(self)
		if not IsDestroyed(self) then
			if self:IsIntelEnabled('Cloak') and self.TACloak then
					self.CloakOn = true
					self:PlayUnitSound('Cloak')
					self:SetMesh(self:GetBlueprint().Display.CloakMeshBlueprint, true)
					ForkThread(self.CloakDetection, self)
					return
			elseif (self:IsIntelEnabled('Jammer') or self:IsIntelEnabled('RadarStealth')) and self.SpecIntel then
					self.TAIntelOn = true
					ForkThread(self.TAIntelMotion, self)
					return
			end
		end
	end,

	TAIntelMotion = function(self) 
		while not self.Dead do
            coroutine.yield(11)
			if self.TAIntelOn and (self:IsIdleState() or self:IsUnitState('Attacking')) then
                self:SetConsumptionPerSecondEnergy(self.MainCost)
			elseif self.TAIntelOn then
                self:SetConsumptionPerSecondEnergy(self.MainCost * 2)
			end
		end
    end,

	CreateTAMovementEffects = function(self)
		if not IsDestroyed(self) then
		--TAunit.CreateMovementEffects(self, EffectsBag, TypeSuffix)
		local bp = self:GetBlueprint()
		if self:IsUnitState('Moving') and bp.Display.MovementEffects.TAMovement then
			for k, v in bp.Display.MovementEffects.TAMovement.Bones do
				self.FxMovement:Add(CreateAttachedEmitter(self, v, self:GetArmy(), bp.Display.MovementEffects.TAMovement.Emitter ):ScaleEmitter(bp.Display.MovementEffects.TAMovement.Scale))
			end
		end
		if not self:IsUnitState('Moving') or table.getn(self:GetCommandQueue()) <= 1 then
			for k,v in self.FxMovement do
				v:Destroy()
			end
		end
		end
	end,

	CloakDetection = function(self)
		-----Thanks To Balth. This code Allows me to TA Proper Coding functions 
		local GetUnitsAroundPoint = moho.aibrain_methods.GetUnitsAroundPoint
		local brain = moho.entity_methods.GetAIBrain(self)
		local cat = categories.SELECTABLE * categories.MOBILE
		local getpos = moho.entity_methods.GetPosition
		while not self.Dead do
			coroutine.yield(11)
			----1 Second
			local dudes = GetUnitsAroundPoint(brain, cat, getpos(self), 4, 'Enemy')
			if self.CloakOn and self:IsUnitState('Building') then
				self:DisableIntel('Cloak')
				self:DisableIntel('CloakField')
				self:UpdateConsumptionValues()
                self:SetMesh(self.Mesh, true)
			elseif dudes[1] and self.CloakOn then
				self:DisableIntel('Cloak')
				self:DisableIntel('CloakField')
				self:SetMesh(self.Mesh, true)
				if self.Structure then
				self.TACloak = nil
				self.CloakOn = nil
				self:SetMaintenanceConsumptionInactive()
				end
			elseif not dudes[1] and self.CloakOn then
				self:EnableIntel('Cloak')
				----CLOAKField only SCTABalance
				self:EnableIntel('CloakField')
				self:SetMesh(self:GetBlueprint().Display.CloakMeshBlueprint, true)
				if self:IsIdleState() or self:IsUnitState('Attacking') then
					self:SetConsumptionPerSecondEnergy(self.MainCost)
				else
					self:SetConsumptionPerSecondEnergy(self.MainCost * 3)
				end
			end
		end
	end,

	CreateWreckage = function (self, overkillRatio)
		if overkillRatio and overkillRatio > 1.0 then
            return
        end
        if self:GetFractionComplete() < 0.5 then
            return
        end
		if overkillRatio and self:GetCurrentLayer() == 'Land' and overkillRatio >= 0.5 then
    		--LOG('*Scale', self.Scale)
			return TADeath.CreateHeapProp(self, overkillRatio)
        end
		--LOG('*Scale2', self.Scale) 
        return self:CreateWreckageProp(overkillRatio)
    end,


	OnScriptBitSet = function(self, bit)
		if self.SpecIntel and (bit == 2 or bit == 5) then
			--self:SetMaintenanceConsumptionActive()
			--self:DisableUnitIntel('ToggleBit2', 'Jammer')
			--self:DisableUnitIntel('ToggleBit5', 'RadarStealth')
            --self:DisableUnitIntel('ToggleBit5', 'RadarStealthField')
			if self.TAIntelThread then KillThread(self.TAIntelThread) end
			self.TAIntelThread = self:ForkThread(self.TAIntelMotion)	
		end
		if bit == 8 and self.TACloak then
			--self:DisableUnitIntel('ToggleBit8', 'Cloak')
			if self.CloakThread then KillThread(self.CloakThread) end
			self.CloakThread = self:ForkThread(self.CloakDetection)	
		end
		Unit.OnScriptBitSet(self, bit)
	end,

	OnScriptBitClear = function(self, bit)
		---SpecIntel for not Cloaking CounterIntel Motion 
		if self.SpecIntel and (bit == 2 or bit == 5) then
			--self:SetMaintenanceConsumptionInactive()
			if self.TAIntelThread then
				KillThread(self.TAIntelThread)
				self.TAIntelOn = nil
			end
		end
		if bit == 8 and self.TACloak then
			if self.CloakThread then
				KillThread(self.CloakThread)
				self.CloakOn = nil
			end
		end
		Unit.OnScriptBitClear(self, bit)
	end,
}
