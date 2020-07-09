local TAunit = import('/mods/SCTA/lua/TAunit.lua').TAunit
local util = import('/lua/utilities.lua')

TAWalking = Class(TAunit) 
{
    WalkingAnim = nil,
    WalkingAnimRate = 1,
    IdleAnim = false,
    IdleAnimRate = 1,
    DeathAnim = false,
    DisabledBones = {},

    OnMotionHorzEventChange = function( self, new, old )
        TAunit.OnMotionHorzEventChange(self, new, old)
        
        if ( old == 'Stopped' ) then
            if (not self.Animator) then
                self.Animator = CreateAnimator(self, true)
            end
            local bpDisplay = self:GetBlueprint().Display
            if bpDisplay.AnimationWalk then
                self.Animator:PlayAnim(bpDisplay.AnimationWalk, true)
                self.Animator:SetRate(bpDisplay.AnimationWalkRate or 1)
            end
        elseif ( new == 'Stopped' ) then
            # only keep the animator around if we are dying and playing a death anim
            # or if we have an idle anim
            if(self.IdleAnim and not self:IsDead()) then
                self.Animator:PlayAnim(self.IdleAnim, true)
            elseif(not self.DeathAnim or not self:IsDead()) then
                self.Animator:Destroy()
                self.Animator = false
            end
        end
    end,
    
    CreateDebrisProjectiles = function(self)
	    local bp = self:GetBlueprint()
	    local sx = bp.SizeX
	    local sy = bp.SizeY
	    local sz = bp.SizeZ
	    local partamounts = util.GetRandomInt( bp.Display.DestructionEffects.DefaultFlamingProjectileCountMin or 1, bp.Display.DestructionEffects.DefaultFlamingProjectileCountMax or ((sx * sz / 4) + 3)) 
		LOG("PartAmounts: ",partamounts)
	    for i = 1, partamounts do
	        local xpos, ypos, zpos = util.GetRandomOffset( sx, sy, sz, 1)
        	local xdir,ydir,zdir = util.GetRandomOffset( sx, sy, sz, 10)
        	self:CreateProjectile('/mods/SCTA/effects/entities/Debris/Flame/DefaultFlameProjectileDebris_proj.bp',xpos,ypos,zpos,xdir,ydir + 5,zdir)
	    end
	    partamounts = util.GetRandomInt( bp.Display.DestructionEffects.DefaultProjectileCountMin or 5, bp.Display.DestructionEffects.DefaultProjectileCountMax or (sx * sz + 4)) 
		LOG("PartAmounts: ",partamounts)
	    local z = math.cos(self:GetHeading())
	    local x = math.sin(self:GetHeading())
	    for i = 1, partamounts do
	        local xpos, ypos, zpos = util.GetRandomOffset( sx, sy, sz, 1)
        	local xdir,ydir,zdir = util.GetRandomOffset( sx, sy, sz, 10)

		local debrisList = {}
		if bp.Display.DestructionEffects.DefaultProjectileCategories then
			for k, v in bp.Display.DestructionEffects.DefaultProjectileCategories do
				for ek, ev in debrisCat.RULEDPC[v] do
					table.insert(debrisList, ev)
				end
			end
		else
			debrisList = debrisCat.RULEDPC.RULEDPC_Generic
		end
		if debrisList then
			if bp.Display.DestructionEffects.DestructionDebrisUseLocalVelocity and bp.Display.DestructionEffects.DestructionDebrisUseLocalVelocity == true then
				speed = bp.Physics.MaxSpeed
				if self.CurrentSpeed == 'Stopped' then
					speed = 0
				elseif self.CurrentSpeed == 'Cruise' then
					speed = speed / 2
				elseif self.CurrentSpeed == 'Stopping' then
					speed = speed / 5
				end
				xdir = xpos + x*speed
				zdir = zpos + z*speed
				ydir = ypos + sy
			end
	        	local debris = self:CreateProjectile(debrisList[util.GetRandomInt(1,table.getn(debrisList))],xpos,ypos,zpos,xdir,ydir,zdir)
			if bp.Display.DestructionEffects.DestructionDebrisUseLocalVelocity and bp.Display.DestructionEffects.DestructionDebrisUseLocalVelocity == true then
				debris:SetVelocity(speed)
			end
		end
	    end
	    if bp.Display.DestructionEffects.DestructionProjectiles then
		    for k, v in bp.Display.DestructionEffects.DestructionProjectiles do
	        	self:CreateProjectileAtBone(v.ProjectileBlueprint,v.Bone)
		    end
	    end
	end,

	HideFlares = function(self)
		local bp = self:GetBlueprint()
		if bp.Weapon then
			for w, weapon in bp.Weapon do
				if weapon.RackBones and weapon.Fake ~= true then
					for k, flare in weapon.RackBones do
						if not flare.HideMuzzle or flare.HideMuzzle == false then
							self:HideBone(flare.MuzzleBones[1], true)
						end
					end
				end
			end
		end
	end,

    OnReclaimed = function(self, entity)
        self:DoUnitCallbacks('OnReclaimed', entity)
        self.CreateReclaimEndEffects( entity, self )
	#OnKilled = function(self, instigator, type, overkillRatio)
        self:OnKilled(entity, "Reclaimed", 0.0)
    end,

    DeathThread = function( self, overkillRatio, instigator)

        #LOG('*DEBUG: OVERKILL RATIO = ', repr(overkillRatio))

        #WaitSeconds( utilities.GetRandomFloat( self.DestructionExplosionWaitDelayMin, self.DestructionExplosionWaitDelayMax) )
        self:DestroyAllDamageEffects()

        if self.PlayDestructionEffects then
            self:CreateDestructionEffects( self, overkillRatio )
        end

        #MetaImpact( self, self:GetPosition(), 0.1, 0.5 )
        if self.DeathAnimManip then
            WaitFor(self.DeathAnimManip)
            if self.PlayDestructionEffects and self.PlayEndAnimDestructionEffects then
                self:CreateDestructionEffects( self, overkillRatio )
            end
        end

        self:CreateWreckage( overkillRatio )
        if( self.ShowUnitDestructionDebris and overkillRatio ) then
            if overkillRatio <= 1 then
                self.CreateUnitDestructionDebris( self, true, true, false )
            elseif overkillRatio <= 2 then
                self.CreateUnitDestructionDebris( self, true, true, false )
            elseif overkillRatio <= 3 then
                self.CreateUnitDestructionDebris( self, true, true, true )
            else #VAPORIZED
                self.CreateUnitDestructionDebris( self, true, true, true )
            end
        end

        #LOG('*DEBUG: DeathThread Destroying in ',  self.DeathThreadDestructionWaitTime )
        WaitSeconds(self.DeathThreadDestructionWaitTime)

        self:PlayUnitSound('Destroyed')
        self:Destroy()
	end,
}

TypeClass = TAWalking
