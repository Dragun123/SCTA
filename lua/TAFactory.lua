local FactoryUnit = import('/lua/defaultunits.lua').FactoryUnit
local AircraftCarrier = import('/lua/defaultunits.lua').AircraftCarrier
local Unit = import('/lua/sim/Unit.lua').Unit
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')
local EffectUtil = import('/lua/EffectUtilities.lua')

TAFactory = Class(FactoryUnit) {	
		OnStartBuild = function(self, unitBeingBuilt, order )
			self:Open()
			ForkThread(self.FactoryStartBuild, self, unitBeingBuilt, order )
		end,

		FactoryStartBuild = function(self, unitBeingBuilt, order )
			WaitFor(self.AnimManip)
			FactoryUnit.OnStartBuild(self, unitBeingBuilt, order )
		end,

		Open = function(self)
		end,

		OnStopBuild = function(self, unitBeingBuilt, order)
			FactoryUnit.OnStopBuild(self, unitBeingBuilt, order)
			self:Close()
		end,

		Close = function(self)
		end,

		CreateBuildEffects = function(self, unitBeingBuilt, order)
			TAutils.CreateTAFactBuildingEffects( self, unitBeingBuilt, self.BuildEffectBones, self.BuildEffectsBag )
		end,
    }
    
    TASeaFactory = Class(TAFactory) {
    CreateBuildEffects = function(self, unitBeingBuilt, order)
        TAutils.CreateTASeaFactBuildingEffects( self, unitBeingBuilt, self.BuildEffectBones, self.BuildEffectsBag )
    end,
    }    

TACarrier = Class(AircraftCarrier) {

    CreateBuildEffects = function(self, unitBeingBuilt, order)
        TAutils.CreateTAFactBuildingEffects( self, unitBeingBuilt, self.BuildEffectBones, self.BuildEffectsBag )
    end,
	
    OnFailedToBuild = function(self)
        AircraftCarrier.OnFailedToBuild(self)
        ChangeState(self, self.IdleState)
    end,

    IdleState = State {
        Main = function(self)
            self:DetachAll(self.BuildAttachBone)
            self:SetBusy(false)
        end,

		OnStartBuild = function(self, unitBuilding, order )
			self:Open()
			self.unitBeingBuilt = unitBuilding
			ForkThread(self.FactoryStartBuild, self, unitBuilding, order )
		end,

		FactoryStartBuild = function(self, unitBuilding, order )
			WaitFor(self.AnimManip)
            AircraftCarrier.OnStartBuild(self, unitBuilding, order)
            ChangeState(self, self.BuildingState)
		end,
		
		Open = function(self)
			self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationBuild)
			self.AnimManip:SetRate(1 * (self:GetBlueprint().Display.AnimationBuildRate or 0.2))
		end,
	
    },

    BuildingState = State {
        Main = function(self)
            local unitBuilding = self.unitBeingBuilt
            self:SetBusy(true)
            local bone = self.BuildAttachBone
            self:DetachAll(bone)
            unitBuilding:HideBone(0, true)
            self.UnitDoneBeingBuilt = false
        end,

        OnStopBuild = function(self, unitBeingBuilt)
            AircraftCarrier.OnStopBuild(self, unitBeingBuilt)
            self:Close()
            ChangeState(self, self.FinishedBuildingState)
        end,
		
		Close = function(self)
			self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationBuild)
			self.AnimManip:SetRate(-1 * (self:GetBlueprint().Display.AnimationBuildRate or 0.2))
			self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationPower)
			self.AnimManip:SetRate(1 * (self:GetBlueprint().Display.AnimationPowerRate or 0.2))
		end,
    },

    FinishedBuildingState = State {
        Main = function(self)
            self:SetBusy(true)
            local unitBuilding = self.unitBeingBuilt
            unitBuilding:DetachFrom(true)
            self:DetachAll(self.BuildAttachBone)
            if self:TransportHasAvailableStorage() then
                self:AddUnitToStorage(unitBuilding)
            else
                local worldPos = self:CalculateWorldPositionFromRelative({0, 0, -20})
                IssueMoveOffFactory({unitBuilding}, worldPos)
                unitBuilding:ShowBone(0,true)
            end
            self:SetBusy(false)
			self:RequestRefreshUI()
			ChangeState(self, self.IdleState)
        end,
	},
}