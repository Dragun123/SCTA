local FactoryUnit = import('/lua/defaultunits.lua').FactoryUnit
local StructureUnit = import('/lua/defaultunits.lua').StructureUnit
local Unit = import('/lua/sim/Unit.lua').Unit
local AircraftCarrier = import('/lua/defaultunits.lua').AircraftCarrier
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')

TAFactory = Class(FactoryUnit) {
    OnCreate = function(self)
    FactoryUnit.OnCreate(self)
    self.AnimManip = CreateAnimator(self)
    self.Trash:Add(self.AnimManip)
    if __blueprints['armgant'] and not (EntityCategoryContains(categories.TECH3 + categories.GATE, self) or self:GetAIBrain().Level3) then
        TAutils.SCTAupdateBuildRestrictions(self)
    end
end,

    OnStopBeingBuilt = function(self, builder, layer)
        FactoryUnit.OnStopBeingBuilt(self, builder, layer)
        local aiBrain = GetArmyBrain(self.Army)
        ----If We are Level 3 stop checking now
            if __blueprints['armgant'] and not aiBrain.Level3 then
                    local buildRestrictionVictims = aiBrain:GetListOfUnits(categories.FACTORY + categories.ENGINEER, false)
                for id, unit in buildRestrictionVictims do    
                    TAutils.TABuildRestrictions(unit)
                end
            end
        end,

        OnStartBuild = function(self, unitBeingBuilt, order )
            if not Unit.OnStartBuild(self, unitBeingBuilt, order) then
                return
            end
            --self.UnitBeingBuilt = unitBeingBuilt
            if not self.TABuildingUnit then
                self:Open()
                ForkThread(self.FactoryStartBuild, self, unitBeingBuilt, order )
                self.TABuildingUnit = true
                return
            end
            FactoryUnit.OnStartBuild(self, unitBeingBuilt, order )
		end,

        FactoryStartBuild = function(self, unitBeingBuilt, order )
            --self.UnitBeingBuilt = unitBeingBuilt
            WaitFor(self.AnimManip)
            if not self.Dead and not IsDestroyed(unitBeingBuilt) then    
            FactoryUnit.OnStartBuild(self, unitBeingBuilt, order )
            end
        end,

		Open = function(self)
            self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationUnpack)
            self.AnimManip:SetRate(1 * (self:GetBlueprint().Display.AnimationUnpackRate or 0.2))  
        end,


        DoStopBuild = function(self, unitBeingBuilt, order)
            LOG('SCTAIEXIST', self.TABuildingUnit)
            StructureUnit.OnStopBuild(self, unitBeingBuilt, order)
            if not self.FactoryBuildFailed and not self.Dead then
                    if not EntityCategoryContains(categories.AIR, unitBeingBuilt) then
                        self:RollOffUnit()
                    end
                self:StopBuildFx()
                self:ForkThread(self.FinishBuildThread, unitBeingBuilt, order)
            else
                self:Close()
                    ---TABuildingUnit is used by AI to see if it is building or not. 
                self.TABuildingUnit = nil
                self.BuildingUnit = false
            end
        end,

        FinishBuildThread = function(self, unitBeingBuilt, order)
            self:SetBusy(true)
            self:SetBlockCommandQueue(true)
            local bp = self:GetBlueprint()
            if unitBeingBuilt and not unitBeingBuilt.Dead then
                unitBeingBuilt:DetachFrom(true)
            end
            self:DetachAll(bp.Display.BuildAttachBone or 0)
            self:DestroyBuildRotator()
            if order ~= 'Upgrade' then
                ChangeState(self, self.RollingOffState)
            else
                self:SetBusy(false)
                self:SetBlockCommandQueue(false)
            end
            if table.getn(self:GetCommandQueue()) <= 1 then
                ----ThisCode is used to make sure it open and closes correctly
                WaitTicks(20)
                self:Close()
                    ---TABuildingUnit is used by AI to see if it is building or not. 
                self.TABuildingUnit = nil
            end
            self.BuildingUnit = false
        end,
        

		Close = function(self)
            self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationUnpack)
            self.AnimManip:SetRate(-0.01)
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
    
    TASeaPlat = Class(TAFactory) {
    
    OnStopBeingBuilt = function(self, builder, layer)
        TAFactory.OnStopBeingBuilt(self, builder, layer)
        self:DisableIntel('RadarStealth')
            if self.Layer == 'Sub' then
            self.Chassis = CreateSlider(self, 0)
            self.Trash:Add(self.Chassis)
            self.bp = self:GetBlueprint()
            self.scale = 0.5
            self.Water = true
            ---creates a collision box if below surface if unit is on the water
            ---based on Balth Dummy Code from BrewLan 
            self:SetCollisionShape( 'Box', self.bp.CollisionOffsetX or -5,(self.bp.CollisionOffsetY + (self.bp.SizeY*-0.5)) or 0,self.bp.CollisionOffsetZ or -5, self.bp.SizeX * self.scale, self.bp.SizeY * self.scale, self.bp.SizeZ * self.scale )
            self:WaterFall()
            end
        end,
    
        OnDestroy = function(self)
            if self.GeneratorCollision then
            self.GeneratorCollision:Destroy()
            self.GeneratorCollision = nil
            end
            TAFactory.OnDestroy(self)
        end,

    Open = function(self)
        if self.Water then
            self:WaterRise()
        end
        TAFactory.Open(self)
    end,

    Close = function(self)
		TAFactory.Close(self)
        if self.Water then
		self:WaterFall()
        end
        --LOG('TALayer2', self:GetCurrentLayer())
	end,

    WaterFall = function(self)
        self:EnableIntel('RadarStealth')
        if self.GeneratorCollision then
            ---if the unit falls then the box is destroyed again
            self.GeneratorCollision:Destroy()
            self.GeneratorCollision = nil
        end
    end,

    WaterRise = function(self)
        if not self.GeneratorCollision then
            local pos = self:GetPosition()
            ---created by rising code when the factory rises 
            self.GeneratorCollision = CreateUnitHPR('Falling',self:GetArmy(),pos[1],pos[2],pos[3],0,0,0)
            self.GeneratorCollision:SetCollisionShape( 'Box', self.bp.CollisionOffsetX or 0,(self.bp.CollisionOffsetY + (self.bp.SizeY*0.5)) or 0,self.bp.CollisionOffsetZ or 0, self.bp.SizeX * self.scale, self.bp.SizeY * self.scale, self.bp.SizeZ * self.scale )
            --self.GeneratorCollision:
            self.GeneratorCollision.Parent = self
            self:DisableIntel('RadarStealth')
        end
    end,
    }

    TAGantry = Class(TAFactory) {

            CreateBuildEffects = function(self, unitBeingBuilt, order)
                TAutils.CreateTAGantBuildingEffects( self, unitBeingBuilt, self.BuildEffectBones, self.BuildEffectsBag )
            end,

            OnStartBuild = function(self, unitBeingBuilt, order )
                --self.UnitBeingBuilt = unitBeingBuilt
                if not self.TABuildingUnit then
                    unitBeingBuilt:HideBone(0, true)
                    self:Open()
                    ForkThread(self.FactoryStartBuild, self, unitBeingBuilt, order )
                    self.TABuildingUnit = true
                    return
                end
                FactoryUnit.OnStartBuild(self, unitBeingBuilt, order )
            end,
    
            FactoryStartBuild = function(self, unitBeingBuilt, order )
                WaitFor(self.AnimManip)
                if not self.Dead and not IsDestroyed(unitBeingBuilt) then   
                unitBeingBuilt:ShowBone(0, true)     
                FactoryUnit.OnStartBuild(self, unitBeingBuilt, order )
                end
            end,
            
            Close = function(self)
                self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationPack)
                self.AnimManip:SetRate(1 * (self:GetBlueprint().Display.AnimationPackRate or 0.2))
            end,
    
        }

