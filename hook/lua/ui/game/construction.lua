local TAStratIconReplacement = StratIconReplacement
local Prefs = import('/lua/user/prefs.lua')
local options = Prefs.GetFromCurrentProfile('options')

function StratIconReplacement(control)
            ---LOG('TAIEXIST', options.gui_bigger_strat_build_icons)
            if options.gui_bigger_strat_build_icons >= 1 then
                local TAName = __blueprints[control.Data.id].TAStrategicIconName
                if TAName then 
                    if options.gui_bigger_strat_build_icons == 1 then
                        control.StratIcon:SetTexture('/textures/ui/icons_strategic/' .. TAName .. '.dds')
                    else
                        TAName = __blueprints[control.Data.id].TAStrategicIconName2
                        control.StratIcon:SetTexture('/textures/ui/icons_strategic/' .. TAName .. '.dds')
                    end
                    LayoutHelpers.SetDimensions(control.StratIcon, control.StratIcon.BitmapWidth(), control.StratIcon.BitmapHeight())
                    LayoutHelpers.AtTopIn(control.StratIcon, control.Icon, 1)
                    LayoutHelpers.AtRightIn(control.StratIcon, control.Icon, 1)
                    LayoutHelpers.ResetBottom(control.StratIcon)
                    LayoutHelpers.ResetLeft(control.StratIcon)
                    control.StratIcon:SetAlpha(0.8)
                end
            end
        TAStratIconReplacement(control)
    end