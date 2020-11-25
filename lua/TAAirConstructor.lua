local TAair = import('/mods/SCTA-master/lua/TAair.lua').TAair
local Unit = import('/lua/sim/Unit.lua').Unit
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')

TAAirConstructor = Class(TAair) {
	currentState = "closed",
	desiredState = "closed",
    currentTarget = nil,
	desiredTarget = nil,
	order = nil,

	isBuilding = nil,
	isReclaiming = nil,

	pauseTime = 3,

	animating = nil,

	AnimationThread = function(self)
		self.animating = true
		while not IsDestroyed(self) do
			if (self.currentState ~= self.desiredState) then
				if (self.currentState == "closed") then
					if not IsDestroyed(self) then
					self:Open()
					self.currentState = "opened"
					self.desiredState = "aimed"
					end
				elseif(self.currentState == "opened") then
					if (self.desiredState == "closed") then
							self:Close()
							self.currentState = "closed"
					elseif (self.desiredState == "aimed") then
						self.currentTarget = self.desiredTarget
						self.currentState = "aimed"
						if (self.currentTarget and not IsDestroyed(self.currentTarget)) then
							self:Aim(self.currentTarget)
						end
						if (not IsDestroyed(self.currentTarget)) then
							if (self.isBuilding) then
								TAair.OnStartBuild(self, self.currentTarget, self.order)
								if EntityCategoryContains(categories.ARM, self.currentTarget) or EntityCategoryContains(categories.CORE, self.currentTarget) then
								self.currentTarget:HideFlares()
								end
							end
							if (self.isReclaiming) then
							end
							ForkThread(self.Nano, self, self.currentTarget)
						end
					end
				elseif(self.currentState == "aimed") then
					if (self.desiredState == "closed") then
						self:Close(self)
						self.currentState = "closed"
				end
			end
		end
			WaitSeconds(0.2)
		end
		self.animating = nil
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
		---TAair.OnStartBuild(self, unitBeingBuilt, order )
        if unitBeingBuilt.noassistbuild and unitBeingBuilt:GetHealth() == unitBeingBuilt:GetMaxHealth() then
            return
		end
		self.desiredTarget = unitBeingBuilt
		if (self.currentState == "aimed" or self.currentState == "opened") then
			self.currentState = "opened"
			self.desiredState = "aimed"
		else
			self.desiredState = "opened"
		end
		--self:SetAllWeaponsEnabled(false)
		self.isBuilding = true
		self.isReclaiming = nil
		self.order = order
		if (not self.animating) then
			ForkThread(self.AnimationThread, self)
		end
	end,

	OnStopBuild = function(self, unitBeingBuilt, order )
		TAair.OnStopBuild(self, unitBeingBuilt, order )
		self.desiredTarget = nil
		self.isBuilding = nil
		self.countdown = self.pauseTime
		if (self.currentState == "aimed") then
			self.desiredState = "closed"
		end
		--self:SetAllWeaponsEnabled(true)
	end,

	DestroyUnitBeingBuilt = function(self)
        self:LOGDBG('TAContructor.DestroyUnitBeingBuilt')
    end,

    OnFailedToBuild = function(self)
        self:LOGDBG('TAContructor.OnFailedToBuild')
		TAair.OnFailedToBuild(self)
		--self:OnStopBuild()
    end,


	OnStartReclaim = function(self, target)
		TAair.OnStartReclaim(self, target)
		self.desiredTarget = target
		if (self.currentState == "aimed") then
			self.currentState = "opened"
			self.desiredState = "aimed"
		else
			self.desiredState = "opened"
		end
		---self:SetAllWeaponsEnabled(false)
		self.isReclaiming = true
		self.isBuilding = nil
		if (not self.animating) then
			ForkThread(self.AnimationThread, self)
		end
	end,


	OnStopReclaim = function(self, target)
		TAair.OnStopReclaim(self, target)
		self.desiredTarget = nil
		self.isReclaiming = nil
		self.countdown = self.pauseTime
		self.desiredState = "closed"
		---self:SetAllWeaponsEnabled(true)
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
		while not IsDestroyed(self) and self.isBuilding and not IsDestroyed(unitBeingBuilt) and unitBeingBuilt:GetFractionComplete() < 1 or self.isReclaiming and self.currentState == "aimed" do
			if not self:IsPaused() then

				current = current + 1
				if current >= target or self.isReclaiming then
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
						else
							bp = self:GetBlueprint().Display.ReclaimEmitter or 'reclaimnanolathe.bp'
							CreateEmitterAtBone(self, v, self:GetArmy(), '/mods/SCTA-master/effects/emitters/' .. bp ):ScaleEmitter(0.1):SetEmitterCurveParam('LIFETIME_CURVE',time,0):SetEmitterCurveParam('Z_POSITION_CURVE',distance * 10,0)
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