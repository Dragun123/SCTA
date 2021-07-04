#CORE Fortitude Missile Defense - Anti Missile Defense System
#CORFMD
#
#Script created by Raevn

local TAStructure = import('/mods/SCTA-master/lua/TAStructure.lua').TAStructure
local TAMInterceptorWeapon = import('/lua/terranweapons.lua').TAMInterceptorWeapon
local nukeFiredOnGotTarget = false

CORFMD = Class(TAStructure) {

	Weapons = {
		FMD_ROCKET = Class(TAMInterceptorWeapon) {
				IdleState = State(TAMInterceptorWeapon.IdleState) {
					OnGotTarget = function(self)
						local bp = self:GetBlueprint()
						if (bp.WeaponUnpackLockMotion != true or (bp.WeaponUnpackLocksMotion == true and not self.unit:IsUnitState('Moving'))) then
							if (bp.CountedProjectile == false) or self:CanFire() then
								 nukeFiredOnGotTarget = true
							end
						end
						TAMInterceptorWeapon.IdleState.OnGotTarget(self)
					end,
					
					OnFire = function(self)
						if not nukeFiredOnGotTarget then
							TAMInterceptorWeapon.IdleState.OnFire(self)
						end
						nukeFiredOnGotTarget = false
						
						self:ForkThread(function()
							self.unit:SetBusy(true)
							WaitSeconds(1/self.unit:GetBlueprint().Weapon[1].RateOfFire + .2)
							self.unit:SetBusy(false)
						end)
					end,
				},
		},
	},
}

TypeClass = CORFMD
