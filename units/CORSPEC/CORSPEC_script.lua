#CORE Spectre - Radar Jammer
#CORSPEC
#
#Script created by Raevn

local TACounter = import('/mods/SCTA-master/lua/TAMotion.lua').TACounter


CORSPEC = Class(TACounter) {
	OnCreate = function(self)
		TACounter.OnCreate(self)
		self.AnimManip = CreateAnimator(self)
		self.Trash:Add(self.AnimManip)
	end,


	OnIntelDisabled = function(self)
		TACounter.OnIntelDisabled(self)
		self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationPack)
		self.AnimManip:SetRate((self:GetBlueprint().Display.AnimationPackRate or 1))
	end,

	OnIntelEnabled = function(self)
		TACounter.OnIntelEnabled(self)
		self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationUnpack)
		self.AnimManip:SetRate(1 * (self:GetBlueprint().Display.AnimationUnpackRate or 1))
	end,
}
TypeClass = CORSPEC