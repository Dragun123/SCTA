local TAunit = import('/mods/SCTAFix/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTAFix/lua/TAweapon.lua').TAweapon

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
		CORBUZZ_WEAPON = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				
				self.unit.currentBarrel = self.unit.currentBarrel - 1
				if self.unit.currentBarrel == 1 then
					self.unit.currentBarrel = 6
				end
				self.unit:CreateProjectileAtBone('/mods/SCTAFix/effects/entities/Shells/ARMVULC_Shell/ARMVULC_Shell_proj.bp','Turret')
			end,

    			PlayFxRackReloadSequence = function(self)
				--TURN spindle to z-axis <90> SPEED <400.09>; (for each turn)
				self.unit.Spinners.Spindle:SetGoal(-45 * (self.unit.currentBarrel - 1))
				self.unit.Spinners.Spindle:SetSpeed(480)

				TAweapon.PlayFxRackReloadSequence(self)
			end,
		},
	},
}
TypeClass = CORBUZZ
