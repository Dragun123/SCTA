
local TACommander = import('/mods/SCTA-master/lua/TAconstructor.lua').TACommander
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')
local TADGun = import('/mods/SCTA-master/lua/TAweapon.lua').TADGun
local TACommanderDeathWeapon = import('/mods/SCTA-master/lua/TAweapon.lua').TACommanderDeathWeapon


CORDECOM = Class(TACommander) {

	HideFlares = function(self, bp)
	end,

	OnStopBeingBuilt = function(self,builder,layer)
		TACommander.OnStopBeingBuilt(self,builder,layer)
		self:SetMaintenanceConsumptionInactive()
		self:SetScriptBit('RULEUTC_CloakToggle', true)
        self:RequestRefreshUI()
	end,
	
	Weapons = {
		COMLASER = Class(TAweapon) {
		},
		DGun = Class(TADGun) {
		},		
		AutoDGun = Class(TADGun) {
		},
		DeathWeapon = Class(TACommanderDeathWeapon) {},
	},
}

TypeClass = CORDECOM