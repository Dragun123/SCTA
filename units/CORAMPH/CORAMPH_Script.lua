#ARM Pelican - Amphibious Kbot
#ARMAMPH
#
#Script created by Axle

local TAWalking = import('/mods/SCTA-master/lua/TAMotion.lua').TAWalking
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon


CORAMPH = Class(TAWalking) {
	OnMotionHorzEventChange = function( self, new, old )
        TAWalking.OnMotionHorzEventChange(self, new, old)
        if ( new == 'Cruise' and old == 'Stopped') then
            self:ForkThread(self.StartMoveFxTA)
         end
        if ( new == 'Stopped' ) or ( new == 'Stopped' and old == 'Stopping' ) then
            self:ForkThread(self.MoveFxStopTA)
        end
    end,

	Weapons = {
		WEAPON = Class(TAweapon) {},
	},
}

TypeClass = CORAMPH
