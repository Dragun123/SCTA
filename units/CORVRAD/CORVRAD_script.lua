#CORE Informer - Mobile Radar
#CORVRAD
#
#Script created by Raevn

local TAunit = import('/mods/SCTA/lua/TAunit.lua').TAunit

CORVRAD = Class(TAunit) {
	OnCreate = function(self)
		TAunit.OnCreate(self)
		self.Spinners = {
			dish = CreateRotator(self, 'dish', 'y', nil, 0, 100, 0),
		}
		self.Trash:Add(self.Spinners.dish)
	end,

	OnStopBeingBuilt = function(self,builder,layer)
		TAunit.OnStopBeingBuilt(self,builder,layer)
		--spin dish around y-axis speed <100>;
		self.Spinners.dish:SetTargetSpeed(100)
	end,


	OnScriptBitSet = function(self, bit)
		if bit == 3 then
			--spin dish around z-axis speed <0> (Bug in TA: meant to be y-axis)
			self.Spinners.dish:SetTargetSpeed(0)
		end
		TAunit.OnScriptBitSet(self, bit)
	end,


	OnScriptBitClear = function(self, bit)
		if bit == 3 then
			--spin dish around y-axis speed <100>;
			self.Spinners.dish:SetTargetSpeed(100)
		end
		TAunit.OnScriptBitClear(self, bit)
	end,
}
TypeClass = CORVRAD