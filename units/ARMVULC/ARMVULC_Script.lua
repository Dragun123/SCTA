#ARM Vulcan - Rapid Fire Plasma Cannon
#ARMVULC
#
#Script created by Raevn

local TAunit = import('/mods/SCTA-master/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')

ARMVULC = Class(TAunit) {
	currentBarrel = 0,

	OnCreate = function(self)
		TAunit.OnCreate(self)
		self.Spinners = {
			spindle = CreateRotator(self, 'Spindle', 'z', nil, 0, 0, 0),
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
	end,

	Weapons = {
		ARMVULC_WEAPON = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				
				self.unit.currentBarrel = self.unit.currentBarrel + 1
				if self.unit.currentBarrel == 4 then
					self.unit.currentBarrel = 0
				end
				self.unit:CreateProjectileAtBone('/mods/SCTA-master/effects/entities/Shells/ARMVULC_Shell/ARMVULC_Shell_proj.bp','Shell')
			end,

    			PlayFxRackReloadSequence = function(self)
				--TURN spindle to z-axis <90> SPEED <400.09>; (for each turn)
				self.unit.Spinners.spindle:SetGoal(-90 * (self.unit.currentBarrel + 1))
				self.unit.Spinners.spindle:SetSpeed(480)

				TAweapon.PlayFxRackReloadSequence(self)
			end,

			OnGotTargetCheck = function(self)
				local army = self.unit:GetArmy()
				local canSee = true
		
				local target = self:GetCurrentTarget()
				if (target) then
					if (IsBlip(target)) then
						target = target:GetSource()
					else
						if (IsUnit(target)) then
							---LOG('This is a unit')
							canSee = target:GetBlip(army)
						end
					end
				end
				local currentTarget = self.unit:GetTargetEntity()
				if (currentTarget and IsBlip(currentTarget)) then
					currentTarget = currentTarget:GetSource()
				end
		
				if (canSee or TAutils.ArmyHasTargetingFacility(self.unit:GetArmy()) or currentTarget == target or (target and IsProp(target)) or EntityCategoryContains(categories.NOCUSTOMTARGET, self.unit)) then
					 return true
				else
					self:ResetTarget()
					return nil
				end
			end,
		},
	},
}

TypeClass = ARMVULC
