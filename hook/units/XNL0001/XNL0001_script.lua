local taXNL0001 = XNL0001
XNL0001 = Class(taXNL0001) {
    PlayCommanderWarpInEffect = function(self)  -- part of initial dropship animation
        self:SetCustomName( ArmyBrains[self:GetArmy()].Nickname )
        self:SetUnSelectable(false)
        self:SetBlockCommandQueue(true)
        self.PlayCommanderWarpInEffectFlag = true
        coroutine.yield(21)
        self:ForkThread(self.DoMeteorAnim)
    end,

    DoMeteorAnim = function(self)
    taXNL0001.DoMeteorAnim(self)
    local rotateOpt = ScenarioInfo.Options['RotateACU']
    if not rotateOpt or rotateOpt == 'On' then
        self:RotateTowardsMid()
    elseif rotateOpt == 'Marker' then
        local marker = GetMarker(strArmy) or {}
        if marker['orientation'] then
            local o = EulerToQuaternion(unpack(marker['orientation']))
            self:SetOrientation(o, true)
        end
        end
    end,
}

TypeClass = XNL0001