TACarrier = Class(AircraftCarrier) {
    OnCreate = function(self)
        AircraftCarrier.OnCreate(self)
        self.BuildEffectBones = self:GetBlueprint().General.BuildBones.BuildEffectBones
    end,

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
            self.unitBeingBuilt = unitBuilding
                if not self.TABuildingUnit then
			        self:Open()
			        ForkThread(self.FactoryStartBuild, self, unitBuilding, order )
                    self.TABuildingUnit = true
                return
            end
            AircraftCarrier.OnStartBuild(self, unitBuilding, order)
            ChangeState(self, self.BuildingState)
		end,

		FactoryStartBuild = function(self, unitBuilding, order )
			WaitFor(self.AnimManip)
            if not self.Dead and not IsDestroyed(unitBuilding) then
                AircraftCarrier.OnStartBuild(self, unitBuilding, order)
                ChangeState(self, self.BuildingState)
            end
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
            ChangeState(self, self.FinishedBuildingState)
            self.BuildingUnit = false
        end,
	
    },

    FinishedBuildingState = State {
        Main = function(self)
            self:SetBusy(true)
            local unitBuilding = self.unitBeingBuilt
            unitBuilding:DetachFrom(true)
            self:DetachAll(self.BuildAttachBone)
            if self:TransportHasAvailableStorage() and not self.SCTAAIBrain then
                self:AddUnitToStorage(unitBuilding)
            else
                local worldPos = self:CalculateWorldPositionFromRelative({0, 0, -20})
                IssueMoveOffFactory({unitBuilding}, worldPos)
                unitBuilding:ShowBone(0,true)
            end
            if table.getn(self:GetCommandQueue()) <= 1 then
                ----ThisCode is used to make sure it open and closes correctly
                WaitTicks(20)
                self:Close()
                self.TABuildingUnit = nil
            end
            self:SetBusy(false)
			self:RequestRefreshUI()
			ChangeState(self, self.IdleState)
        end,

        Close = function(self)
			self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationBuild)
			self.AnimManip:SetRate(-1 * (self:GetBlueprint().Display.AnimationBuildRate or 0.2))
			self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationPower)
			self.AnimManip:SetRate(1 * (self:GetBlueprint().Display.AnimationPowerRate or 0.2))
        end,
	},
}