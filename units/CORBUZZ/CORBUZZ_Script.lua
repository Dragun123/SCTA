local TAunit = import('/mods/SCTA-master/lua/TAunit.lua').TAunit
local TABuzz = import('/mods/SCTA-master/lua/TAweapon.lua').TABuzz
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')

CORBUZZ = Class(TAunit) {
	currentBarrel = 0,

	OnCreate = function(self)
		TAunit.OnCreate(self)
		self.Spinners = {
			Spindle = CreateRotator(self, 'Spindle', 'x', nil, 0, 0, 0),
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
	end,

	Weapons = {
		CORBUZZ_WEAPON = Class(TABuzz) {
			OnWeaponFired = function(self)
				TABuzz.OnWeaponFired(self)
				
				self.unit.currentBarrel = self.unit.currentBarrel + 1
				if self.unit.currentBarrel == 6 then
					self.unit.currentBarrel = 0
				end
				self.unit:CreateProjectileAtBone('/mods/SCTA-master/effects/entities/Shells/ARMVULC_Shell/ARMVULC_Shell_proj.bp','Turret')
				self.unit.Spinners.Spindle:SetGoal(-60 * (self.unit.currentBarrel))
				self.unit.Spinners.Spindle:SetSpeed(1440)
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
TypeClass = CORBUZZ
