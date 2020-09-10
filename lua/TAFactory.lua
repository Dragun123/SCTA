local TAconstructor = import('/mods/SCTAFix/lua/TAconstructor.lua').TAconstructor
local Unit = import('/lua/sim/Unit.lua').Unit
local TAutils = import('/mods/SCTAFix/lua/TAutils.lua')

TAFactory = Class(TAconstructor) {
	currentState = "closed",
	desiredState = "closed",
    currentTarget = nil,
	desiredTarget = nil,
	order = nil,

	isBuilding = false,
	isReclaiming = false,

	pauseTime = 3,
	hideUnit = false,
	isFactory = true,
	spinUnit = true,

	animating = false,
	wantStopAnimation = false,

	AnimationThread = function(self)
	TAconstructor.AnimationThread(self)
	end,

	FlattenSkirt = function(self)
		TAconstructor.FlattenSkirt(self)
        local x, y, z = unpack(self:GetPosition())
        local x0,z0,x1,z1 = self:GetSkirtRect()
        x0,z0,x1,z1 = math.floor(x0),math.floor(z0),math.ceil(x1),math.ceil(z1)
        FlattenMapRect(x0, z0, x1-x0, z1-z0, y)
    end,

    OnKilled = function(self, instigator, type, overkillRatio)
        TAconstructor.OnKilled(self, instigator, type, overkillRatio)
            if self.currentTarget and not self.currentTarget:IsDead() and self.currentTarget:GetFractionComplete() != 1 then
                self.currentTarget:Kill()
                self.currentTarget:Destroy()
        	end
    end,


	OnStartBuild = function(self, unitBeingBuilt, order )
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
		TAconstructor.OnStopBuild(self, unitBeingBuilt, order )
		self.desiredTarget = nil
		self.isBuilding = false
		self.countdown = self.pauseTime
		if (self.currentState == "aimed") then
			self.desiredState = "rolloff"
		else
			self.desiredState = "closed"
		end
		self:SetAllWeaponsEnabled(true)
		self:SetBusy(true)
		self:SetBlockCommandQueue(true)
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
        self.FactoryBuildFailed = true
		TAconstructor.OnFailedToBuild(self)
		#WaitSeconds(1)
        ChangeState(self, self.IdleState)
    end,


	StopSpin = function(self, unitBeingBuilt)
		if not IsDestroyed(self) and unitBeingBuilt then
			WaitSeconds(0.5)
			if IsDestroyed(unitBeingBuilt) == false then
            unitBeingBuilt:DetachFrom(true)
		end
	end
    end,

	DelayedClose = function(self)
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
			area = Rect(bp.SizeX, bp.SizeZ, bp.SizeX, bp.SizeZ)
		end
		WaitSeconds(1)
		return area
	end,

	RollOff = function(self)
        if not IsDestroyed(self) then
            WaitSeconds(0.5)
			self:SetBusy(false)
			self:SetBlockCommandQueue(false)
		end 
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

	UpgradingState = State {
        Main = function(self)
            self:StopRocking()
            local bp = self:GetBlueprint().Display
            self:DisableDefaultToggleCaps()
        end,

        OnStopBuild = function(self, unitBuilding)
            TAconstructor.OnStopBuild(self, unitBuilding)
            self:EnableDefaultToggleCaps()
            
            if unitBuilding:GetFractionComplete() == 1 then
                NotifyUpgrade(self, unitBuilding)
                self:Destroy()
            end
        end,

        OnFailedToBuild = function(self)
            TAconstructor.OnFailedToBuild(self)
            self:EnableDefaultToggleCaps()
            if self:GetCurrentLayer() == 'Water' then
                self:StartRocking()
            end
            ChangeState(self, self.IdleState)
        end,
        
	},
	
}

TypeClass = TAFactory