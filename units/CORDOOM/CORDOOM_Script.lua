#CORE Doomsday Machine - Energy Weapon
#CORDOOM
#
#Script created by Raevn

local TAunit = import('/mods/SCTA/lua/TAunit.lua').TAunit
local TAweapon = import('/mods/SCTA/lua/TAweapon.lua').TAweapon

CORDOOM = Class(TAunit) {
	damageReduction = 1,
	unpacked = false,

	OnCreate = function(self)
		TAunit.OnCreate(self)
		self.Spinners = {
			hatch = CreateRotator(self, 'hatch', 'z', nil, 0, 0, 0),
		}
		self.Sliders = {
			hatch = CreateSlider(self, 'hatch'),
			shell1a = CreateSlider(self, 'shell1a'),
			shell2a = CreateSlider(self, 'shell2a'),
			shell3a = CreateSlider(self, 'shell3a'),
			shell4a = CreateSlider(self, 'shell4a'),
			shell1b = CreateSlider(self, 'shell1b'),
			shell2b = CreateSlider(self, 'shell2b'),
			shell3b = CreateSlider(self, 'shell3b'),
			shell4b = CreateSlider(self, 'shell4b'),
			turreta = CreateSlider(self, 'turreta'),
			turretb = CreateSlider(self, 'turretb'),
			turretc = CreateSlider(self, 'turretc'),
			barrela = CreateSlider(self, 'barrela'),
			barrelb = CreateSlider(self, 'barrelb'),
			barrelc1 = CreateSlider(self, 'barrelc1'),

		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
		for k, v in self.Sliders do
			self.Trash:Add(v)
		end
	end,

	OnDamage = function(self, instigator, amount, vector, damageType)
		TAunit.OnDamage(self, instigator, amount * self.damageReduction, vector, damageType) 
		#Has Damage Reduction
	end,

	Weapons = {
		CORE_DOOMSDAY = Class(TAweapon) {

			PlayFxWeaponUnpackSequence = function(self)
				self.unit.damageReduction = 1
				self.unit.unpacked = true
				TAweapon.PlayFxWeaponUnpackSequence(self)
			end,	

			PlayFxWeaponPackSequence = function(self)
				self.unit.damageReduction = 0.5
				self.unit.unpacked = false
				TAweapon.PlayFxWeaponPackSequence(self)
			end,	
		},
		CORE_LIGHTLASER = Class(TAweapon) {
			PlayFxWeaponUnpackSequence = function(self)
				while (self.unit.unpacked == false) do
					WaitSeconds(0.2)
				end
				TAweapon.PlayFxWeaponUnpackSequence(self)
                        end,
                },
	


		CORE_LASERH1 = Class(TAweapon) {
			PlayFxWeaponUnpackSequence = function(self)
				while (self.unit.unpacked == false) do
					WaitSeconds(0.2)
				end
				TAweapon.PlayFxWeaponUnpackSequence(self)
                        end,
                },

	},
}

TypeClass = CORDOOM
