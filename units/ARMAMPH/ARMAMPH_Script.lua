#ARM Pelican - Amphibious Kbot
#ARMAMPH
#
#Script created by Axle

local TAWalking = import('/mods/SCTA-master/lua/TAMotion.lua').TAWalking
local TAunit = import('/mods/SCTA-master/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon


ARMAMPH = Class(TAWalking) {
	OnStopBeingBuilt = function(self,builder,layer)
        TAWalking.OnStopBeingBuilt(self,builder,layer)
        self.Walking = true
        if(self.Layer == 'Water') then
            self.AT1 = self:ForkThread(self.TransformThread, true)
        end
    end,

    OnMotionHorzEventChange = function( self, new, old )
        if self.Walking then
        TAWalking.OnMotionHorzEventChange(self, new, old)
        else
            TAunit.OnMotionHorzEventChange(self, new, old)
            ---_ALERT('PELICASCTA3', self:GetVelocity())
            if ( new == 'Cruise' and old == 'Stopped') then
                self:ForkThread(self.StartMoveFxTA)
            end
            if ( new == 'Stopped' ) or ( new == 'Stopped' and old == 'Stopping' ) then
                self:ForkThread(self.MoveFxStopTA)
            end
        end
    end,

    OnLayerChange = function(self, new, old)
        TAWalking.OnLayerChange(self, new, old)
        if( old != 'None' ) then
            if( self.AT1 ) then
                self.AT1:Destroy()
                self.AT1 = nil
            end
            local myBlueprint = self:GetBlueprint()
            --_ALERT('PELICASCTA2', self:GetVelocity())
            if not self.Waiting then
                if( new == 'Water' ) then
				self.AT1 = self:ForkThread(self.TransformThread, true)
			    elseif( new == 'Land' ) then
				self.AT1 = self:ForkThread(self.TransformThread)
                end
            end
        end
    end,

    TransformThread = function(self, water)
        if( not self.Transform ) then
            self.Transform = CreateAnimator(self)
        end
        local bp = self:GetBlueprint()
        local scale = 0.5
        self:SetImmobile(true)
        self.IsWaiting = true
        ---_ALERT('SCTAIEXIST', water)
        if( water ) then
            self.Walking = nil
            ---Change movement speed to the multiplier in blueprint
            --self:SetSpeedMult(bp.Physics.WaterSpeedMultiplier * 1)
            self.Transform:PlayAnim(self:GetBlueprint().Display.AnimationTransform)
            self.Transform:SetRate(0.5)
            WaitFor(self.Transform)
            self:SetCollisionShape( 'Box', bp.CollisionOffsetX or 0,(bp.CollisionOffsetY + (bp.SizeY * 0.75)) or 0,bp.CollisionOffsetZ or 0, bp.SizeX * scale, bp.SizeY * scale, bp.SizeZ * scale )
            --_ALERT('PELICASCTA', self:GetVelocity())
		else	
            self.Walking = true
            --self:SetSpeedMult(1 * 1)
			self.Transform:PlayAnim(self:GetBlueprint().Display.AnimationTransform)
            self.Transform:SetAnimationFraction(1)
            self.Transform:SetRate(-2)
			WaitFor(self.Transform)
            self:RevertCollisionShape()
            --_ALERT('PELICASCTA', self:GetVelocity())
			--self:SetCollisionShape( 'Box', bp.CollisionOffsetX or 0,(bp.CollisionOffsetY + (bp.SizeY*0.5)) or 0,bp.CollisionOffsetZ or 0, bp.SizeX * scale, bp.SizeY * scale, bp.SizeZ * scale )
            self.Transform:Destroy()
            self.Transform = nil
            end
        self.IsWaiting = nil
        self:SetImmobile(false)
		self.Trash:Add(self.Transform)
    end,

	Weapons = {
		WEAPON = Class(TAweapon) {
		},
	},

}

TypeClass = ARMAMPH
