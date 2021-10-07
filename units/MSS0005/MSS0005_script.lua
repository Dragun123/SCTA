#****************************************************************************
#**
#**
#**  Summary  :  Cybran Long Range Artillery Script
#**
local CLandUnit = import('/lua/cybranunits.lua').CLandUnit


MSS0005 = Class(CLandUnit) {

   OnStopBeingBuilt = function(self, builder, layer)
	SetArmyFactionIndex(self:GetArmy(), 4)
	ForkThread(self.Delay, self, builder, layer)
	self:Destroy()
 end,


 Delay = function (self, builder, layer)
	 local position = self:GetPosition()
	 local cdrUnit = CreateUnitHPR('xnl0001', self:GetArmy(), (position.x), (position.y+1), (position.z), 0, 0, 0)  
	 cdrUnit:HideBone(0, true)
	 cdrUnit:SetUnSelectable(false)
	 cdrUnit:SetBlockCommandQueue(true)
	 --WaitSeconds(1)
	 coroutine.yield(11)
	 cdrUnit:ForkThread(cdrUnit.PlayCommanderWarpInEffect)
 end,
 
}

TypeClass = MSS0005