#ARM Cloakable Fusion Reactor - Produces Energy
#CORCKFUS
#
#Blueprint created by Raevn

local TAunit = import('/mods/SCTA/lua/TAunit.lua').TAunit

CORCKFUS = Class(TAunit) {
    OnStopBeingBuilt = function(self,builder,layer)
        TAunit.OnStopBeingBuilt(self,builder,layer)
        self:SetScriptBit('RULEUTC_CloakToggle', true)
        self:RequestRefreshUI()
    end,

	OnIntelDisabled = function(self)
		self:SetMesh(self:GetBlueprint().Display.MeshBlueprint, true)
	end,

	OnIntelEnabled = function(self)
		self:SetMesh('/mods/SCTA/units/CORCKFUS/CORCKFUS_cloak_mesh', true)
	end,
}

TypeClass = CORCKFUS
