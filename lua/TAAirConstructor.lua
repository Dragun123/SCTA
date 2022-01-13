local TAair = import('/mods/SCTA-master/lua/TAair.lua').TAair
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')

TAAirConstructor = Class(TAair) {
    OnCreate = function(self)
        TAair.OnCreate(self) 
    
        local bp = self:GetBlueprint()

        -- Save build effect bones for faster access when creating build effects
        self.BuildEffectBones = bp.General.BuildBones.BuildEffectBones

        self.EffectsBag = {}
        if bp.General.BuildBones then
            self:SetupBuildBones()
        end
        
        if bp.Display.AnimationBuild then
            self.BuildingOpenAnim = bp.Display.AnimationBuild
        end

        if self.BuildingOpenAnim then
            self.BuildingOpenAnimManip = CreateAnimator(self)
            self.BuildingOpenAnimManip:SetPrecedence(1)
            self.BuildingOpenAnimManip:PlayAnim(self.BuildingOpenAnim, false):SetRate(0)
            if self.BuildArmManipulator then
                self.BuildArmManipulator:Disable()
            end
        end
        self.BuildingUnit = false
    end,

    OnFailedToBuild = function(self)
        TAair.OnFailedToBuild(self)
        self:SetImmobile(false)
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        TAair.OnStopBeingBuilt(self, builder, layer)
        --[[if __blueprints['armgant'] and self.TARestrict then
            TAutils.TABuildRestrictions(self)
        end]]
        ---Testing see if desired effect is achieved here 
        ---Should reduce the raw number of calls as an engineer being built doesn't need this code 
        if __blueprints['armgant'] and not (EntityCategoryContains(categories.TECH3, self) or self:GetAIBrain().Level3) then
            TAutils.SCTAupdateBuildRestrictions(self)
        end
        self:OpenWings(self)
    end,  

    OnPaused = function(self)
        self:StopUnitAmbientSound('Construct')
        if self.BuildingUnit then
            self:UpdateConsumptionValues()
            TAair.StopBuildingEffects(self, self.UnitBeingBuilt)
        end
        TAair.OnPaused(self)
    end,

    OnUnpaused = function(self)
        if self.BuildingUnit then
            self:PlayUnitAmbientSound('Construct')
            TAair.StartBuildingEffects(self, self.UnitBeingBuilt, self.UnitBuildOrder)
            self:UpdateConsumptionValues()
        end
        TAair.OnUnpaused(self)
    end,
    
    OnStartBuild = function(self, unitBeingBuilt, order )
        self.UnitBeingBuilt = unitBeingBuilt
        self.UnitBuildOrder = order
        self.BuildingUnit = true
        TAair.OnStartBuild(self, unitBeingBuilt, order)
        if not self:GetGuardedUnit() and unitBeingBuilt:GetFractionComplete() == 0 and not self:CanBuild(unitBeingBuilt:GetBlueprint().BlueprintId) then
            IssueStop({self})
            IssueClearCommands({self})
            ---_ALERT('SCTAEXIST', unitBeingBuilt)
            unitBeingBuilt:Destroy()
        end
    end,


    OnStopBuild = function(self, unitBeingBuilt)
        self.UnitBeingBuilt = nil
        self.UnitBuildOrder = nil
        if self.BuildingOpenAnimManip and self.BuildArmManipulator then
            self.StoppedBuilding = true
        elseif self.BuildingOpenAnimManip then
            self.BuildingOpenAnimManip:SetRate(-1)
        end
        self.BuildingUnit = false
        self:SetImmobile(false)
        TAair.OnStopBuild(self,unitBeingBuilt)
    end,

    WaitForBuildAnimation = function(self, enable)
        if self.BuildArmManipulator then
            WaitFor(self.BuildingOpenAnimManip)
            if enable then
                self.BuildArmManipulator:Enable()
            end
        end
    end,
    
    OnStopBuilderTracking = function(self)
        TAair.OnStopBuilderTracking(self)
        if self.StoppedBuilding then
            self.StoppedBuilding = false
            self.BuildArmManipulator:Disable()
            self.BuildingOpenAnimManip:SetRate(-(self:GetBlueprint().Display.AnimationBuildRate or 1))
            self:SetImmobile(false)
        end
    end,

    OnPrepareArmToBuild = function(self)
        TAair.OnPrepareArmToBuild(self)  
        if self.BuildingOpenAnimManip then
            self.BuildingOpenAnimManip:SetRate(self:GetBlueprint().Display.AnimationBuildRate or 1)
            if self.BuildArmManipulator then
                self.StoppedBuilding = false
                self:ForkThread(self.WaitForBuildAnimation, true)
            end
        end
        if self:IsMoving() then
            self:SetImmobile(true)
            self:ForkThread(function() WaitTicks(1) if not self:BeenDestroyed() then self:SetImmobile(false) end end)
        end
    end,

    OnStopReclaim = function(self, target)
        TAair.OnStopReclaim(self, target)
        if self.BuildingOpenAnimManip then
            self.BuildingOpenAnimManip:SetRate(-1)
        end
    end,

    CreateBuildEffects = function( self, unitBeingBuilt, order )
        self.BuildEffectsBag:Add( TAutils.CreateTAAirBuildingEffects( self, unitBeingBuilt, self.BuildEffectBones, self.BuildEffectsBag ))
    end,

    CreateReclaimEffects = function( self, target )
        self.ReclaimEffectsBag:Add(TAutils.TAAirReclaimEffects(self, target, self.BuildEffectBones or {0, }, self.ReclaimEffectsBag))
    end,
     
}