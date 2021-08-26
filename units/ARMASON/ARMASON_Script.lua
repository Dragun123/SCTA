#ARM Advanced Sonar Station - Extended Sonar
#ARMASON
#
#Script created by Raevn

local TACloser = import('/mods/SCTA-master/lua/TAStructure.lua').TACloser

ARMASON = Class(TACloser) {

	OnCreate = function(self)
		TACloser.OnCreate(self)
		self.Spinners = {
			wheel = CreateRotator(self, 'wheel', 'y', nil, 0, 0, 0),
			base = CreateSlider(self, 'ARMASON'),
		}
		self.AnimManip = CreateAnimator(self)
		self.Trash:Add(self.AnimManip)
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
	end,

	OnStopBeingBuilt = function(self,builder,layer)
		TACloser.OnStopBeingBuilt(self,builder,layer)
		self:DisableIntel('RadarStealth')
		self.bp = self:GetBlueprint()
		self.scale = 0.5
		self:SetCollisionShape( 'Box', self.bp.CollisionOffsetX or -5,(self.bp.CollisionOffsetY + (self.bp.SizeY*-0.25)) or 0,self.bp.CollisionOffsetZ or -5, self.bp.SizeX * self.scale, self.bp.SizeY * self.scale, self.bp.SizeZ * self.scale )
	end,

	OnDestroy = function(self)
		if self.GeneratorCollision then
		self.GeneratorCollision:Destroy()
		end
		TACloser.OnDestroy(self)
	end,

	ClosingState = State {
		Main = function(self)
			self:DisableIntel('Sonar')
			self:EnableIntel('RadarStealth')
			self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationRepack)
			self.AnimManip:SetRate(self:GetBlueprint().Display.AnimationRepackRate)
		
				--MOVE base to y-axis <-15.00> SPEED <5.00>;
				self.Spinners.base:SetGoal(0,-15,0)
				self.Spinners.base:SetSpeed(5)
		
				--STOP-SPIN wheel around y-axis;
				self.Spinners.wheel:SetSpeed(0)
				if self.GeneratorCollision then
					---if the unit falls then the box is destroyed again
					self.GeneratorCollision:Destroy()
					self.GeneratorCollision = nil
				end
				TACloser.ClosingState.Main(self)
			end,
			},
			
		

	OpeningState = State {
		Main = function(self)
			self:EnableIntel('Sonar')
			if not self.GeneratorCollision then
				local pos = self:GetPosition()
				self.GeneratorCollision = CreateUnitHPR('Falling',self:GetArmy(),pos[1],pos[2],pos[3],0,0,0)
            	self.GeneratorCollision:SetCollisionShape( 'Box', self.bp.CollisionOffsetX or 0,(self.bp.CollisionOffsetY + (self.bp.SizeY*0.5)) or 0,self.bp.CollisionOffsetZ or 0, self.bp.SizeX * self.scale, self.bp.SizeY * self.scale, self.bp.SizeZ * self.scale )
				self.GeneratorCollision.Parent = self
        	end
			self:DisableIntel('RadarStealth')
			self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationUnpack)
			self.AnimManip:SetRate(1 * (self:GetBlueprint().Display.AnimationUnpackRate or 0.2))
		--MOVE base to y-axis <0> SPEED <5.00>;
		self.Spinners.base:SetGoal(0,0,0)
		self.Spinners.base:SetSpeed(5)

		--SPIN wheel around y-axis  SPEED <60.01>;
		self.Spinners.wheel:SetSpeed(60)
		TACloser.OpeningState.Main(self)
	end,
	},
}

TypeClass = ARMASON
