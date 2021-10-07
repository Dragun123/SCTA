local taUnitClass = Unit
local FireState = import('/lua/game.lua').FireState
local TADeath = import('/mods/SCTA-master/lua/TADeath.lua')
Unit = Class(taUnitClass) {

    OnStopBeingBuilt = function(self,builder,layer)
        --self._UnitName = bp.General.UnitName
        ---self:LOGDBG('TAUnit.OnCreate')
        taUnitClass.OnStopBeingBuilt(self,builder,layer)
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

    CreateWreckage = function (self, overkillRatio)
        if self.Necro then
            TADeath.CreateHeapProp(self, overkillRatio)
        else
            taUnitClass.CreateWreckage(self, overkillRatio)
        end
    end,

    OnStopBeingCaptured = function(self, captor)
        taUnitClass.OnStopBeingCaptured(self, captor)
        if self.SCTAAIBrain then
            self:Kill()
        end
    end,

}