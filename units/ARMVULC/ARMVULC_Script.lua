#ARM Vulcan - Rapid Fire Plasma Cannon
#ARMVULC
#
#Script created by Raevn

local TAStructure = import('/mods/SCTA-master/lua/TAStructure.lua').TAStructure
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon
local TAutils = import('/mods/SCTA-master/lua/TAutils.lua')

ARMVULC = Class(TAStructure) {
	OnCreate = function(self)
		TAStructure.OnCreate(self)
		self.Spinners = {
			spindle = CreateRotator(self, 'Spindle', 'z', nil, 0, 0, 0),
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
		self.currentBarrel = 0
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
		},
	},
}

TypeClass = ARMVULC
