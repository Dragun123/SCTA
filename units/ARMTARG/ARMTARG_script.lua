#ARM Targeting Facility - Automatic Radar Targeting
#ARMTARG
#
#Script created by Raevn

local TACloser = import('/mods/SCTA-master/lua/TAStructure.lua').TACloser

ARMTARG = Class(TACloser) {
	OnCreate = function(self)
		TACloser.OnCreate(self)
		self.AnimManip = CreateAnimator(self)
		self.Trash:Add(self.AnimManip)
	end,


	OpeningState = State {
		Main = function(self)
			self.IsActive = true
			self:EnableIntel('Radar')
		self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationUnpack)
		self.AnimManip:SetRate(1 * (self:GetBlueprint().Display.AnimationUnpackRate or 0.2))
		TACloser.OpeningState.Main(self)
	end,
},


ClosingState = State {
	Main = function(self)
		self:DisableIntel('Radar')
		self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationRepack)
		self.AnimManip:SetRate(self:GetBlueprint().Display.AnimationRepackRate)
		TACloser.ClosingState.Main(self)
	end,
	},
}
TypeClass = ARMTARG