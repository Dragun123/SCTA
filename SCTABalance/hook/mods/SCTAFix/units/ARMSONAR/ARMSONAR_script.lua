local oldARMSONAR = ARMSONAR
local TAutils = import('/mods/SCTAFix/lua/TAutils.lua')

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
}

TypeClass = ARMSONAR