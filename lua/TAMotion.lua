local Unit = import('/lua/sim/Unit.lua').Unit
local explosion = import('/lua/defaultexplosions.lua')
local scenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')
local Game = import('/lua/game.lua')
local TAunit = import('/mods/SCTA-master/lua/TAunit.lua').TAunit
local util = import('/lua/utilities.lua')
local debrisCat = import('/mods/SCTA-master/lua/TAdebrisCategories.lua')

TATreads = Class(TAunit) 
{

MovementEffects = function( self, EffectsBag, TypeSuffix)
    self:LOGDBG('TATreads.MovementEffects')
    local layer = self:GetCurrentLayer()
    local bpTable = self:GetBlueprint().Display.MovementEffects
    TAunit.MovementEffects(self)
    if bpTable[layer] then
        bpTable = bpTable[layer]
        if bpTable.Treads then
            self:CreateTreads( bpTable.Treads )
        else
            self:RemoveScroller()
        end
    end
end,

CreateMotionChangeEffects = function( self, new, old )
    self:LOGDBG('TATreads.CreateMotionChangeEffects')
    local key = self:GetCurrentLayer()..old..new
    local bpTable = self:GetBlueprint().Display.MotionChangeEffects[key]
    TAunit.CreateMotionChangeEffects(self, new, old)
    if bpTable then
        self:CreateTerrainTypeEffects( bpTable.Effects, 'FXMotionChange', key )
    end
end,

DestroyMovementEffects = function( self )
    self:LOGDBG('TATreads.DestroyMovementEffects')
    local bpTable = self:GetBlueprint().Display.MovementEffects
    local layer = self:GetCurrentLayer()
    TAunit.DestroyMovementEffects(self)
    # Cleanup treads
    if self.TreadThreads then
        for k, v in self.TreadThreads do
            KillThread(v)
        end
        self.TreadThreads = {}
    end
    if bpTable[layer].Treads.ScrollTreads then
        self:RemoveScroller()
    end
end,

CreateTreads = function(self, treads)
    TAunit.CreateTreads(self, treads)
    self:LOGDBG('TATreads.CreateTreads')
    if treads.ScrollTreads then
        self:AddThreadScroller(1.0, treads.ScrollMultiplier or 0.2)
    end
    self.TreadThreads = {}
    if treads.TreadMarks then
            for k, v in treads.TreadMarks do
                table.insert( self.TreadThreads, self:ForkThread(self.CreateTreadsThread, v))
        end
    end
end,

CreateTreadsThread = function(self, treads)
    --TAunit.CreateTreadsThead(self, treads)
    self:LOGDBG('TATreads.CreateTreadsThread')
    local sizeX = treads.TreadMarksSizeX
    local sizeZ = treads.TreadMarksSizeZ
    local interval = treads.TreadMarksInterval
    local treadOffset = treads.TreadOffset
    local treadBone = treads.BoneName or 0
    local treadTexture = treads.TreadMarks
    local duration = treads.TreadLifeTime or 10
    local army = self:GetArmy()

    while true do
        # Syntatic reference
        # CreateSplatOnBone(entity, offset, boneName, textureName, sizeX, sizeZ, lodParam, duration, army)
        CreateSplatOnBone(self, treadOffset, treadBone, treadTexture, sizeX, sizeZ, 130, duration, army)
        WaitSeconds(interval)
    end
end,
}

TAWalking = Class(TATreads) 
{
    WalkingAnim = nil,
    WalkingAnimRate = 1,
    IdleAnim = false,
    IdleAnimRate = 1,
    DeathAnim = nil,
    DisabledBones = {},

    OnMotionHorzEventChange = function( self, new, old )
        self:LOGDBG('TAWalking.OnMotionHorzEventChange')
        TATreads.OnMotionHorzEventChange(self, new, old)
       
        if ( old == 'Stopped' ) then
            if (not self.Animator) then
                self.Animator = CreateAnimator(self, true)
            end
            local bpDisplay = self:GetBlueprint().Display
            if bpDisplay.AnimationWalk then
                self.Animator:PlayAnim(bpDisplay.AnimationWalk, true)
                self.Animator:SetRate(bpDisplay.AnimationWalkRate or 1)
            end
        elseif ( new == 'Stopped' ) then
            if(self.IdleAnim and not self:IsDead()) then
                self.Animator:PlayAnim(self.IdleAnim, true)
            elseif(not self.DeathAnim or not self:IsDead()) then
                self.Animator:Destroy()
                self.Animator = false
            end
        end
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        self:LOGDBG('TAWalking.OnKilled')
		TATreads.OnKilled(self, instigator, type, overkillRatio)
	end,
}

TypeClass = TAWalking
