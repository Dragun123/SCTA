---local WEIRD = categories.SUBCOMMANDER + categories.AIR + categories.NAVAL + categories.FIELDENGINEER

function GetCheck(id)
    if id == 'engineer' and controls.idleEngineers then
        --LOG('engineer')
        return controls.idleEngineers.expandCheck
        elseif id == 'fieldengineer' and controls.idleFieldEngineers then
            --LOG('engineer')
            return controls.idleFieldEngineers.expandCheck
        elseif id == 'terrainengineer' and controls.idleTerrainEngineers then
            --LOG('engineer')
            return controls.idleTerrainEngineers.expandCheck
        elseif id == 'factory' and controls.idleFactories then
        return controls.idleFactories.expandCheck
    end
end

function AvatarUpdate()
    if import('/lua/ui/game/gamemain.lua').IsNISMode() then
        return
    end
    local avatars = GetArmyAvatars()
    local engi = GetIdleEngineers()
    local engineers = EntityCategoryFilterDown(categories.ENGINEER * categories.LAND - categories.FIELDENGINEER - categories.SUBCOMMANDER, engi)
    local fieldengineers = EntityCategoryFilterDown(categories.ENGINEER * (categories.FIELDENGINEER + categories.SUBCOMMANDER), engi)
    local terrainengineers = EntityCategoryFilterDown(categories.ENGINEER * (categories.AIR + categories.NAVAL), engi)
    local factories = GetIdleFactories()
    local needsAvatarLayout = false
    local validAvatars = {}

    -- Find the faction key (1 - 4 valid. 5+ happen for Civilian, default to 4 to use Seraphim textures)
    -- armiesTable[GetFocusArmy()].faction returns 0 = UEF, 1 = Aeon, 2 = Cybran, 3 = Seraphim, 4 = Civilian Army, 5 = Civilian Neutral
    -- We want 1 - 4, with 4 max
    currentFaction = math.min(GetArmiesTable().armiesTable[GetFocusArmy()].faction + 1, table.getn(Factions))

    if avatars then
        for _, unit in avatars do
            if controls.avatars[unit:GetEntityId()] then
                controls.avatars[unit:GetEntityId()]:Update()
            else
                controls.avatars[unit:GetEntityId()] = CreateAvatar(unit)
                needsAvatarLayout = true
            end
            validAvatars[unit:GetEntityId()] = true
        end
        for entID, control in controls.avatars do
            local i = entID
            if not validAvatars[i] then
                controls.avatars[i]:Destroy()
                controls.avatars[i] = nil
                needsAvatarLayout = true
            end
        end
    elseif controls.avatars then
        for entID, control in controls.avatars do
            local i = entID
            controls.avatars[i]:Destroy()
            controls.avatars[i] = nil
            needsAvatarLayout = true
        end
    end

    if engineers and not table.empty(engineers) then
        if controls.idleEngineers then
            controls.idleEngineers:Update(engineers)
        else
            controls.idleEngineers = CreateIdleTab(engineers, 'engineer', CreateIdleEngineerList)
            if expandedCheck == 'engineer' then
                controls.idleEngineers.expandCheck:SetCheck(true)
            end
            needsAvatarLayout = true
        end
    else
        if controls.idleEngineers then
            controls.idleEngineers:Destroy()
            controls.idleEngineers = nil
            needsAvatarLayout = true
        end
    end
    if fieldengineers and not table.empty(fieldengineers) then
            if controls.idleFieldEngineers  then
                controls.idleFieldEngineers:Update(fieldengineers)
            else
                controls.idleFieldEngineers = CreateIdleTab(fieldengineers, 'fieldengineer', CreateIdleFieldEngineerList)
                if expandedCheck == 'fieldengineer' then
                    controls.idleFieldEngineers.expandCheck:SetCheck(true)
                end
                needsAvatarLayout = true
            end
    else
        if controls.idleFieldEngineers then
            controls.idleFieldEngineers:Destroy()
            controls.idleFieldEngineers = nil
            needsAvatarLayout = true
        end
    end
    if terrainengineers and not table.empty(terrainengineers) then
        if controls.idleTerrainEngineers then
            controls.idleTerrainEngineers:Update(terrainengineers)
        else
            controls.idleTerrainEngineers = CreateIdleTab(terrainengineers, 'terrainengineer', CreateIdleTerrainEngineerList)
            if expandedCheck == 'terrainengineer' then
                controls.idleTerrainEngineers.expandCheck:SetCheck(true)
            end
            needsAvatarLayout = true
        end
    else
       if controls.idleTerrainEngineers then
         controls.idleTerrainEngineers:Destroy()
        controls.idleTerrainEngineers = nil
        needsAvatarLayout = true
        end
    end

    if factories and not table.empty(EntityCategoryFilterDown(categories.ALLUNITS - categories.GATE - categories.ORBITALSYSTEM, factories)) then
        if controls.idleFactories then
            controls.idleFactories:Update(EntityCategoryFilterDown(categories.ALLUNITS - categories.GATE, factories))
        else
            controls.idleFactories = CreateIdleTab(EntityCategoryFilterDown(categories.ALLUNITS - categories.GATE, factories), 'factory', CreateIdleFactoryList)
            if expandedCheck == 'factory' then
                controls.idleFactories.expandCheck:SetCheck(true)
            end
            needsAvatarLayout = true
        end
    else
        if controls.idleFactories then
            controls.idleFactories:Destroy()
            controls.idleFactories = nil
            needsAvatarLayout = true
        end
    end

    if needsAvatarLayout then
        import(UIUtil.GetLayoutFilename('avatars')).LayoutAvatars()
    end
