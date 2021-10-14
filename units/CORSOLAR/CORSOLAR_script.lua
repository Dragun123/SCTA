#CORE Solar Collector - Produces Energy
#CORSOLAR
#
#Script created by Raevn
local TACloser = import('/mods/SCTA-master/lua/TAStructure.lua').TACloser

CORSOLAR = Class(TACloser) {
	OnCreate = function(self)
		TACloser.OnCreate(self)
		self.AnimManip = CreateAnimator(self)
		self.Trash:Add(self.AnimManip)
	end,


	OpeningState = State {
		Main = function(self)
			self:SetProductionActive(true)
			--[[if not self.TAAnimating then
				self.TAAnimating = true]]
			self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationOpen)
			self.AnimManip:SetRate(1 * (self:GetBlueprint().Display.AnimationOpenRate or 0.2))
			--end
			TACloser.OpeningState.Main(self)
		end,
	},


	ClosingState = State {
		Main = function(self)
			self:SetProductionActive(false)
			--[[if not self.TAAnimating then
				self.TAAnimating = true]]
			self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationOpen)
			self.AnimManip:SetRate(-1 * (self:GetBlueprint().Display.AnimationOpenRate or 0.2))
			--end
			TACloser.ClosingState.Main(self)
		end,

	},
}

TypeClass = CORSOLAR