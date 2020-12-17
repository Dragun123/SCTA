#CORE M-104 - Low Damage, Med. Range Mine
#CORMINE1
#
#Script created by Raevn

local TAunit = import('/mods/SCTA-master/lua/TAunit.lua').TAunit
local Projectile = import('/lua/sim/DefaultWeapons.lua').DefaultProjectileWeapon

CORMINE1 = Class(TAunit) {


	Weapons = {
		CORMINE1 = Class(Projectile) {
			OnWeaponFired = function(self)
				self.unit.attacked = true
				self.unit:Kill()
			end,
		},
	},

	OnKilled = function(self, instigator, type, overkillRatio)
		if self.unit.attacked then
			instigator = self
		end
		TAunit.OnKilled(self, instigator, type, overkillRatio)
		
	end,

	OnStopBeingBuilt = function(self,builder,layer)
		TAunit.OnStopBeingBuilt(self,builder,layer)
		self:SetScriptBit('RULEUTC_CloakToggle', true)
		self:RequestRefreshUI()
	end,

	OnIntelDisabled = function(self)
		self:SetMesh(self:GetBlueprint().Display.MeshBlueprint, true)
	end,

	OnIntelEnabled = function(self)
		self:SetMesh('/mods/SCTA-master/units/CORMINE1/CORMINE1_cloak_mesh', true)
	end,
}
TypeClass = CORMINE1