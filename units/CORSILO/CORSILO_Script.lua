#CORE Silencer - Nuclear Missile Launcher
#CORSILO
#
#Script created by Raevn

local TAnoassistbuild = import('/mods/SCTA-master/lua/TAunit.lua').TAnoassistbuild
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')

CORSILO = Class(TAnoassistbuild) {
	
	OnCreate = function(self)
		TAnoassistbuild.OnCreate(self)
	end,

	Weapons = {
		CRBLMSSL = Class(TAweapon) {
			PlayFxWeaponUnpackSequence = function(self)
				TAweapon.PlayFxWeaponUnpackSequence(self)
			end,

			PlayFxWeaponPackSequence = function(self)
				TAweapon.PlayFxWeaponPackSequence(self)
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
		
				if (canSee == true or TAutils.ArmyHasTargetingFacility(self.unit:GetArmy()) == true or currentTarget == target or (target and IsProp(target)) or EntityCategoryContains(categories.NOCUSTOMTARGET, self.unit)) then
					 return true
				else
					self:ResetTarget()
					return false
				end
			end,
		},
	},
}

TypeClass = CORSILO
