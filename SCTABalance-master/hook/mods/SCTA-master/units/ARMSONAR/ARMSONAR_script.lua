local oldARMSONAR = ARMSONAR
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')

ARMSONAR = Class(oldARMSONAR) {
	OnStopBuild = function(self, unitBuilding)
		 oldARMSONAR.OnStopBuild(self, unitBuilding)
		 if unitBuilding:GetFractionComplete() == 1 and unitBuilding:GetUnitId() == self:GetBlueprint().General.UpgradesTo then
			 NotifyUpgrade(self, unitBuilding)
			 self:Destroy()
		 end
	 end,

	 OnStopBeingBuilt = function(self,builder,layer)
		oldARMSONAR.OnStopBeingBuilt(self,builder,layer)
		self:PlayUnitSound('Activate')
		TAutils.registerTargetingFacility(self:GetArmy())
	end,

	OnScriptBitSet = function(self, bit)
		if bit == 3 then
			self:PlayUnitSound('Deactivate')
			TAutils.unregisterTargetingFacility(self:GetArmy())
		end
		oldARMSONAR.OnScriptBitSet(self, bit)
	end,

	OnScriptBitClear = function(self, bit)
		if bit == 3 then
			self:PlayUnitSound('Activate')
			TAutils.registerTargetingFacility(self:GetArmy())
		end
		oldARMSONAR.OnScriptBitClear(self, bit)
	end,
}

TypeClass = ARMSONAR