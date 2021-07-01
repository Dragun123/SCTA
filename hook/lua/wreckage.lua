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
function CreateWreckage(bp, position, orientation, mass, energy, time, deathHitBox)
    local wreck = bp.Wreckage
    local bpWreck = bp.Wreckage.Blueprint
    local prop = CreateProp(position, bpWreck)
    prop:SetOrientation(orientation, true)
    prop:SetScale(bp.Display.UniformScale)
    --LOG('*ScaleWreck', bp.Display.UniformScale)
    -- take the default center (cx, cy, cz) and size (sx, sy, sz)
    local cx, cy, cz, sx, sy, sz;
    cx = bp.CollisionOffsetX
    cy = bp.CollisionOffsetY
    cz = bp.CollisionOffsetZ
    sx = bp.SizeX
    sy = bp.SizeY
    sz = bp.SizeZ

    -- if a death animation is played the wreck hitbox may need some changes
    if deathHitBox then 
        cx = deathHitBox.CollisionOffsetX or cx 
        cy = deathHitBox.CollisionOffsetY or cy 
        cz = deathHitBox.CollisionOffsetZ or cz 
        sx = deathHitBox.SizeX or sx 
        sy = deathHitBox.SizeY or sy 
        sz = deathHitBox.SizeZ or sz 
    end

    -- adjust the size, these dimensions are in both directions based on the center
    sx = sx * 0.5
    sy = sy * 0.5
    sz = sz * 0.5

    -- create the collision box
    prop:SetPropCollision('Box', cx, cy, cz, sx, sy, sz)

    prop:SetMaxHealth(bp.Defense.Health)
    prop:SetHealth(nil, bp.Defense.Health * (bp.Wreckage.HealthMult or 1))
    prop:SetMaxReclaimValues(time, mass, energy)

    --FIXME: SetVizToNeurals('Intel') is correct here, so you can't see enemy wreckage appearing
    -- under the fog. However the engine has a bug with prop intel that makes the wreckage
    -- never appear at all, even when you drive up to it, so this is disabled for now.
    --prop:SetVizToNeutrals('Intel')
    if not bp.Wreckage.UseCustomMesh then
        prop:SetMesh(bp.Display.MeshBlueprintWrecked)
    end

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