end


function CreateIdleTab(unitData, id, expandFunc)
    local bg = Bitmap(controls.avatarGroup, UIUtil.SkinnableFile('/game/avatar/avatar-s-e-f_bmp.dds'))
    bg.id = id
    bg.tooltipKey = 'mfd_idle_'..id

    bg.allunits = unitData
    bg.units = unitData

    bg.icon = Bitmap(bg)
    LayoutHelpers.AtLeftTopIn(bg.icon, bg, 7, 8)
    bg.icon:SetSolidColor('00000000')
    LayoutHelpers.SetDimensions(bg.icon, 34, 34)
    bg.icon:DisableHitTest()

    bg.count = UIUtil.CreateText(bg.icon, '', 18, UIUtil.bodyFont)
    bg.count:DisableHitTest()
    bg.count:SetDropShadow(true)
    LayoutHelpers.AtBottomIn(bg.count, bg.icon)
    LayoutHelpers.AtRightIn(bg.count, bg.icon)

    bg.expandCheck = Checkbox(bg,
        UIUtil.SkinnableFile('/game/avatar-arrow_btn/tab-open_btn_up.dds'),
        UIUtil.SkinnableFile('/game/avatar-arrow_btn/tab-close_btn_up.dds'),
        UIUtil.SkinnableFile('/game/avatar-arrow_btn/tab-open_btn_over.dds'),
        UIUtil.SkinnableFile('/game/avatar-arrow_btn/tab-close_btn_over.dds'),
        UIUtil.SkinnableFile('/game/avatar-arrow_btn/tab-open_btn_dis.dds'),
        UIUtil.SkinnableFile('/game/avatar-arrow_btn/tab-close_btn_dis.dds'))
    LayoutHelpers.AnchorToLeft(bg.expandCheck, bg, -4)
    LayoutHelpers.AtVerticalCenterIn(bg.expandCheck, bg)
    bg.expandCheck.OnCheck = function(self, checked)
        if checked then
            if expandedCheck and expandedCheck ~= bg.id and GetCheck(expandedCheck) then
                GetCheck(expandedCheck):SetCheck(false)
            end
            expandedCheck = bg.id
            self.expandList = expandFunc(self, bg.units)
        else
            expandedCheck = false
            if self.expandList then
                self.expandList:Destroy()
                self.expandList = nil
            end
        end
    end
    bg.curIndex = 1
    bg.HandleEvent = ClickFunc
    bg.Update = function(self, units)
        self.allunits = units
        self.units = {}
        if self.id == 'engineer' then
            local sortedUnits = {}
            sortedUnits[5] = EntityCategoryFilterDown(categories.TECH3, self.allunits)
            sortedUnits[4] = EntityCategoryFilterDown(categories.TECH2 - categories.TANK, self.allunits)
            sortedUnits[3] = EntityCategoryFilterDown(categories.TANK * categories.TECH2, self.allunits)
            sortedUnits[2] = EntityCategoryFilterDown(categories.TECH1 - categories.TANK, self.allunits)
            sortedUnits[1] = EntityCategoryFilterDown(categories.TANK * categories.TECH1, self.allunits)

            local keyToIcon = {'T1V', 'T1', 'T2V', 'T2', 'T3'}

            local i = table.getn(sortedUnits)
            local needIcon = true
            while i > 0 do
                if not table.empty(sortedUnits[i])  then
                    if needIcon then
                        -- Idle engineer icons
                        if Factions[currentFaction].IdleEngTextures[keyToIcon[i]] and UIUtil.UIFile(Factions[currentFaction].IdleEngTextures[keyToIcon[i]],true) then
                            self.icon:SetTexture(UIUtil.UIFile(Factions[currentFaction].IdleEngTextures[keyToIcon[i]],true))      
                        end
                        needIcon = false
                    end
                    for _, unit in sortedUnits[i] do
                        table.insert(self.units, unit)
                    end
                end
                i = i - 1
            end
        ---ThisFollowing Creates Specialized Engineering Tabs for SCTA. FieldEngineers, and Terrain Engineers
        elseif self.id == 'fieldengineer' then
        --LOG(self.id)
        local sortedUnits = {}
        sortedUnits[4] = EntityCategoryFilterDown(categories.SUBCOMMANDER, self.allunits)
        sortedUnits[3] = EntityCategoryFilterDown(categories.FIELDENGINEER * categories.TECH3, self.allunits)
        sortedUnits[2] = EntityCategoryFilterDown(categories.FIELDENGINEER * categories.TECH2, self.allunits)
        sortedUnits[1] = EntityCategoryFilterDown(categories.FIELDENGINEER * categories.TECH1, self.allunits)

    
        local keyToIcon = {'T1F', 'T2F', 'T3F', 'SCU'}

            local i = table.getn(sortedUnits)
            local needIcon = true
            while i > 0 do
                if not table.empty(sortedUnits[i])  then
                    if needIcon then
                        -- Idle engineer icons
                        if Factions[currentFaction].IdleEngTextures[keyToIcon[i]] and UIUtil.UIFile(Factions[currentFaction].IdleEngTextures[keyToIcon[i]],true) then
                            self.icon:SetTexture(UIUtil.UIFile(Factions[currentFaction].IdleEngTextures[keyToIcon[i]],true))
                        end
                        needIcon = false
                    end
                    for _, unit in sortedUnits[i] do
                        table.insert(self.units, unit)
                    end
                end
                i = i - 1
            end
        elseif self.id == 'terrainengineer' then
            --LOG(self.id)
            local sortedUnits = {}
            sortedUnits[5] = EntityCategoryFilterDown(categories.TECH3 * categories.AIR, self.allunits)
            sortedUnits[4] = EntityCategoryFilterDown(categories.TECH2 * categories.AIR, self.allunits)
            sortedUnits[3] = EntityCategoryFilterDown(categories.TECH1 * categories.AIR, self.allunits)
            sortedUnits[2] = EntityCategoryFilterDown(categories.NAVAL * categories.TECH2, self.allunits)
            sortedUnits[1] = EntityCategoryFilterDown(categories.NAVAL * categories.TECH1, self.allunits)
        
            local keyToIcon = {'T1O', 'T2O', 'T1A', 'T2A', 'T3A'}

            local i = table.getn(sortedUnits)
            local needIcon = true
            while i > 0 do
                if not table.empty(sortedUnits[i])  then
                    if needIcon then
                        -- Idle engineer icons
                        if Factions[currentFaction].IdleEngTextures[keyToIcon[i]] and UIUtil.UIFile(Factions[currentFaction].IdleEngTextures[keyToIcon[i]],true) then
                            self.icon:SetTexture(UIUtil.UIFile(Factions[currentFaction].IdleEngTextures[keyToIcon[i]],true))
                        end
                        needIcon = false
                    end
                    for _, unit in sortedUnits[i] do
                        table.insert(self.units, unit)
                    end
                end
                i = i - 1
            end
        elseif self.id == 'factory' then
            local categoryTable = {'LAND','AIR','NAVAL'}
            local sortedFactories = {}
            for i, cat in categoryTable do
                sortedFactories[i] = {}
                sortedFactories[i][1] = EntityCategoryFilterDown(categories.TECH1 * categories[cat], self.allunits)
                sortedFactories[i][2] = EntityCategoryFilterDown(categories.TECH2 * categories[cat], self.allunits)
                sortedFactories[i][3] = EntityCategoryFilterDown(categories.TECH3 * categories[cat], self.allunits)
            end

            local i = 3
            local needIcon = true
            while i > 0 do
                for curCat = 1, 3 do
                    if not table.empty(sortedFactories[curCat][i]) then
                        if needIcon then
                            -- Idle factory icons
                            if UIUtil.UIFile(Factions[currentFaction].IdleFactoryTextures[categoryTable[curCat]][i],true) then
                                self.icon:SetTexture(UIUtil.UIFile(Factions[currentFaction].IdleFactoryTextures[categoryTable[curCat]][i],true))
                            else
                                self.icon:SetTexture(UIUtil.UIFile('/icons/units/default_icon.dds'))
                            end
                            needIcon = false
                        end
                        for _, unit in sortedFactories[curCat][i] do
                            table.insert(self.units, unit)
                        end
                    end
                end
                i = i - 1
            end
           if needIcon == true then
               local ExpFactories = EntityCategoryFilterDown(categories.EXPERIMENTAL, self.allunits)
               if not table.empty(ExpFactories) then
                   local FactoryUnitId = ExpFactories[1]:GetUnitId()
                   if UIUtil.UIFile('/icons/units/' .. FactoryUnitId .. '_icon.dds', true) then
                       self.icon:SetTexture(UIUtil.UIFile('/icons/units/' .. FactoryUnitId .. '_icon.dds', true))
                   else
                       self.icon:SetTexture(UIUtil.UIFile('/icons/units/default_icon.dds'))
                   end
               end
           end
        end
        self.count:SetText(table.getsize(self.allunits))

        if self.expandCheck.expandList then
            self.expandCheck.expandList:Update(self.allunits)
        end
    end

    return bg
