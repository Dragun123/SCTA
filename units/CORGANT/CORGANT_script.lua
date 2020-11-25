#CORE Krogoth Gantry - Builds Krogoths
#CORGANT
#
#Script created by Raevn

local TAFactory = import('/mods/SCTA-master/lua/TAFactory.lua').TAFactory
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')

CORGANT = Class(TAFactory) {
	pauseTime = 5,
	hideUnit = true,
	
	OnCreate = function(self)
		self.AnimManip = CreateAnimator(self)
		self.Trash:Add(self.AnimManip)
		TAFactory.OnCreate(self)
	end,


	Open = function(self)
		TAFactory.Open(self)
		self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationUnpack)
		self.AnimManip:SetRate(1 * (self:GetBlueprint().Display.AnimationUnpackRate or 0.2))
	end,

	Aim = function(self, target)
		TAFactory.Aim(self, target)
		WaitFor(self.AnimManip)
	end,

	Close = function(self)
		TAFactory.Close(self)
		self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationPack)
		self.AnimManip:SetRate(1 * (self:GetBlueprint().Display.AnimationPackRate or 0.2))
	end,
}

TypeClass = CORGANT