local Unit = import('/lua/sim/Unit.lua').Unit
local explosion = import('/lua/defaultexplosions.lua')
local scenarioUtils = import('/lua/sim/ScenarioUtilities.lua')
local TAutils = import('/mods/SCTAFix/lua/TAutils.lua')
local Game = import('/lua/game.lua')
local TAunit = import('/mods/SCTAFix/lua/TAunit.lua').TAunit
local util = import('/lua/utilities.lua')
local debrisCat = import('/mods/SCTAFix/lua/TAdebrisCategories.lua')


TATreads = Class(TAunit) 
{

MovementEffects = function( self, EffectsBag, TypeSuffix)
    local layer = self:GetCurrentLayer()
    local bpTable = self:GetBlueprint().Display.MovementEffects

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
    local key = self:GetCurrentLayer()..old..new
    local bpTable = self:GetBlueprint().Display.MotionChangeEffects[key]

    if bpTable then
        self:CreateTerrainTypeEffects( bpTable.Effects, 'FXMotionChange', key )
    end
end,

DestroyMovementEffects = function( self )
    local bpTable = self:GetBlueprint().Display.MovementEffects
    local layer = self:GetCurrentLayer()

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
    if treads.ScrollTreads then
        self:AddThreadScroller(1.0, treads.ScrollMultiplier or 0.2)
    end
    self.TreadThreads = {}
    if treads.TreadMarks then
        local type = self:GetTTTreadType(self:GetPosition())
        if type != 'None' then
            for k, v in treads.TreadMarks do
                table.insert( self.TreadThreads, self:ForkThread(self.CreateTreadsThread, v, type ))
            end
        end
    end
end,

CreateTreadsThread = function(self, treads, type )
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