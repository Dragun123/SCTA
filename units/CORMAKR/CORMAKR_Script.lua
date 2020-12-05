#CORE Metal Maker - Converts Energy into Metal
#CORMAKR
#
#Script created by Raevn

local TAunit = import('/mods/SCTA-master/lua/TAunit.lua').TAunit

CORMAKR = Class(TAunit) {

	OnCreate = function(self)
		TAunit.OnCreate(self)
		self.Sliders = {
			chassis = CreateSlider(self, 0),
		}
		for k, v in self.Sliders do
			self.Trash:Add(v)
		end
		self.Spinners = {
			plug = CreateRotator(self, 'plug', 'z', nil, 0, 0, 0),
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
	end,

	OnStopBeingBuilt = function(self,builder,layer)
		TAunit.OnStopBeingBuilt(self,builder,layer)
		local bp = self:GetBlueprint()
        local scale = 0.5
		self:DisableIntel('RadarStealth')
		if layer == 'Water' then
			self.Water = true
		end
	end,

	OnProductionUnpaused = function(self)
		#Open Animation
		self:PlayUnitSound('Activate')	
		ForkThread(self.Open, self)
	end,

	OnProductionPaused = function(self)
		#Close Animation		
		TAunit.OnProductionPaused(self)
		self:SetMaintenanceConsumptionInactive()
		
		self:PlayUnitSound('Deactivate')
		ForkThread(self.Close, self)
	end,

	Open = function(self)
		--TURN plug to z-axis <180> SPEED <50.01> 
		ForkThread(self.WaterRise, self)
		self.Spinners.plug:SetGoal(0)
		self.Spinners.plug:SetSpeed(50)
		WaitFor(self.Spinners.plug)

		TAunit.OnProductionUnpaused(self)
		self:SetMaintenanceConsumptionActive()
		
	end,

	WaterRise = function(self)
		local bp = self:GetBlueprint()
        local scale = 0.5
		if self.Water then
			self.Sliders.chassis:SetSpeed(10)
			self.Sliders.chassis:SetGoal(0,0,0)
			self:SetCollisionShape( 'Box', bp.CollisionOffsetX or 0,(bp.CollisionOffsetY + (bp.SizeY*0.5)) or 0,bp.CollisionOffsetZ or 0, bp.SizeX * scale, bp.SizeY * scale, bp.SizeZ * scale )
			self:DisableIntel('RadarStealth')
		end
	end,

	Close = function(self)
		--TURN plug to z-axis <0> SPEED <50.01>
		ForkThread(self.WaterFall, self)
		self.Spinners.plug:SetGoal(180)
		self.Spinners.plug:SetSpeed(50)
		WaitFor(self.Spinners.plug)
	end,

	WaterFall = function(self)
		local bp = self:GetBlueprint()
        local scale = 0.5
		if self.Water then
			self.Sliders.chassis:SetSpeed(10)
			self.Sliders.chassis:SetGoal(0,-10,0)
			self:SetCollisionShape( 'Box', bp.CollisionOffsetX or -5,(bp.CollisionOffsetY + (bp.SizeY*-0.25)) or 0,bp.CollisionOffsetZ or -5, bp.SizeX * scale, bp.SizeY * scale, bp.SizeZ * scale )
			self:EnableIntel('RadarStealth')
		end
	end,
}


TypeClass = CORMAKR