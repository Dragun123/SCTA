local TAconstructor = import('/mods/SCTA-master/lua/TAconstructor.lua').TAconstructor
local Unit = import('/lua/sim/Unit.lua').Unit
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')

TAFactory = Class(TAconstructor) {
	currentState = "closed",
	desiredState = "closed",
    currentTarget = nil,
	desiredTarget = nil,
	order = nil,

	isBuilding = nil,
	---isReclaiming = false,

	pauseTime = 3,
	isFactory = true,

	animating = nil,

    OnKilled = function(self, instigator, type, overkillRatio)
        TAconstructor.OnKilled(self, instigator, type, overkillRatio)
            if self.currentTarget and not self.currentTarget:IsDead() and self.currentTarget:GetFractionComplete() != 1 then
				self.currentTarget:Kill()
        	end
    end,


	OnStartBuild = function(self, unitBeingBuilt, order )
        self:LOGDBG('TAFactory.OnStartBuild')
		self.desiredTarget = unitBeingBuilt
		if (self.currentState == "aimed" or self.currentState == "opened" or self.currentState == "rolloff") then
			self.currentState = "opened"
			self.desiredState = "aimed"
		else
			self.desiredState = "opened"
		end
		if (not IsDestroyed(self.desiredTarget)) then
			---if self.isFactory then
				local bone = self:GetBlueprint().Display.BuildAttachBone or 0
				self.desiredTarget:AttachBoneTo(-2, self, bone)
			---end
		end
		---self:SetAllWeaponsEnabled(false)
		self.isBuilding = true
		self.order = order
		if (not self.animating) then
			ForkThread(self.AnimationThread, self)
		end
	end,

	OnStopBuild = function(self, unitBeingBuilt, order )
		self:LOGDBG('TAFactory.OnStopBuild')
		TAconstructor.OnStopBuild(self, unitBeingBuilt, order )
		ForkThread(self.FactoryOnStopBuild, self, unitBeingBuilt, order )
	end,

	FactoryOnStopBuild = function(self, unitBeingBuilt, order )
		--WaitSeconds(1)
		self:SetBusy(true)
		self:SetBlockCommandQueue(false)
        if unitBeingBuilt and unitBeingBuilt.Dead then
            self.desiredState = "aimed"
		end
	end,

	RollOff = function(self, unitBeingBuilt)
		self:LOGDBG('TAFactory.RollOff')
		if not IsDestroyed(self) and unitBeingBuilt then
			WaitSeconds(0.5)
			if not IsDestroyed(unitBeingBuilt) then
            unitBeingBuilt:DetachFrom(true)
			end
		end
        if not IsDestroyed(self) then
			ChangeState(self, self.IdleState)
			WaitSeconds(0.5)
			if not IsDestroyed(self) then
			self:SetBusy(false)
			self:SetBlockCommandQueue(false)
			end
		end 
	end,
	
	Aim = function(self, target)
		self:LOGDBG('TAFactory.Aim')
		if not IsDestroyed(target) and not IsDestroyed(self) then
		end
	end,


	DestroyUnitBeingBuilt = function(self)
        self:LOGDBG('TAFactory.DestroyUnitBeingBuilt')
        if self.UnitBeingBuilt and not self.UnitBeingBuilt.Dead and self.UnitBeingBuilt:GetFractionComplete() < 1 then
            if self.UnitBeingBuilt:GetFractionComplete() > 0.5 then
                self.UnitBeingBuilt:Kill()
            else
                self.UnitBeingBuilt:Destroy()
			end
			self:OnStopBuild()
		end
		ChangeState(self, self.IdleState)
    end,

	Close = function(self)
		self:LOGDBG('TAFactory.Close')
		ChangeState(self, self.IdleState)
		self:SetBusy(false)
		self:SetBlockCommandQueue(false)
		if self.isBuilding then
			self.desiredState = "aimed"
		end
	end,


	Nano = function(self, unitBeingBuilt)
        self:LOGDBG('TAFactory.Nano')
		local target = 1
		local current = 0
		while not IsDestroyed(self) and self.isBuilding and not IsDestroyed(unitBeingBuilt) and unitBeingBuilt:GetFractionComplete() < 1 and self.currentState == "aimed" do
			if not self:IsPaused() then

				current = current + 1
				if current >= target then
					for k,v in self:GetBlueprint().Display.BuildBones do

                        local selfPosition = self:GetPosition(v) 
                        local targetPosition = unitBeingBuilt:GetPosition()
                        local distance = VDist3(Vector(selfPosition.x,selfPosition.y, selfPosition.z), Vector(targetPosition.x, targetPosition.y, targetPosition.z))
                        local time = distance * 0.85
                        if (time >10) then
                            time = 10
                        end

						local aiBrain = self:GetAIBrain()
						local storedMass = aiBrain:GetEconomyStoredRatio('MASS')
						local storedEnergy = aiBrain:GetEconomyStoredRatio('ENERGY')
						local ratioMass = aiBrain:GetEconomyIncome('MASS') / aiBrain:GetEconomyRequested('MASS')
						local ratioEnergy =  aiBrain:GetEconomyIncome('ENERGY') / aiBrain:GetEconomyRequested('ENERGY')
						local lowestStored = math.min(storedMass, storedEnergy)
						if lowestStored == storedMass then 
							lowestRatio = ratioMass
						else
							lowestRatio = ratioEnergy
						end

						local bp
						if (self.isBuilding) then
							bp = self:GetBlueprint().Display.BuildEmitter or 'nanolathe.bp'
							CreateEmitterAtBone(self, v, self:GetArmy(), '/mods/SCTA-master/effects/emitters/' .. bp ):ScaleEmitter(0.1):SetEmitterCurveParam('LIFETIME_CURVE',time,0)
						end
						

						if lowestRatio < 1 and lowestStored < 0.1 then
							target = math.floor(1 / lowestRatio)
						else
							target = 1
						end
					end
					current = 0
				end
			end
			WaitSeconds(0.25)
		end
	end,
}

TypeClass = TAFactory