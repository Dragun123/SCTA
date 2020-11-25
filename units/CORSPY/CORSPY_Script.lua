#ARM SPY - Fast Light Scout Kbot
#CORSPY
#
#Script created by Raevn

local TAWalking = import('/mods/SCTA-master/lua/TAMotion.lua').TAWalking

CORSPY = Class(TAWalking) {
    OnStopBeingBuilt = function(self, builder, layer)
		TAWalking.OnStopBeingBuilt(self, builder, layer)
		self.Spinners = {
			fork = CreateRotator(self, 'jam', 'y', nil, 0, 0, 0),
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
		self:SetMaintenanceConsumptionInactive()
        self:SetScriptBit('RULEUTC_IntelToggle', true)
		self:RequestRefreshUI()
    end,

	OnIntelDisabled = function(self)
		self:SetMesh(self:GetBlueprint().Display.MeshBlueprint, true)
	end,

	OnIntelEnabled = function(self)
		self:SetMesh('/mods/SCTA-master/units/CORSPY/CORSPY_cloak_mesh', true)
	end,

	OnScriptBitSet = function(self, bit)
		if bit == 8 then
			self.Spinners.fork:SetSpeed(0)
		end
		TAWalking.OnScriptBitSet(self, bit)
	end,


	OnScriptBitClear = function(self, bit)
		if bit == 8 then
			self.Spinners.fork:SetSpeed(100)
		end
		TAWalking.OnScriptBitClear(self, bit)
	end,
}

TypeClass = CORSPY
