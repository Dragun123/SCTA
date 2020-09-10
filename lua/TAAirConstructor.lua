local TAair = import('/mods/SCTAFix/lua/TAair.lua').TAair
local Unit = import('/lua/sim/Unit.lua').Unit
local TAutils = import('/mods/SCTAFix/lua/TAutils.lua')

TAAirConstructor = Class(TAair) {
	currentState = "closed",
	desiredState = "closed",
    currentTarget = nil,
	desiredTarget = nil,
	order = nil,

	isBuilding = false,
	isReclaiming = false,

	pauseTime = 3,
	hideUnit = false,
	isFactory = false,
	spinUnit = false,

	animating = false,
	wantStopAnimation = false,

	AnimationThread = function(self)
		self.animating = true
		while not IsDestroyed(self) and self.wantStopAnimation == false do
			if (self.currentState ~= self.desiredState) then
				if (self.currentState == "closed") then
					#desiredState will only ever be "opened" from this state
					self:Open()
					self.currentState = "opened"
					self.desiredState = "aimed"
				elseif(self.currentState == "opened") then
					if (self.desiredState == "closed") then
						self:DelayedClose()
						--Check to make sure we still want to close
						if (self.desiredState == "closed") then	
							self:Close()
							self.currentState = "closed"
						end
					elseif (self.desiredState == "aimed") then
						if (self.currentTarget and not IsDestroyed(self.currentTarget)) then
							--self:StopSpin(self.currentTarget)
						end
						self.currentTarget = self.desiredTarget
						self.currentState = "aimed"
						if (self.currentTarget) then
							self:Aim(self.currentTarget)
						end
						if (IsDestroyed(self.currentTarget) == false) then
							end
							if self.hideUnit and IsDestroyed(self.currentTarget) == false  then
								self.currentTarget:ShowBone(0, true)
								#Need to Show Life Bar here once implemented
							end
							if (self.isBuilding == true) then
								self.currentTarget:HideFlares()
								self:SetBuildRate(self:GetBlueprint().Economy.BuildRate)
								TAair.OnStartBuild(self, self.currentTarget, self.order)
							end
							if (self.isReclaiming == true) then
								self:SetReclaimTimeMultiplier(1)
							end
							ForkThread(self.Nano, self, self.currentTarget)
						end
					end
				elseif(self.currentState == "aimed" or self.currentState == "rolloff") then
					if (self.desiredState == "closed") then
						self:Close(self)
						self.currentState = "closed"
						if (self.isBuilding == false and self.isReclaiming == false) then
							self.wantStopAnimation = true
						end
				end
			end
			WaitSeconds(0.2)
		end
		self.animating = false
		self.wantStopAnimation = false
	end,


    OnKilled = function(self, instigator, type, overkillRatio)
        TAair.OnKilled(self, instigator, type, overkillRatio)
    end,

	FlattenSkirt = function(self)
		TAair.FlattenSkirt(self)
        local x, y, z = unpack(self:GetPosition())
        local x0,z0,x1,z1 = self:GetSkirtRect()
        x0,z0,x1,z1 = math.floor(x0),math.floor(z0),math.ceil(x1),math.ceil(z1)
        FlattenMapRect(x0, z0, x1-x0, z1-z0, y)
    end,

	OnStartBuild = function(self, unitBeingBuilt, order )
        if unitBeingBuilt.noassistbuild and unitBeingBuilt:GetHealth()==unitBeingBuilt:GetMaxHealth() then
            return
        end
		self.desiredTarget = unitBeingBuilt
		if (self.currentState == "aimed" or self.currentState == "opened" or self.currentState == "rolloff") then
			self.currentState = "opened"
			self.desiredState = "aimed"
		else
			self.desiredState = "opened"
		end
		self:SetAllWeaponsEnabled(false)
		if self.hideUnit and IsDestroyed(unitBeingBuilt) == false then
			unitBeingBuilt:HideBone(0, true)
			#Need to Hide Life Bar
		end
		self.isBuilding = true
		self.isReclaiming = false
		self.order = order
		self.wantStopAnimation = false
		if (self.animating == false) then
			ForkThread(self.AnimationThread, self)
		end
	end,

	OnStopBuild = function(self, unitBeingBuilt, order )
		TAair.OnStopBuild(self, unitBeingBuilt, order )
		self.desiredTarget = nil
		self.isBuilding = false
		self.countdown = self.pauseTime
		if (self.currentState == "aimed") then
			self.desiredState = "rolloff"
		else
			self.desiredState = "closed"
		end
		self:SetAllWeaponsEnabled(true)
		if self.isFactory then
			self:SetBusy(true)
			self:SetBlockCommandQueue(true)
		end
	end,

	DestroyUnitBeingBuilt = function(self)
        if self.UnitBeingBuilt and not self.UnitBeingBuilt.Dead and self.UnitBeingBuilt:GetFractionComplete() < 1 then
            if self.UnitBeingBuilt:GetFractionComplete() > 0.5 then
                self.UnitBeingBuilt:Kill()
            else
                self.UnitBeingBuilt:Destroy()
            end
        end
    end,

	OnFailedToBuild = function(self)
		TAair.OnFailedToBuild(self)
		#WaitSeconds(1)
        ChangeState(self, self.IdleState)
    end,


	OnStartReclaim = function(self, target)
		self:SetReclaimTimeMultiplier(1)
		self:SetBuildRate(self:GetBlueprint().Economy.BuildRate)
		TAair.OnStartReclaim(self, target)
		self.desiredTarget = target
		if (self.currentState == "aimed") then
			self.currentState = "opened"
			self.desiredState = "aimed"
		else
			self.desiredState = "opened"
		end
		self:SetAllWeaponsEnabled(false)
		self.isReclaiming = true
		self.isBuilding = false
		self.wantStopAnimation = false
		if (self.animating == false) then
			ForkThread(self.AnimationThread, self)
		end
	end,


	OnStopReclaim = function(self, target)
		TAair.OnStopReclaim(self, target)
		self.desiredTarget = nil
		self.isReclaiming = false
		self.countdown = self.pauseTime
		self.desiredState = "closed"
		self:SetAllWeaponsEnabled(true)
	end,

	GetCloseArea = function(self)
		local bp = self:GetBlueprint()
		local pos = self:GetPosition(bp.Display.BuildAttachBone)
		local area = nil
		if bp.Physics.CloseAreaX and bp.Physics.CloseAreaZ then
			area = Rect(pos.x - bp.Physics.CloseAreaX,bp.Physics.CloseAreaZ, bp.Physics.CloseAreaX, bp.Physics.CloseAreaX)
		else
			area = Rect(pos.x - bp.SizeX,bp.SizeZ, bp.SizeX, bp.SizeZ)
		end
		WaitSeconds(1)
		return area
	end,

	GetBuildArea = function(self)
		local bp = self:GetBlueprint()
		local pos = self:GetPosition(bp.Display.BuildAttachBone)
		local area = nil
		if bp.Physics.BuildAreaX and bp.Physics.BuildAreaZ then
			area = Rect(bp.Physics.BuildAreaX, bp.Physics.BuildAreaZ, bp.Physics.BuildAreaX, bp.Physics.BuildAreaX)
		else
			area = Rect(bp.SizeX,bp.SizeZ, bp.SizeX, bp.SizeZ)
		end
		WaitSeconds(1)
		return area
	end,

	Unpack = function(self)
	end,

	Open = function(self)
	end,
	
	Aim = function(self, target)
	end,

	Close = function(self)
	end,

	Nano = function(self, unitBeingBuilt)
		local target = 1
		local current = 0
		while  self.isBuilding == true and IsDestroyed(unitBeingBuilt) == false and unitBeingBuilt:GetFractionComplete() < 1 or self.isReclaiming == true and self.currentState == "aimed" do
			if self:IsPaused() == false then

				current = current + 1
				if current >= target or self.isReclaiming == true then
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
						if (self.isBuilding == true) then
							bp = self:GetBlueprint().Display.BuildEmitter or 'nanolathe.bp'
							CreateEmitterAtBone(self, v, self:GetArmy(), '/mods/SCTAFix/effects/emitters/' .. bp ):ScaleEmitter(0.1):SetEmitterCurveParam('LIFETIME_CURVE',time,0)
						else
							bp = self:GetBlueprint().Display.ReclaimEmitter or 'reclaimnanolathe.bp'
							CreateEmitterAtBone(self, v, self:GetArmy(), '/mods/SCTAFix/effects/emitters/' .. bp ):ScaleEmitter(0.1):SetEmitterCurveParam('LIFETIME_CURVE',time,0):SetEmitterCurveParam('Z_POSITION_CURVE',distance * 10,0)
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

TypeClass = TAAirConstructor