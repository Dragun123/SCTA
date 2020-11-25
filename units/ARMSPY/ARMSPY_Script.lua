#ARM SPY - Fast Light Scout Kbot
#ARMSPY
#
#Script created by Raevn

local TAWalking = import('/mods/SCTA-master/lua/TAMotion.lua').TAWalking

ARMSPY = Class(TAWalking) {
    OnStopBeingBuilt = function(self, builder, layer)
		TAWalking.OnStopBeingBuilt(self, builder, layer)
		self:SetMaintenanceConsumptionInactive()
        self:SetScriptBit('RULEUTC_IntelToggle', true)
        self:RequestRefreshUI()
    end,

	OnIntelDisabled = function(self)
		self:SetMesh(self:GetBlueprint().Display.MeshBlueprint, true)
	end,

	OnIntelEnabled = function(self)
		self:SetMesh('/mods/SCTA-master/units/ARMSPY/ARMSPY_cloak_mesh', true)
	end,

	OnScriptBitSet = function(self, bit)
		if bit == 8 then
		---self.OnIntelDisabled(self)
		end
		TAWalking.OnScriptBitSet(self, bit)
	end,


	OnScriptBitClear = function(self, bit)
		if bit == 8 then
		--self.OnIntelEnabled(self)
		end
		TAWalking.OnScriptBitClear(self, bit)
	end,
}

TypeClass = ARMSPY
