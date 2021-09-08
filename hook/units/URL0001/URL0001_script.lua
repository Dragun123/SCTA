#****************************************************************************
#**
#**  File     :  /cdimage/units/UAL0001/UAL0001_script.lua
#**  Author(s):  John Comes, David Tomandl, Jessica St. Croix, Gordon Duclos
#**
#**  Summary  :  Aeon Commander Script
#**
#**  Copyright � 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************
local taURL0001 = URL0001
URL0001 = Class(taURL0001) {
    OnStopBeingBuilt = function(self, builder, layer)
        taURL0001.OnStopBeingBuilt(self, builder, layer)
        if __blueprints['eal0001'] then
            ForkThread(self.BlackOps, self, builder, layer)
            self:Destroy()
        end
    end,

    BlackOps = function (self, builder, layer)
            local position = self:GetPosition()
            local cdrUnit = CreateUnitHPR('erl0001', self:GetArmy(), (position.x), (position.y+1), (position.z), 0, 0, 0)  
            cdrUnit:HideBone(0, true)
            cdrUnit:SetUnSelectable(false)
		    cdrUnit:SetBlockCommandQueue(true)
		    --WaitSeconds(2)
            coroutine.yield(21)
		    cdrUnit:ForkThread(cdrUnit.PlayCommanderWarpInEffect, bones)
    end,

}

TypeClass = URL0001