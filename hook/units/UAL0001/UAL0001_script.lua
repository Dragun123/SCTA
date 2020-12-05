#****************************************************************************
#**
#**  File     :  /cdimage/units/UAL0001/UAL0001_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix, Gordon Duclos
#**
#**  Summary  :  Aeon Commander Script
#**
#**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local oldUAL0001 = UAL0001
UAL0001 = Class(oldUAL0001) {
    PlayCommanderWarpInEffect = function(self)
        self:HideBone(0, true)
        self:SetUnSelectable(false)
        self:SetBusy(true)
        self:SetBlockCommandQueue(true)
        self:ForkThread(self.WarpInEffectThread)
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        oldUAL0001.OnStopBeingBuilt(self, builder, layer)
        self:ForkThread(self.PlayCommanderWarpInEffect) --should only be used for testing out the drop animation
    end,

}

TypeClass = UAL0001