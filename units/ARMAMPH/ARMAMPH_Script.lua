#ARM Pelican - Amphibious Kbot
#ARMAMPH
#
#Script created by Axle

local TASeaWalking = import('/mods/SCTA-master/lua/TAMotion.lua').TASeaWalking
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon


ARMAMPH = Class(TASeaWalking) {
	OnStopBeingBuilt = function(self,builder,layer)
        TASeaWalking.OnStopBeingBuilt(self,builder,layer)
        # If created with F2 on land, then play the transform anim.
        self.Walking = true
        self.SwitchAnims = true
        self.IsWaiting = nil
        if(self:GetCurrentLayer() == 'Water') then
            self.AT1 = self:ForkThread(self.TransformThread, true)
        end
    end,

	OnMotionHorzEventChange = function(self, new, old)
        TASeaWalking.OnMotionHorzEventChange(self, new, old)
        if self.Dead then return end
        if( not self.IsWaiting ) then
            if( self.Swim ) then
                if( old == 'Stopped' ) then
                    if( self.SwitchAnims ) then
                        self.SwitchAnims = nil
                        self.Walking = nil
                    else
                        self.AnimManip:SetRate(2.8)
                    end
                elseif( new == 'Stopped' ) then
                    self.AnimManip:SetRate(0)
                end
            end
        end
    end,

    OnLayerChange = function(self, new, old)
        TASeaWalking.OnLayerChange(self, new, old)
        if( old != 'None' ) then
            if( self.AT1 ) then
                self.AT1:Destroy()
                self.AT1 = nil
            end
            local myBlueprint = self:GetBlueprint()
            if( new == 'Water' ) then
				self.AT1 = self:ForkThread(self.TransformThread, true)
			elseif( new == 'Land' ) then
					self.AT1 = self:ForkThread(self.TransformThread, false)
            end
        end
    end,

    TransformThread = function(self, water)
        if( not self.AnimManip ) then
            self.AnimManip = CreateAnimator(self)
        end
        local bp = self:GetBlueprint()
        local scale = 0.5

        if( water ) then
            # Change movement speed to the multiplier in blueprint
            self:SetSpeedMult(bp.Physics.WaterSpeedMultiplier)
            self:SetImmobile(true)
            self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationTransform)
            self.AnimManip:SetRate(0.5)
            self.IsWaiting = true
            WaitFor(self.AnimManip)
            self:SetCollisionShape( 'Box', bp.CollisionOffsetX or 0,(bp.CollisionOffsetY + (bp.SizeY * 0.25)) or 0,bp.CollisionOffsetZ or 0, bp.SizeX * scale, bp.SizeY * scale, bp.SizeZ * scale )
            self.IsWaiting = nil
            self:SetImmobile(false)
            self.SwitchAnims = true
			self.Walking = true
            self.Trash:Add(self.AnimManip)
		else	
            self:SetImmobile(true)
            # Revert speed to maximum speed
            self:SetSpeedMult(1)
			---self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationTransformLand)
			self.AnimManip:PlayAnim(self:GetBlueprint().Display.AnimationTransform)
            self.AnimManip:SetAnimationFraction(1)
            self.AnimManip:SetRate(-2)
            self.IsWaiting = true
			WaitFor(self.AnimManip)
			self:SetCollisionShape( 'Box', bp.CollisionOffsetX or 0,(bp.CollisionOffsetY + (bp.SizeY*0.5)) or 0,bp.CollisionOffsetZ or 0, bp.SizeX * scale, bp.SizeY * scale, bp.SizeZ * scale )
            self.IsWaiting = nil
            self.AnimManip:Destroy()
            self.AnimManip = nil
            self:SetImmobile(false)
			self.Walking = true
			self.Trash:Add(self.AnimManip)
		end
    end,

	Weapons = {
		WEAPON = Class(TAweapon) {
		},
	},

}

TypeClass = ARMAMPH
