local TAWalking = import('/mods/SCTA-master/lua/TAMotion.lua').TAWalking
local Unit = import('/lua/sim/Unit.lua').Unit
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')
local oldPosition={1,1,1}

TAconstructor = Class(TAWalking) {
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
			--ChangeState(self, self.IdleState)
			if(self.currentState == "rolloff") then
				self.currentTarget = nil
				--ChangeState(self, self.IdleState)
				self.countdown = self.countdown - 0.2
				if (self.countdown <= 0) then
					self.desiredState = "closed"
				end
			end
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
						if (self.currentTarget and not IsDestroyed(self.currentTarget)) then
							self:RollOff(self.currentTarget)
						end
						self.currentTarget = self.desiredTarget
						self.currentState = "aimed"
						if (self.currentTarget and not IsDestroyed(self.currentTarget)) then
							self:Aim(self.currentTarget)
						else
							self.desiredState = "rolloff"
						end
						if (not IsDestroyed(self.currentTarget)) then
							if (self.isBuilding) then
								---self:SetBuildRate(self:GetBlueprint().Economy.BuildRate)
								TAWalking.OnStartBuild(self, self.currentTarget, self.order)
								if EntityCategoryContains(categories.ARM, self.currentTarget) or EntityCategoryContains(categories.CORE, self.currentTarget) then
								self.currentTarget:HideFlares()
								end
							end
							if (self.isReclaiming) then
							end
							ForkThread(self.Nano, self, self.currentTarget)
						end
					end
				elseif(self.currentState == "aimed" or self.currentState == "rolloff") then
					if (self.desiredState == "closed") then
						self:Close(self)
						---ChangeState(self, self.IdleState)
						self.currentState = "closed"
					elseif (self.desiredState == "rolloff") then
						self:RollOff(self.currentTarget)
						self.currentState = "rolloff"
					end
				end
			end
			WaitSeconds(0.2)
		end
		self.animating = nil
	end,

	FlattenSkirt = function(self)
        self:LOGDBG('TAContructor.FlattenSkirt')
		TAWalking.FlattenSkirt(self)
        local x, y, z = unpack(self:GetPosition())
        local x0,z0,x1,z1 = self:GetSkirtRect()
        x0,z0,x1,z1 = math.floor(x0),math.floor(z0),math.ceil(x1),math.ceil(z1)
        FlattenMapRect(x0, z0, x1-x0, z1-z0, y)
    end,



	OnStartBuild = function(self, unitBeingBuilt, order )
		self:LOGDBG('TAContructor.OnStartBuild')
		---TAWalking.OnStartBuild(self, unitBeingBuilt, order )
        if unitBeingBuilt.noassistbuild and unitBeingBuilt:GetHealth() == unitBeingBuilt:GetMaxHealth() then
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
		self.isBuilding = true
		self.isReclaiming = nil
		self.order = order
		if (not self.animating) then
			ForkThread(self.AnimationThread, self)
		end
	end,

	OnStopBuild = function(self, unitBeingBuilt, order )
        self:LOGDBG('TAContructor.OnStopBuild')
		TAWalking.OnStopBuild(self, unitBeingBuilt, order )
		--ChangeState(self, self.IdleState)
		self.desiredTarget = nil
		self.isBuilding = nil
		self.countdown = self.pauseTime
		if (self.currentState == "aimed") then
			self.desiredState = "rolloff"
		else
			self.desiredState = "closed"
		end
		self:SetAllWeaponsEnabled(true)
	end,

	DestroyUnitBeingBuilt = function(self)
        self:LOGDBG('TAContructor.DestroyUnitBeingBuilt')
    end,
    
    OnFailedToBuild = function(self)
        self:LOGDBG('TAContructor.OnFailedToBuild')
		TAWalking.OnFailedToBuild(self)
		--self:OnStopBuild()
    end,


	OnStartReclaim = function(self, target)
		self:LOGDBG('TAContructor.OnStartReclaim')
		---if not self.cloakOn or not self.isCapturing then
		--self:SetReclaimTimeMultiplier(1)
		--self:SetBuildRate(self:GetBlueprint().Economy.BuildRate * 0.60)
		TAWalking.OnStartReclaim(self, target)
		self.desiredTarget = target
		if (self.currentState == "aimed") then
			self.currentState = "opened"
			self.desiredState = "aimed"
		else
			self.desiredState = "opened"
		end
		self.isReclaiming = true
		self.isBuilding = nil
		if (not self.animating) then
			ForkThread(self.AnimationThread, self)
		--end
		end
	end,


	OnStopReclaim = function(self, target)
        self:LOGDBG('TAContructor.OnStopReclaim')
		TAWalking.OnStopReclaim(self, target)
		self.Conclude(self, target)
	end,

	Conclude = function(self, target)
		self.desiredTarget = nil
		self.isReclaiming = nil
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
        self:LOGDBG('TAContructor.GetBuildArea')
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

	RollOff = function(self, unitBeingBuilt)
        self:LOGDBG('TAContructor.RollOff')
	end,

	Unpack = function(self)
        self:LOGDBG('TAContructor.Unpack')
	end,

	Open = function(self)
        self:LOGDBG('TAContructor.Open')
	end,
	
	Aim = function(self, target)
        self:LOGDBG('TAContructor.Aim')
	end,

	Close = function(self)
        self:LOGDBG('TAContructor.Close')
	end,

	Nano = function(self, unitBeingBuilt)
        self:LOGDBG('TAContructor.Nano')
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


TANecro = Class(TAconstructor) {
    OnStartReclaim = function(self, target, oldPosition)
        if EntityCategoryContains(categories.NECRO, self) then
            if not target.ReclaimInProgress and not target.NecroingInProgress then
                --LOG('* Necro: OnStartReclaim:  I am a necro! no ReclaimInProgress; starting Necroing')
                target.NecroingInProgress = true
				self.spawnUnit = true
                self.RecBP = target.AssociatedBP
                self.ReclaimLeft = target.ReclaimLeft
                self.RecPosition = target:GetPosition()
            elseif not target.ReclaimInProgress and target.NecroingInProgress then
				--LOG('* Necro: OnStartReclaim:  I am a necro and helping necro')
				self.RecBP = nil
				self.ReclaimLeft = nil
				self.RecPosition = target:GetPosition()
			else
                --LOG('* Necro: OnStartReclaim:  I am a necro and ReclaimInProgress; Stopped!')
				self.RecBP = nil
                self.ReclaimLeft = nil
                self.RecPosition = nil
                IssueStop({self})
                IssueClearCommands({self})
                return
            end
        else
            if not target.NecroingInProgress then
                --LOG('* Necro: OnStartReclaim:  I am engineer, no NecroingInProgress, starting Reclaim')
                target.ReclaimInProgress = true
            else
                --LOG('* Necro: OnStartReclaim:  I am engineer and NecroingInProgress; Stopped!')
                IssueStop({self})
                IssueClearCommands({self})
                return
            end
        end
        TAconstructor.OnStartReclaim(self, target, oldPosition)
    end,

    OnStopReclaim = function(self, target, oldPosition)
        TAconstructor.OnStopReclaim(self, target, oldPosition)
        if not target then
            if self.RecBP and EntityCategoryContains(categories.NECRO, self) and oldPosition ~= self.RecPosition and self.spawnUnit then
                --LOG('* Necro: OnStopReclaim:  I am a necro! and RecBP = true ')
                oldPosition = self.RecPosition
                self:ForkThread( self.RespawnUnit, self.RecBP, self:GetArmy(), self.RecPosition, self.ReclaimLeft )
            else
                --LOG('* Necro: OnStopReclaim: no necro or no RecBP')
            end
        else
            if EntityCategoryContains(categories.NECRO, self) then
                --LOG('* Necro: OnStopReclaim:  Wreck still exist. Removing target data from Necro')
                self.RecBP = nil
                self.ReclaimLeft = nil
                self.RecPosition = nil
            else
                --LOG('* Necro: OnStopReclaim: Wreck still exist. no necro')
            end
        end
    end,

    RespawnUnit = function(self, RecBP, army, pos, ReclaimLeft)
        --LOG('* Necro: RespawnUnit: ReclaimLeft '..ReclaimLeft)
        WaitTicks(3)
        local newUnit = CreateUnitHPR(RecBP, army, pos[1], pos[2], pos[3], 0, 0, 0)
        newUnit:SetHealth(nil, newUnit:GetMaxHealth() * ReclaimLeft * 0.5)
    end,
}

TACommander = Class(TAconstructor) {

	OnStartReclaim = function(self, target)
		TAconstructor.OnStartReclaim(self, target)
		self:SetScriptBit('RULEUTC_CloakToggle', true)
	end,

	OnStartCapture = function(self, target)
		---self:SetCaptureTimeMultiplier(1)
		--self:SetBuildRate(self:GetBlueprint().Economy.BuildRate * 0.6)
		TAconstructor.OnStartCapture(self, target)
		self:SetScriptBit('RULEUTC_CloakToggle', true)
		self:SetAllWeaponsEnabled(false)
		self.desiredTarget = target
		if (self.currentState == "aimed") then
			self.currentState = "opened"
			self.desiredState = "aimed"
		else
			self.desiredState = "opened"
		end
		self.isBuilding = nil
		---if not self.cloakOn then
		self.isCapturing = true
		self.isReclaiming = true
		if (not self.animating) then
			ForkThread(TAconstructor.AnimationThread, self)
		end
	end,


	OnStopCapture = function(self, target)
		TAconstructor.OnStopCapture(self, target)
		self.isCapturing = nil
		TAconstructor.Conclude(self, target)
	end,
    
    OnFailedCapture = function(self, target)
		TAconstructor.OnFailedCapture(self, target)
		self.isCapturing = nil
		TAconstructor.Conclude(self, target)
    end,

	Conclude = function(self, target)
		TAconstructor.Conclude(self, target)
		if self.cloakOn then
		ForkThread(self.CloakDetection, self)
		end
	end,

    CloakDetection = function(self)
        local GetUnitsAroundPoint = moho.aibrain_methods.GetUnitsAroundPoint
        local brain = moho.entity_methods.GetAIBrain(self)
        local cat = categories.SELECTABLE * categories.MOBILE
        local getpos = moho.entity_methods.GetPosition
        while not self.Dead do
            coroutine.yield(11)
            local dudes = GetUnitsAroundPoint(brain, cat, getpos(self), 4, 'Enemy')
            if dudes[1] and self.cloakOn then
                self:DisableIntel('Cloak')
            elseif not dudes[1] and self.cloakOn then
                self:EnableIntel('Cloak')
            end
        end
    end,
}