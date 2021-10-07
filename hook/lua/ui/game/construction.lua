local TAStratIconReplacement = StratIconReplacement
local Prefs = import('/lua/user/prefs.lua')
local options = Prefs.GetFromCurrentProfile('options')

function StratIconReplacement(control)
    ---LOG('TAIEXIST', options.gui_bigger_strat_build_icons)
    ---This log was used to determined which game options match which value
    ---As a note the value for options start at 0 not 1. 
    if options.gui_bigger_strat_build_icons >= 1 then
        local TAName = __blueprints[control.Data.id].TAStrategicIconName
    ----This basically forcibly checks value set for units in the BP forcibly vs letting the game natural parameters translate it via straticon icons tables
        if TAName then 
            if options.gui_bigger_strat_build_icons == 1 then
        ---this is game option Bigger Icons otherwise astraticon table defined in straticons.lua. The first variable basically uses the described and forcibly inserts it here skipping going to table to translate the strategic icon and then matching then inserting
                control.StratIcon:SetTexture('/textures/ui/icons_strategic/' .. TAName .. '.dds')
            else
        ---sense we should only get here if option 1 or more I am just doing an else instead. Here We reset the taname variable to use the second icon. Sense one AStratIconFull and has tech markers beneath it. 
                TAName = __blueprints[control.Data.id].TAStrategicIconName2
                control.StratIcon:SetTexture('/textures/ui/icons_strategic/' .. TAName .. '.dds')
            end
        ---this is what creates ui image itself
            LayoutHelpers.SetDimensions(control.StratIcon, control.StratIcon.BitmapWidth(), control.StratIcon.BitmapHeight())
            LayoutHelpers.AtTopIn(control.StratIcon, control.Icon, 1)
            LayoutHelpers.AtRightIn(control.StratIcon, control.Icon, 1)
            LayoutHelpers.ResetBottom(control.StratIcon)
            LayoutHelpers.ResetLeft(control.StratIcon)
            control.StratIcon:SetAlpha(0.8)
        end
    end
----original function gets called here, I feared might be deadloop. But initial testing doesn't make it appear so. Dead Loop would been caused by "Not the above is not true" but it worked correctly. 
    TAStratIconReplacement(control)
end