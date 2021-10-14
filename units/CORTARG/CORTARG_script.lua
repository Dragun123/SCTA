#CORE Targeting Facility - Automatic Radar Targeting
#CORTARG
#
#Script created by Raevn

local TACloser = import('/mods/SCTA-master/lua/TAStructure.lua').TACloser

CORTARG = Class(TACloser) {
	OnCreate = function(self)
		TACloser.OnCreate(self)
		self.AnimManip = CreateAnimator(self)
		self.Trash:Add(self.AnimManip)
	end,


	OpeningState = State {
		Main = function(self)
			self:EnableIntel('Radar')
			--[[if not self.TAAnimating then
				self.TAAnimating = true]]
		self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationUnpack)
		self.AnimManip:SetRate(1 * (self:GetBlueprint().Display.AnimationUnpackRate or 0.2))
			--end
		TACloser.OpeningState.Main(self)
	end,
},


ClosingState = State {
	Main = function(self)
		self:DisableIntel('Radar')
		--[[if not self.TAAnimating then
				self.TAAnimating = true]]
		self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationUnpack)
		self.AnimManip:SetRate(-1 * (self:GetBlueprint().Display.AnimationUnpackRate or 0.2))
		--end
		TACloser.ClosingState.Main(self)
	end,
},
}

TypeClass = CORTARG