end

function CreateIdleFieldEngineerList(parent, units)
    local group = Group(parent)

    local bgTop = Bitmap(group, UIUtil.SkinnableFile('/game/avatar-engineers-panel/panel-eng_bmp_t.dds'))
    local bgBottom = Bitmap(group, UIUtil.SkinnableFile('/game/avatar-engineers-panel/panel-eng_bmp_b.dds'))
    local bgStretch = Bitmap(group, UIUtil.SkinnableFile('/game/avatar-engineers-panel/panel-eng_bmp_m.dds'))

    group.Width:Set(bgTop.Width)
    LayoutHelpers.SetHeight(group, 1)

    bgTop.Bottom:Set(group.Top)
    bgBottom.Top:Set(group.Bottom)
    bgStretch.Top:Set(group.Top)
    bgStretch.Bottom:Set(group.Bottom)

    LayoutHelpers.AtHorizontalCenterIn(bgTop, group)
    LayoutHelpers.AtHorizontalCenterIn(bgBottom, group)
    LayoutHelpers.AtHorizontalCenterIn(bgStretch, group)

    group.connector = Bitmap(group, UIUtil.SkinnableFile('/game/avatar-engineers-panel/bracket_bmp.dds'))
    LayoutHelpers.AnchorToLeft(group.connector, parent, -8)
    LayoutHelpers.AtVerticalCenterIn(group.connector, parent)

    LayoutHelpers.LeftOf(group, parent, 10)
    group.Top:Set(function() return math.max(controls.avatarGroup.Top()+10, (parent.Top() + (parent.Height() / 2)) - (group.Height() / 2)) end)

    group:DisableHitTest(true)

    group.icons = {}

    group.Update = function(self, unitData)
        local function CreateUnitEntry(techLevel, userUnits, icontexture)
            local entry = Group(self)

            entry.icon = Bitmap(entry)
            -- Iddle engineer icons groupwindow
            if UIUtil.UIFile(icontexture,true) then
                entry.icon:SetTexture(UIUtil.UIFile(icontexture,true))
            else
                entry.icon:SetTexture(UIUtil.UIFile('/icons/units/default_icon.dds'))
            end
            LayoutHelpers.SetDimensions(entry.icon, 34, 34)
            LayoutHelpers.AtRightIn(entry.icon, entry, 22)
            LayoutHelpers.AtVerticalCenterIn(entry.icon, entry)

            entry.iconBG = Bitmap(entry, UIUtil.SkinnableFile('/game/avatar-factory-panel/avatar-s-e-f_bmp.dds'))
            LayoutHelpers.AtCenterIn(entry.iconBG, entry.icon)
            LayoutHelpers.DepthUnderParent(entry.iconBG, entry.icon)

            entry.techIcon = Bitmap(entry, UIUtil.SkinnableFile('/game/avatar-engineers-panel/tech-'..techLevel..'_bmp.dds'))
            LayoutHelpers.AtLeftIn(entry.techIcon, entry)
            LayoutHelpers.AtVerticalCenterIn(entry.techIcon, entry.icon)

            entry.count = UIUtil.CreateText(entry, '', 20, UIUtil.bodyFont)
            entry.count:SetColor('ffffffff')
            entry.count:SetDropShadow(true)
            LayoutHelpers.AtRightIn(entry.count, entry.icon)
            LayoutHelpers.AtBottomIn(entry.count, entry.icon)

            entry.countBG = Bitmap(entry)
            entry.countBG:SetSolidColor('77000000')
            LayoutHelpers.AtLeftTopIn(entry.countBG, entry.count, -1, -1)
            LayoutHelpers.AtRightBottomIn(entry.countBG, entry.count, -1, -1)

            LayoutHelpers.DepthOverParent(entry.countBG, entry)
            LayoutHelpers.DepthOverParent(entry.count, entry.countBG)

            entry.Height:Set(function() return entry.iconBG.Height() end)
            entry.Width:Set(self.Width)

            entry.icon:DisableHitTest()
            entry.iconBG:DisableHitTest()
            entry.techIcon:DisableHitTest()
            entry.count:DisableHitTest()
            entry.countBG:DisableHitTest()

            entry.curIndex = 1
            entry.units = userUnits
            entry.HandleEvent = ClickFunc

            return entry
        end
        local fieldengineers = {}
        fieldengineers[4] = EntityCategoryFilterDown(categories.SUBCOMMANDER, unitData)
        fieldengineers[3] = EntityCategoryFilterDown(categories.FIELDENGINEER * categories.TECH3, unitData)
        fieldengineers[2] = EntityCategoryFilterDown(categories.FIELDENGINEER * categories.TECH2, unitData)
        fieldengineers[1] = EntityCategoryFilterDown(categories.FIELDENGINEER * categories.TECH1, unitData)
        
        local indexToIcon = { '1', '2', '3', '3'}
        local keyToIcon = {'T1F', 'T2F', 'T3F', 'SCU'}
        for index, units in fieldengineers do
            local i = index
            if false then
                continue
            end
            if not self.icons[i] then
                self.icons[i] = CreateUnitEntry(indexToIcon[i], units, Factions[currentFaction].IdleEngTextures[keyToIcon[index]])
                self.icons[i].priority = i
            end
            if not table.empty(units) and not self.icons[i]:IsHidden() then
                self.icons[i].units = units
                self.icons[i].count:SetText(table.getn(units))
                self.icons[i].count:Show()
                self.icons[i].countBG:Show()
                self.icons[i].icon:SetAlpha(1)
            else
                self.icons[i].units = {}
                self.icons[i].count:Hide()
                self.icons[i].countBG:Hide()
                self.icons[i].icon:SetAlpha(.2)
            end
        end
        local prevGroup = false
        local groupHeight = 0
        for index, engGroup in fieldengineers do
            local i = index
            if not self.icons[i] then continue end
            if prevGroup then
                LayoutHelpers.Above(self.icons[i], prevGroup)
            else
                LayoutHelpers.AtLeftIn(self.icons[i], self, 7)
                LayoutHelpers.AtBottomIn(self.icons[i], self, 2)
            end
            groupHeight = groupHeight + self.icons[i].Height()
            prevGroup = self.icons[i]
        end
        group.Height:Set(groupHeight)
    end

    group:Update(units)

    return group
