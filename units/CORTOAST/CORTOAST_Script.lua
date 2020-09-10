#ARM Ambusher - Pop-up Heavy Cannon
#ARMAMB
#
#Script created by Raevn

local TAunit = import('/mods/SCTA/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTA/lua/TAweapon.lua').TAweapon

CORTOAST = Class(TAunit) {
	damageReduction = 1,

	OnCreate = function(self)
		TAunit.OnCreate(self)
		self:SetWeaponEnabledByLabel('ARMAMB_GUN', false)
	end,

	OnStopBeingBuilt = function(self,builder,layer)
		TAunit.OnStopBeingBuilt(self,builder,layer)
		ForkThread(self.InitialPack,self)
	end,

	OnDamage = function(self, instigator, amount, vector, damageType)
		TAunit.OnDamage(self, instigator, amount * self.damageReduction, vector, damageType)
		#Has Damage Reduction
	end,

	InitialPack = function(self)
		self.damageReduction = 0.28
		self:SetWeaponEnabledByLabel('ARMAMB_GUN', true)
	end,

	Weapons = {
		ARMAMB_GUN = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)	
			end,

			PlayFxWeaponUnpackSequence = function(self)
				self.unit.damageReduction = 1
				TAweapon.PlayFxWeaponUnpackSequence(self)
			end,	

			PlayFxWeaponPackSequence = function(self)
				self.unit.damageReduction = 0.28
				TAweapon.PlayFxWeaponPackSequence(self)
			end,	
		},
	},
}

TypeClass = CORTOAST
