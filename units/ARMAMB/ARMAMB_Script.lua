#ARM Ambusher - Pop-up Heavy Cannon
#ARMAMB
#
#Script created by Raevn

local TAPop = import('/mods/SCTA-master/lua/TAStructure.lua').TAPop
local TAHide = import('/mods/SCTA-master/lua/TAweapon.lua').TAHide

ARMAMB = Class(TAPop) {
	--[[OnCreate = function(self)
		TAPop.OnCreate(self)
		self.AnimManip = CreateAnimator(self)
		self.Trash:Add(self.AnimManip)
	end,



	Fold = function(self)
		TAPop.Fold(self)
		self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationUnpack)
		self.AnimManip:SetRate(-1 * (self:GetBlueprint().Display.AnimationUnpackRate or 0.2)) 
	end,]]

	Weapons = {
		ARMAMB_GUN = Class(TAHide) {
			PlayFxWeaponUnpackSequence = function(self)
				TAHide.PlayFxWeaponUnpackSequence(self)
			end,	

			PlayFxWeaponPackSequence = function(self)
				TAHide.PlayFxWeaponPackSequence(self)
			end,	
		},
	},
}

TypeClass = ARMAMB
