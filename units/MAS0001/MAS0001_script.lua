
local AWalkingLandUnit = import('/lua/aeonunits.lua').AWalkingLandUnit
local Entity = import('/lua/sim/Entity.lua').Entity
local EffectUtil = import('/lua/EffectUtilities.lua')

MAS0001 = Class(AWalkingLandUnit) {
	OnCreate = function(self)
	AWalkingLandUnit.OnCreate(self)
	---this is show nomads don't appear in TA only games
	self:AddBuildRestriction(categories.NOMADS)
	---this is likewise just for base game FA Factions. This restriction is applied specifically so that its somewhat easier on my end.
	---Instead of applying restrictions for 4 different factions I call a single relavent category here. 
	self:AddBuildRestriction(categories.PRODUCTSC1)
	self.AnimManip = CreateAnimator(self)
	self.Trash:Add(self.AnimManip)
	end,

    OnStopBeingBuilt = function(self,builder,layer)
		---local army = self:GetArmy()
		AWalkingLandUnit.OnStopBeingBuilt(self,builder,layer)
		self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationOpen):SetRate(0.25)
    end,
	
	OnStartBuild = function(self, unitBeingBuilt, order)
		local gtime = GetGameTimeSeconds()
		if gtime < 9 then
			ForkThread(self.Spawn, self, unitBeingBuilt, order)
		else
			AWalkingLandUnit.OnStartBuild(self, unitBeingBuilt, order)
			local cdrUnit = false
			local army = self:GetArmy()
			cdrUnit = CreateInitialArmyUnit(army, unitBeingBuilt.UnitId)
			self:AddBuildRestriction(categories.COMMAND)
			self:Destroy()
			unitBeingBuilt:Destroy()
		end

		--ForkThread(self:Spawn,self, unitBeingBuilt, order)

    end,

	Spawn = function(self, unitBeingBuilt, order)
		--self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationOpen):SetRate(0.8)
		--self:CreateProjectile( '/effects/entities/UnitTeleport01/UnitTeleport01_proj.bp', 0, 1.35, 0, nil, nil, nil):SetCollision(false)
		local gtime = GetGameTimeSeconds()
		while gtime < 9 do
			--WaitSeconds(0.2)
			coroutine.yield(3)
			gtime = GetGameTimeSeconds()
		end
		---AWalkingLandUnit.OnStartBuild(self, unitBeingBuilt, order)
		local cdrUnit = false
		local army = self:GetArmy()
		cdrUnit = CreateInitialArmyUnit(army, unitBeingBuilt.UnitId)
		self:AddBuildRestriction(categories.COMMAND)
		--WaitSeconds(2)
		self:Destroy()
		unitBeingBuilt:Destroy()
	end
}


TypeClass = MAS0001

