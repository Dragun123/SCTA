#****************************************************************************
#**
#**  File     :  /cdimage/units/UAL0001/UAL0001_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix, Gordon Duclos
#**
#**  Summary  :  Aeon Commander Script
#**
#**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local oldXSL0001 = XSL0001
XSL0001 = Class(oldXSL0001) {
    PlayCommanderWarpInEffect = function(self)
        self:HideBone(0, true)
        self:SetUnSelectable(false)
        self:SetBusy(true)
        self:SetBlockCommandQueue(true)
        self:ForkThread(self.WarpInEffectThread)
    end,

    OnStopBeingBuilt = function(self, builder, layer)
        oldXSL0001.OnStopBeingBuilt(self, builder, layer)
        if __blueprints['eal0001'] then
            local position = self:GetPosition()
            local cdrUnit = CreateUnitHPR('esl0001', self:GetArmy(), (position.x), (position.y+1), (position.z), 0, 0, 0)  
            cdrUnit:ForkThread(cdrUnit.PlayCommanderWarpInEffect)
            self:Destroy()
        end
    end,
}

TypeClass = XSL0001