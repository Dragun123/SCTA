#CORE Targeting Facility - Automatic Radar Targeting
#CORTARG
#
#Script created by Raevn

local TAStructure = import('/mods/SCTA-master/lua/TAStructure.lua').TAStructure
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')

CORTARG = Class(TAStructure) {
	OnCreate = function(self)
		TAStructure.OnCreate(self)
		self.AnimManip = CreateAnimator(self)
		self.Trash:Add(self.AnimManip)
	end,

	OnStopBeingBuilt = function(self,builder,layer)
		TAStructure.OnStopBeingBuilt(self,builder,layer)
		ForkThread(self.Open, self)
		self:PlayUnitSound('Activate')
	end,

	OnScriptBitSet = function(self, bit)
		if bit == 3 then
			self:PlayUnitSound('Deactivate')
    		ForkThread(self.Close, self)
		end
		TAStructure.OnScriptBitSet(self, bit)
	end,

	OnScriptBitClear = function(self, bit)
		if bit == 3 then
			self:PlayUnitSound('Activate')
			ForkThread(self.Open, self)
		end
		TAStructure.OnScriptBitClear(self, bit)
	end,

	Open = function(self)
		self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationUnpack)
		self.AnimManip:SetRate(1 * (self:GetBlueprint().Display.AnimationUnpackRate or 0.2))
		TAStructure.Unfold(self)
                WaitSeconds(1.2)
		self:SetMaintenanceConsumptionActive()
	end,

	Close = function(self)
		if self.AnimManip then
		self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationUnpack)
		self.AnimManip:SetRate(-1 * (self:GetBlueprint().Display.AnimationUnpackRate or 0.2))
                WaitFor(self.AnimManip)
		TAStructure.Fold(self)
		self:SetMaintenanceConsumptionInactive()
		end
	end,
}

TypeClass = CORTARG