end


function CreateIdleTerrainEngineerList(parent, units)
    local group = Group(parent)

    local bgTop = Bitmap(group, UIUtil.SkinnableFile('/game/avatar-engineers-panel/panel-eng_bmp_t.dds'))
    local bgBottom = Bitmap(group, UIUtil.SkinnableFile('/game/avatar-engineers-panel/panel-eng_bmp_b.dds'))
    local bgStretch = Bitmap(group, UIUtil.SkinnableFile('/game/avatar-engineers-panel/panel-eng_bmp_m.dds'))

    group.Width:Set(bgTop.Width)
    LayoutHelpers.SetHeight(group, 1)

    bgTop.Bottom:Set(group.Top)
    bgBottom.Top:Set(group.Bottom)
    bgStretch.Top:Set(group.Top)
    bgStretch.Bottom:Set(group.Bottom)

    LayoutHelpers.AtHorizontalCenterIn(bgTop, group)
    LayoutHelpers.AtHorizontalCenterIn(bgBottom, group)
    LayoutHelpers.AtHorizontalCenterIn(bgStretch, group)

    group.connector = Bitmap(group, UIUtil.SkinnableFile('/game/avatar-engineers-panel/bracket_bmp.dds'))
    LayoutHelpers.AnchorToLeft(group.connector, parent, -8)
    LayoutHelpers.AtVerticalCenterIn(group.connector, parent)

    LayoutHelpers.LeftOf(group, parent, 10)
    group.Top:Set(function() return math.max(controls.avatarGroup.Top()+10, (parent.Top() + (parent.Height() / 2)) - (group.Height() / 2)) end)

    group:DisableHitTest(true)

    group.icons = {}

    group.Update = function(self, unitData)
        local function CreateUnitEntry(techLevel, userUnits, icontexture)
            local entry = Group(self)

            entry.icon = Bitmap(entry)
            -- Iddle engineer icons groupwindow
            if UIUtil.UIFile(icontexture,true) then
                entry.icon:SetTexture(UIUtil.UIFile(icontexture,true))
            else
                entry.icon:SetTexture(UIUtil.UIFile('/icons/units/default_icon.dds'))
            end
            LayoutHelpers.SetDimensions(entry.icon, 34, 34)
            LayoutHelpers.AtRightIn(entry.icon, entry, 22)
            LayoutHelpers.AtVerticalCenterIn(entry.icon, entry)

            entry.iconBG = Bitmap(entry, UIUtil.SkinnableFile('/game/avatar-factory-panel/avatar-s-e-f_bmp.dds'))
            LayoutHelpers.AtCenterIn(entry.iconBG, entry.icon)
            LayoutHelpers.DepthUnderParent(entry.iconBG, entry.icon)

            entry.techIcon = Bitmap(entry, UIUtil.SkinnableFile('/game/avatar-engineers-panel/tech-'..techLevel..'_bmp.dds'))
            LayoutHelpers.AtLeftIn(entry.techIcon, entry)
            LayoutHelpers.AtVerticalCenterIn(entry.techIcon, entry.icon)

            entry.count = UIUtil.CreateText(entry, '', 20, UIUtil.bodyFont)
            entry.count:SetColor('ffffffff')
            entry.count:SetDropShadow(true)
            LayoutHelpers.AtRightIn(entry.count, entry.icon)
            LayoutHelpers.AtBottomIn(entry.count, entry.icon)

            entry.countBG = Bitmap(entry)
            entry.countBG:SetSolidColor('77000000')
            LayoutHelpers.AtLeftTopIn(entry.countBG, entry.count, -1, -1)
            LayoutHelpers.AtRightBottomIn(entry.countBG, entry.count, -1, -1)

            LayoutHelpers.DepthOverParent(entry.countBG, entry)
            LayoutHelpers.DepthOverParent(entry.count, entry.countBG)

            entry.Height:Set(function() return entry.iconBG.Height() end)
            entry.Width:Set(self.Width)

            entry.icon:DisableHitTest()
            entry.iconBG:DisableHitTest()
            entry.techIcon:DisableHitTest()
            entry.count:DisableHitTest()
            entry.countBG:DisableHitTest()

            entry.curIndex = 1
            entry.units = userUnits
            entry.HandleEvent = ClickFunc

            return entry
        end
        local terrainengineers = {}
        terrainengineers[5] = EntityCategoryFilterDown(categories.TECH3 * categories.AIR, unitData)
        terrainengineers[4] = EntityCategoryFilterDown(categories.TECH2 * categories.AIR, unitData)
        terrainengineers[3] = EntityCategoryFilterDown(categories.TECH1 * categories.AIR, unitData)
        terrainengineers[2] = EntityCategoryFilterDown(categories.NAVAL * categories.TECH2, unitData)
        terrainengineers[1] = EntityCategoryFilterDown(categories.NAVAL * categories.TECH1, unitData)
        
        local indexToIcon = {'1', '2', '1', '2', '3'}
        local keyToIcon = {'T1O', 'T2O', 'T1A', 'T2A', 'T3A'}
        for index, units in terrainengineers do
            local i = index
            if false then
                continue
            end
            if not self.icons[i] then
                self.icons[i] = CreateUnitEntry(indexToIcon[i], units, Factions[currentFaction].IdleEngTextures[keyToIcon[index]])
                self.icons[i].priority = i
            end
            if not table.empty(units) and not self.icons[i]:IsHidden() then
                self.icons[i].units = units
                self.icons[i].count:SetText(table.getn(units))
                self.icons[i].count:Show()
                self.icons[i].countBG:Show()
                self.icons[i].icon:SetAlpha(1)
            else
                self.icons[i].units = {}
                self.icons[i].count:Hide()
                self.icons[i].countBG:Hide()
                self.icons[i].icon:SetAlpha(.2)
            end
        end
        local prevGroup = false
        local groupHeight = 0
        for index, engGroup in terrainengineers do
            local i = index
            if not self.icons[i] then continue end
            if prevGroup then
                LayoutHelpers.Above(self.icons[i], prevGroup)
            else
                LayoutHelpers.AtLeftIn(self.icons[i], self, 7)
                LayoutHelpers.AtBottomIn(self.icons[i], self, 2)
            end
            groupHeight = groupHeight + self.icons[i].Height()
            prevGroup = self.icons[i]
        end
        group.Height:Set(groupHeight)
    end

    group:Update(units)

    return group
