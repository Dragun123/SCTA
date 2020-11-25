local TAWalking = import('/mods/SCTA-master/lua/TAMotion.lua').TAWalking
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon

ARMPW = Class(TAWalking) {
    Weapons = {
        EMG = Class(TAweapon) {},
    },

    OnMotionHorzEventChange = function( self, new, old )
        TAWalking.OnMotionHorzEventChange(self, new, old)
        if new == 'TopSpeed' then
            local bpDisplay = self:GetBlueprint().Display
            local animF = self.Animator:GetAnimationFraction()
            self.Animator:PlayAnim(bpDisplay.AnimationRun, true)
            self.Animator:SetAnimationFraction(animF)
            self.Animator:SetRate(bpDisplay.AnimationRunRate or 0.5)
        end
    end,
--[[ 
    MovementEffects = function(self)
        --The parent loops over a table without checking it's actually there.
    end,]]
}

TypeClass = ARMPW
