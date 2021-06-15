#ARM Merl Rocket
#ARMTRUCK_ROCKET
#
#Script created by Raevn

local TAMissileProjectile = import('/mods/SCTA-master/lua/TAprojectiles.lua').TAMissileProjectile

BHRK_ROCKET = Class(TAMissileProjectile) {
    TrackingThread = function(self)
    if self:GetDistanceToTarget() > self:GetBlueprint().Physics.TargetDistance then
        TAMissileProjectile.TrackingThread(self)
    end
end,

GetDistanceToTarget = function(self)
    local tpos = self:GetCurrentTargetPosition()
    local mpos = self:GetPosition()
    local dist = VDist2(mpos[1], mpos[3], tpos[1], tpos[3])
    return dist
end,
}

TypeClass = BHRK_ROCKET