end

function CreateIdleEngineerList(parent, units)
    local group = Group(parent)

    local bgTop = Bitmap(group, UIUtil.SkinnableFile('/game/avatar-engineers-panel/panel-eng_bmp_t.dds'))
    local bgBottom = Bitmap(group, UIUtil.SkinnableFile('/game/avatar-engineers-panel/panel-eng_bmp_b.dds'))
    local bgStretch = Bitmap(group, UIUtil.SkinnableFile('/game/avatar-engineers-panel/panel-eng_bmp_m.dds'))

    group.Width:Set(bgTop.Width)
    LayoutHelpers.SetHeight(group, 1)

    bgTop.Bottom:Set(group.Top)
    bgBottom.Top:Set(group.Bottom)
    bgStretch.Top:Set(group.Top)
    bgStretch.Bottom:Set(group.Bottom)

    LayoutHelpers.AtHorizontalCenterIn(bgTop, group)
    LayoutHelpers.AtHorizontalCenterIn(bgBottom, group)
    LayoutHelpers.AtHorizontalCenterIn(bgStretch, group)

    group.connector = Bitmap(group, UIUtil.SkinnableFile('/game/avatar-engineers-panel/bracket_bmp.dds'))
    LayoutHelpers.AnchorToLeft(group.connector, parent, -8)
    LayoutHelpers.AtVerticalCenterIn(group.connector, parent)

    LayoutHelpers.LeftOf(group, parent, 10)
    group.Top:Set(function() return math.max(controls.avatarGroup.Top()+10, (parent.Top() + (parent.Height() / 2)) - (group.Height() / 2)) end)

    group:DisableHitTest(true)

    group.icons = {}

    group.Update = function(self, unitData)
        local function CreateUnitEntry(techLevel, userUnits, icontexture)
            local entry = Group(self)

            entry.icon = Bitmap(entry)
            -- Iddle engineer icons groupwindow
            if UIUtil.UIFile(icontexture,true) then
                entry.icon:SetTexture(UIUtil.UIFile(icontexture,true))
            else
                entry.icon:SetTexture(UIUtil.UIFile('/icons/units/default_icon.dds'))
            end
            LayoutHelpers.SetDimensions(entry.icon, 34, 34)
            LayoutHelpers.AtRightIn(entry.icon, entry, 22)
            LayoutHelpers.AtVerticalCenterIn(entry.icon, entry)

            entry.iconBG = Bitmap(entry, UIUtil.SkinnableFile('/game/avatar-factory-panel/avatar-s-e-f_bmp.dds'))
            LayoutHelpers.AtCenterIn(entry.iconBG, entry.icon)
            LayoutHelpers.DepthUnderParent(entry.iconBG, entry.icon)

            entry.techIcon = Bitmap(entry, UIUtil.SkinnableFile('/game/avatar-engineers-panel/tech-'..techLevel..'_bmp.dds'))
            LayoutHelpers.AtLeftIn(entry.techIcon, entry)
            LayoutHelpers.AtVerticalCenterIn(entry.techIcon, entry.icon)

            entry.count = UIUtil.CreateText(entry, '', 20, UIUtil.bodyFont)
            entry.count:SetColor('ffffffff')
            entry.count:SetDropShadow(true)
            LayoutHelpers.AtRightIn(entry.count, entry.icon)
            LayoutHelpers.AtBottomIn(entry.count, entry.icon)

            entry.countBG = Bitmap(entry)
            entry.countBG:SetSolidColor('77000000')
            LayoutHelpers.AtLeftTopIn(entry.countBG, entry.count, -1, -1)
            LayoutHelpers.AtRightBottomIn(entry.countBG, entry.count, -1, -1)

            LayoutHelpers.DepthOverParent(entry.countBG, entry)
            LayoutHelpers.DepthOverParent(entry.count, entry.countBG)

            entry.Height:Set(function() return entry.iconBG.Height() end)
            entry.Width:Set(self.Width)

            entry.icon:DisableHitTest()
            entry.iconBG:DisableHitTest()
            entry.techIcon:DisableHitTest()
            entry.count:DisableHitTest()
            entry.countBG:DisableHitTest()

            entry.curIndex = 1
            entry.units = userUnits
            entry.HandleEvent = ClickFunc

            return entry
        end
        local engineers = {}   
        engineers[5] = EntityCategoryFilterDown(categories.TECH3, unitData)
        engineers[4] = EntityCategoryFilterDown(categories.TECH2 - categories.TANK, unitData)
        engineers[3] = EntityCategoryFilterDown(categories.TANK * categories.TECH2, unitData)
        engineers[2] = EntityCategoryFilterDown(categories.TECH1 - categories.TANK, unitData)
        engineers[1] = EntityCategoryFilterDown(categories.TANK * categories.TECH1, unitData)    

        local indexToIcon = {'1', '1', '2', '2', '3'}
        local keyToIcon = {'T1V', 'T1', 'T2V', 'T2', 'T3'}
        for index, units in engineers do
            local i = index
            if false then
                continue
            end
            if not self.icons[i] then
                self.icons[i] = CreateUnitEntry(indexToIcon[i], units, Factions[currentFaction].IdleEngTextures[keyToIcon[index]])
                self.icons[i].priority = i
            end
            if not table.empty(units) and not self.icons[i]:IsHidden() then
                self.icons[i].units = units
                self.icons[i].count:SetText(table.getn(units))
                self.icons[i].count:Show()
                self.icons[i].countBG:Show()
                self.icons[i].icon:SetAlpha(1)
            else
                self.icons[i].units = {}
                self.icons[i].count:Hide()
                self.icons[i].countBG:Hide()
                self.icons[i].icon:SetAlpha(.2)
            end
        end
        local prevGroup = false
        local groupHeight = 0
        for index, engGroup in engineers do
            local i = index
            if not self.icons[i] then continue end
            if prevGroup then
                LayoutHelpers.Above(self.icons[i], prevGroup)
            else
                LayoutHelpers.AtLeftIn(self.icons[i], self, 7)
                LayoutHelpers.AtBottomIn(self.icons[i], self, 2)
            end
            groupHeight = groupHeight + self.icons[i].Height()
            prevGroup = self.icons[i]
        end
        group.Height:Set(groupHeight)
    end

    group:Update(units)

    return group
end

function SetSkinTA(unit)
    local bp = unit:GetBlueprint().General
    unit.TASkin = true
    if unit:GetBlueprint().BlueprintId == 'mas0001' then
        unit.TASkin = nil
        return
    elseif bp.FactionName == 'Cybran' then
        return ConExecute('UI_SetSkin cybran')
    elseif bp.FactionName == 'Seraphim' then
       return ConExecute('UI_SetSkin seraphim')
    elseif bp.FactionName == 'Nomads' then
        return ConExecute('UI_SetSkin nomads')
    elseif bp.FactionName == 'CORE' then
       return ConExecute('UI_SetSkin core')
    elseif bp.FactionName == 'Aeon' then
       return ConExecute('UI_SetSkin aeon')
    elseif bp.FactionName == 'ARM' then
        return ConExecute('UI_SetSkin arm')
    else
        return ConExecute('UI_SetSkin uef')
    end
end

TACreateAvater = CreateAvatar
function CreateAvatar(unit)
    if not unit.TASkin then
    SetSkinTA(unit)
    end
   return TACreateAvater(unit)
end