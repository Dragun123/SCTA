#****************************************************************************
#**
#**  File     :  /cdimage/units/URB5101/URB5101_script.lua
#**  Author(s):  John Comes, David Tomandl
#**
#**  Summary  :  -- 				local terrain = GetTerrainType(xpos, zpos)
#-- 				if terrain.TypeCode >= 220 then
#**
#**  Copyright © 2005 Gas Powered Games, Inc.  All rights reserved.
#****************************************************************************

local CLandUnit = import('/lua/cybranunits.lua').CLandUnit


MSS0004 = Class(CLandUnit) {

	OnStopBeingBuilt = function(self, builder, layer)
		SetArmyFactionIndex(self:GetArmy(), 1)
		ForkThread(self.Delay, self, builder, layer)
		self:Destroy()
	 end,
 
 
	 Delay = function (self, builder, layer)
		 local position = self:GetPosition()
		 local cdrUnit = CreateUnitHPR('ual0001', self:GetArmy(), (position.x), (position.y+1), (position.z), 0, 0, 0)  
		 cdrUnit:HideBone(0, true)
		 cdrUnit:SetUnSelectable(false)
		 cdrUnit:SetBlockCommandQueue(true)
		 --WaitSeconds(2)
		 coroutine.yield(21)
		 if not IsDestroyed(cdrUnit) then
			cdrUnit:ForkThread(cdrUnit.PlayCommanderWarpInEffect)
		end
	 end,
 
}

TypeClass = MSS0004

