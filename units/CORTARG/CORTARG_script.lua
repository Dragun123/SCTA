#CORE Targeting Facility - Automatic Radar Targeting
#CORTARG
#
#Script created by Raevn

local TAunit = import('/mods/SCTAFix/lua/TAunit.lua').TAunit
local TAutils = import('/mods/SCTAFix/lua/TAutils.lua')

CORTARG = Class(TAunit) {
	damageReduction = 1,

	OnCreate = function(self)
		TAunit.OnCreate(self)
		self.AnimManip = CreateAnimator(self)
		self.Trash:Add(self.AnimManip)
	end,

	OnDamage = function(self, instigator, amount, vector, damageType)
		TAunit.OnDamage(self, instigator, amount * self.damageReduction, vector, damageType) 
		#Has Damage Reduction
	end,

	OnKilled = function(self, instigator, type, overkillRatio)
            if (self:GetScriptBit(3) == false) then
	        TAutils.unregisterTargetingFacility(self:GetArmy())
            end
            TAunit.OnKilled(self, instigator, type, overkillRatio)
        end,

	OnStopBeingBuilt = function(self,builder,layer)
		TAunit.OnStopBeingBuilt(self,builder,layer)
		ForkThread(self.Open, self)
		self:PlayUnitSound('Activate')
		TAutils.registerTargetingFacility(self:GetArmy())
	end,

	OnScriptBitSet = function(self, bit)
		if bit == 3 then
			self:PlayUnitSound('Deactivate')
    		ForkThread(self.Close, self)
			TAutils.unregisterTargetingFacility(self:GetArmy())
		end
		TAunit.OnScriptBitSet(self, bit)
	end,

	OnScriptBitClear = function(self, bit)
		if bit == 3 then
			self:PlayUnitSound('Activate')
			ForkThread(self.Open, self)
			TAutils.registerTargetingFacility(self:GetArmy())
		end
		TAunit.OnScriptBitClear(self, bit)
	end,

	Open = function(self)
		self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationUnpack)
		self.AnimManip:SetRate(1 * (self:GetBlueprint().Display.AnimationUnpackRate or 0.2))
		self.damageReduction = 1
                WaitSeconds(1.2)
		self:SetMaintenanceConsumptionActive()
	end,

	Close = function(self)
		if self.AnimManip then
		self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationUnpack)
		self.AnimManip:SetRate(-1 * (self:GetBlueprint().Display.AnimationUnpackRate or 0.2))
                WaitFor(self.AnimManip)
		self.damageReduction = 0.7
		self:SetMaintenanceConsumptionInactive()
		end
	end,
}

TypeClass = CORTARG