local oldXNL0001 = XNL0001
XNL0001 = Class(oldXNL0001) {
    PlayCommanderWarpInEffect = function(self)  -- part of initial dropship animation
        self:SetUnSelectable(false)
        self:SetBusy(true)
        self:SetBlockCommandQueue(true)
        self.PlayCommanderWarpInEffectFlag = true
        self:ForkThread(self.DoMeteorAnim)
    end,


    OnStopBeingBuilt = function(self, builder, layer)
        oldXNL0001.OnStopBeingBuilt(self, builder, layer)
        self:ForkThread(self.PlayCommanderWarpInEffect) --should only be used for testing out the drop animation
    end,

}

TypeClass = XNL0001
