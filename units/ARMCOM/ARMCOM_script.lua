#ARM Commander - Commander
#ARMCOM
#
#Script created by Raevn

local TAconstructor = import('/mods/SCTA/lua/TAconstructor.lua').TAconstructor
local TAweapon = import('/mods/SCTA/lua/TAweapon.lua').TAweapon
local TAutils = import('/mods/SCTA/lua/TAutils.lua')
local TACommanderDeathWeapon = import('/mods/SCTA/lua/TAweapon.lua').TACommanderDeathWeapon
local TACommanderSuicideWeapon = import('/mods/SCTA/lua/TAweapon.lua').TACommanderSuicideWeapon

#ARM Commander - Commander

ARMCOM = Class(TAconstructor) {
	motion = 'Stopped',
	cloakOn = false,
	cloakSet = false,

	Weapons = {
		ARMCOMLASER = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				
			end,
		},
		ARM_DISINTEGRATOR = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				
				self.unit:SetWeaponEnabledByLabel('ARM_DISINTEGRATOR', true)
			end,

		        OnLostTarget = function(self)
				self.unit:SetWeaponEnabledByLabel('ARM_DISINTEGRATOR', true)
				TAweapon.OnLostTarget(self)
		        end,
		},
		DeathWeapon = Class(TACommanderDeathWeapon) {},
		SuicideWeapon = Class(TACommanderSuicideWeapon) {},
	},

	OnCreate = function(self)
		self.Spinners = {
			torso = CreateRotator(self, 'Torso', 'y', nil, 0, 0, 0),
			luparm = CreateRotator(self, 'LeftLowerArm', 'x', nil, 0, 0, 0),
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
		TAconstructor.OnCreate(self)
        self:SetIntelRadius('Omni', 0)
		ForkThread(self.CloakDetection, self)
	end,

	OnStartCapture = function(self, target)
		self:SetCaptureTimeMultiplier(1)
		self:SetBuildRate(self:GetBlueprint().Economy.BuildRate * 0.6)
		TAconstructor.OnStartCapture(self, target)
		self.desiredTarget = target
		if (self.currentState == "aimed") then
			self.currentState = "opened"
			self.desiredState = "aimed"
		else
			self.desiredState = "opened"
		end
		self.isReclaiming = false
		self.isBuilding = false
		self.cloakOn = false
		self.isCapturing = true
		self.wantStopAnimation = false
		if (self.animating == false) then
			ForkThread(self.AnimationThread, self)
		end
	end,

	CloakDetection = function(self)
		while not IsDestroyed(self) and self:IsDead() do
			WaitSeconds(1)
			local pos = self:GetPosition()
			local area = Rect(pos.x - 4, pos.z - 4, pos.x + 4, pos.z + 4)
			local unitsInRect = GetUnitsInRect(area)
			local enemyClose = false
			for k, v in unitsInRect do
				if v != self and v:GetArmy() != self:GetArmy() then
					if self.cloakOn == true then
						self.cloakOn = false
						self:DisableIntel('Cloak')
						self:SetMesh(self:GetBlueprint().Display.MeshBlueprint, true)
					end
					enemyClose = true
				end
			end
			if enemyClose == false then
				if self.cloakSet == true then
					self.cloakOn = true
					self:EnableIntel('Cloak')
					self:SetMesh('/mods/SCTA/units/ARMCOM/ARMCOM_cloak_mesh', true)
				end
			end
		end
	end,

	PlayCommanderWarpInEffect = function(self)
        self:HideBone(0, true)
        self:SetUnSelectable(true)
        self:SetBusy(true)
        self:SetBlockCommandQueue(true)
        self:ForkThread(self.WarpInEffectThread)
    end,

    WarpInEffectThread = function(self)
        self:PlayUnitSound('CommanderArrival')
        self:CreateProjectile( '/effects/entities/UnitTeleport01/UnitTeleport01_proj.bp', 0, 1.35, 0, nil, nil, nil):SetCollision(false)
        WaitSeconds(2.1)
		self:ShowBone(0, true)
		self:HideBone('DGunMuzzle', true)
        self:HideBone('LaserMuzzle', true)
        self:SetUnSelectable(false)
        self:SetBusy(false)
        self:SetBlockCommandQueue(false)
        WaitSeconds(6)
		self:SetMesh(self:GetBlueprint().Display.MeshBlueprint, true)
    end,

	OnStopBeingBuilt = function(self,builder,layer)
		TAconstructor.OnStopBeingBuilt(self,builder,layer)
		ForkThread(self.GiveInitialResources, self)
			self:SetScriptBit('RULEUTC_CloakToggle', true)
	end,
	
	OnMotionHorzEventChange = function( self, new, old )
		TAconstructor.OnMotionHorzEventChange(self, new, old)
		if old == 'Stopped' then
			self:SetConsumptionPerSecondEnergy(1000)
			self.motion = 'Moving'
		elseif new == 'Stopped' then
			self:SetConsumptionPerSecondEnergy(200)
			self.motion = 'Stopped'
		end
	end,

	OnIntelDisabled = function(self)
		self.cloakOn = false
		self.cloakSet = false
            	self:SetIntelRadius('Omni', 0)
        	self:PlayUnitSound('Uncloak')
		self:SetMesh(self:GetBlueprint().Display.MeshBlueprint, true)
	end,

	OnIntelEnabled = function(self)
		if self.motion == 'Moving' then
			self:SetConsumptionPerSecondEnergy(1000)
		end
            	self:SetIntelRadius('Omni', 3)
		self.cloakOn = true
		self.cloakSet = true
        	self:PlayUnitSound('Cloak')
		self:SetMesh('/mods/SCTA/units/ARMCOM/ARMCOM_cloak_mesh', true)
	end,



	OnScriptBitSet = function(self, bit)
		if bit == 8 then
		end
		TAconstructor.OnScriptBitSet(self, bit)
	end,


	OnScriptBitClear = function(self, bit)
		if bit == 8 then
		end
		TAconstructor.OnScriptBitClear(self, bit)
	end,

	GiveInitialResources = function(self)
		#need to convert options to ints - they are strings
		self:GetAIBrain():GiveResource('ENERGY', self:GetBlueprint().Economy.StorageEnergy)
		self:GetAIBrain():GiveResource('MASS', self:GetBlueprint().Economy.StorageMass)
	end,

	OnKilled = function(self, instigator, type, overkillRatio)
		TAconstructor.OnKilled(self, instigator, type, overkillRatio)
	end,

	Aim = function(self,target)
		local selfPosition = self:GetPosition('Torso') 
		local targetPosition = target:GetPosition()
			

		--TURN torso to y-axis heading SPEED <300.07>;
		self.Spinners.torso:SetGoal(TAutils.GetAngle(selfPosition.x, selfPosition.z, targetPosition.x, targetPosition.z) - (self:GetHeading() * 180) / math.pi)
		self.Spinners.torso:SetSpeed(300)

		local distance = VDist2(selfPosition.x, selfPosition.z, targetPosition.x, targetPosition.z)
		selfPosition = self:GetPosition('LaserMuzzle') 

		--TURN luparm to x-axis (0 - pitch - 29.99) SPEED <45.01>;
		self.Spinners.luparm:SetGoal(-180 + TAutils.GetAngle(0, selfPosition.y, distance, targetPosition.y))
		self.Spinners.luparm:SetSpeed(45.01)

		WaitFor(self.Spinners.torso)
		WaitFor(self.Spinners.luparm)
		TAconstructor.Aim(self, target)
	end,



	Close = function(self)
		self.Spinners.torso:SetGoal(0)
		self.Spinners.torso:SetSpeed(90)
			
		self.Spinners.luparm:SetGoal(0)
		self.Spinners.luparm:SetSpeed(45)

		WaitFor(self.Spinners.torso)
		WaitFor(self.Spinners.luparm)

		TAconstructor.Close(self)
	end,
}

TypeClass = ARMCOM