--****************************************************************************
--**
--**  File     : /lua/wreckage.lua
--**
--**  Summary  : Class for wreckage so it can get pushed around
--**
--**  Copyright 2006 Gas Powered Games, Inc.  All rights reserved.
--***************************************************************************
--- Create a wreckage prop.
---THIS IS A DESTRUCTIVE HOOK. There is no other way to make this work as intended for Heaps or easily enough
local TotalWreckage = Wreckage

Wreckage = Class(TotalWreckage) {

GetReclaimCosts = function(self, reclaimer)
    if self.NecroingInProgress then
        local time = self.TimeReclaim * (math.max(self.MaxMassReclaim, self.MaxEnergyReclaim) / reclaimer:GetBuildRate())
        time = math.max(time / 10, 0.0001)
       --LOG('self.NecroingInProgress = true, returning nil eco')
       return time, 1, 1
    else
    --LOG('self.NecroingInProgress = false, returning full eco')
    return TotalWreckage.GetReclaimCosts(self, reclaimer)
    end
end,

}

do
    local oldCreateWreckage = CreateWreckage
    function CreateWreckage(bp, position, orientation, mass, energy, time, deathHitBox)
        local prop = oldCreateWreckage(bp, position, orientation, mass, energy, time, deathHitBox)

        -- This field cannot be renamed or the magical native code that detects rebuild bonuses breaks.
        prop.AssociatedBP = bp.Wreckage.IdHook or bp.BlueprintId
        ---THIS is the Code for determining Associated Scale. Called and Used by CreateHeaps. 
        ---Everything else is the basic vanilla FAF code. Except for a disabled log. And removed write space. 
        if string.find(prop.AssociatedBP, 'arm') or string.find(prop.AssociatedBP, 'cor') then
            ---Hopefully this will save some system memory limiting the amount of wrecks the game has to rememeber 
            prop.AssociatedBPScale = bp.Display.UniformScale
            ---LOG('*MassWreckSca', prop.AssociatedBPScale)
            ---LOG('*MassWreckName', prop.AssociatedBP)
        end

        return prop
    end
end