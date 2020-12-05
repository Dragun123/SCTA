#ARM Commander - Commander
#ARMCOM
#
#Script created by Raevn

local TACommander = import('/mods/SCTA-master/lua/TAconstructor.lua').TACommander
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon
local TADGun = import('/mods/SCTA-master/lua/TAweapon.lua').TADGun
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')
local TACommanderDeathWeapon = import('/mods/SCTAFix/lua/TAweapon.lua').TACommanderDeathWeapon

#ARM Commander - Commander

ARMCOM = Class(TACommander) {
	motion = 'Stopped',
	cloakOn = nil,
	isCapturing = nil,

	Weapons = {
		ARMCOMLASER = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				
			end,
		},
		DGun = Class(TADGun) {
		},
		DeathWeapon = Class(TACommanderDeathWeapon) {},
	},

	OnCreate = function(self)
		self.Spinners = {
			torso = CreateRotator(self, 'Torso', 'y', nil, 0, 0, 0),
			luparm = CreateRotator(self, 'LeftLowerArm', 'x', nil, 0, 0, 0),
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
		TACommander.OnCreate(self)
		self:SetCapturable(false)
	end,

	PlayCommanderWarpInEffect = function(self)
        self:HideBone(0, true)
        self:SetUnSelectable(false)
        self:SetBusy(true)
		self:SetBlockCommandQueue(true)
		self.PlayCommanderWarpInEffectFlag = true
        self:ForkThread(self.ExplosionInEffectThread)
    end,

    ExplosionInEffectThread = function(self)
		self:PlayUnitSound('CommanderArrival')
		self.PlayCommanderWarpInEffectFlag = false
		self:CreateProjectile( '/mods/SCTA-master/effects/entities/TAEntrance/TAEntrance_proj.bp', 0, 1.35, 0, nil, nil, nil):SetCollision(false)
		WaitSeconds(2.1)
		---CreateAttachedEmitter( self, 0, army, '/mods/SCTA-master/effects/emitters/ENTRANCE_emit.bp'):ScaleEmitter(4)
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
		TACommander.OnStopBeingBuilt(self,builder,layer)
		ForkThread(self.GiveInitialResources, self)
			self:SetScriptBit('RULEUTC_CloakToggle', true)
			self:ForkThread(self.PlayCommanderWarpInEffect)
	end,

	OnMotionHorzEventChange = function(self, new, old )
		TACommander.OnMotionHorzEventChange(self, new, old)
		if old == 'Stopped' then
			self:SetConsumptionPerSecondEnergy(1000)
			self.motion = 'Moving'
		elseif new == 'Stopped' then
			self:SetConsumptionPerSecondEnergy(200)
			self.motion = 'Stopped'
		end
	end,

	OnIntelDisabled = function(self)
		self.cloakOn = nil
		self:DisableIntel('Cloak')
        self:SetIntelRadius('Omni', 10)
        self:PlayUnitSound('Uncloak')
		self:SetMesh(self:GetBlueprint().Display.MeshBlueprint, true)
	end,

	OnIntelEnabled = function(self)
		--self:EnableIntel('Cloak')
		if self.motion == 'Moving' then
			self:SetConsumptionPerSecondEnergy(1000)
		end
        self:SetIntelRadius('Omni', self:GetBlueprint().Intel.OmniRadius)
		self.cloakOn = true
        	self:PlayUnitSound('Cloak')
		self:SetMesh('/mods/SCTA-master/units/ARMCOM/ARMCOM_cloak_mesh', true)
		ForkThread(TACommander.CloakDetection, self)
		--end
	end,



	OnScriptBitSet = function(self, bit)
		if bit == 8 then
			self:OnIntelDisabled()
			if self.CloakThread then KillThread(self.CloakThread) end
			self.CloakThread = self:ForkThread(TACommander.CloakDetection)	
		end
		TACommander.OnScriptBitSet(self, bit)
	end,


	OnScriptBitClear = function(self, bit)
		if bit == 8 then
			if self.CloakThread then
				KillThread(self.CloakThread)
				self.cloakOn = nil
			end
		end
		TACommander.OnScriptBitClear(self, bit)
	end,


	GiveInitialResources = function(self)
		#need to convert options to ints - they are strings
		self:GetAIBrain():GiveResource('ENERGY', self:GetBlueprint().Economy.StorageEnergy)
		self:GetAIBrain():GiveResource('MASS', self:GetBlueprint().Economy.StorageMass)
	end,

	OnKilled = function(self, instigator, type, overkillRatio)
		TACommander.OnKilled(self, instigator, type, overkillRatio)
	end,

	Aim = function(self,target)
		local selfPosition = self:GetPosition('Torso') 
		local targetPosition = target:GetPosition()
			

		--TURN torso to y-axis heading SPEED <300.07>;
		self.Spinners.torso:SetGoal(TAutils.GetAngleTA(selfPosition.x, selfPosition.z, targetPosition.x, targetPosition.z) - (self:GetHeading() * 180) / math.pi)
		self.Spinners.torso:SetSpeed(300)

		local distance = VDist2(selfPosition.x, selfPosition.z, targetPosition.x, targetPosition.z)
		selfPosition = self:GetPosition('LaserMuzzle') 

		--TURN luparm to x-axis (0 - pitch - 29.99) SPEED <45.01>;
		self.Spinners.luparm:SetGoal(-180 + TAutils.GetAngleTA(0, selfPosition.y, distance, targetPosition.y))
		self.Spinners.luparm:SetSpeed(45.01)

		WaitFor(self.Spinners.torso)
		WaitFor(self.Spinners.luparm)
		TACommander.Aim(self, target)
	end,



	Close = function(self)
		self.Spinners.torso:SetGoal(0)
		self.Spinners.torso:SetSpeed(90)
			
		self.Spinners.luparm:SetGoal(0)
		self.Spinners.luparm:SetSpeed(45)

		WaitFor(self.Spinners.torso)
		WaitFor(self.Spinners.luparm)

		TACommander.Close(self)
	end,
}

TypeClass = ARMCOM