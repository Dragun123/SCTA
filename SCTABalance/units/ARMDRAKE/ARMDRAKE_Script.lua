#ARM Drake - Experimental Kbot
#ARMDRAKE
#
#Script created by Raevn

local TAWeaponFile = import('/mods/SCTA-master/lua/TAweapon.lua')
local TAWalking = import('/mods/SCTA-master/lua/TAMotion.lua').TAWalking
local TAweapon = TAWeaponFile.TAweapon
local TARotatingWeapon = TAWeaponFile.TARotatingWeapon

ARMDRAKE = Class(TAWalking) {
	OnCreate = function(self)
		self.Spinners = {
			nozzle1 = CreateRotator(self, 'lbarrel', 'z', nil, 0, 0, 0),
			nozzle2 = CreateRotator(self, 'rbarrel', 'z', nil, 0, 0, 0),
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
		TAWalking.OnCreate(self)
	end,
	
	Weapons = {
		CORKROG_FIRE = Class(TAweapon) {
			PlayFxWeaponUnpackSequence = function(self)
				self.unit.Spinners.nozzle1:SetSpeed(180)
				self.unit.Spinners.nozzle2:SetSpeed(180)
				TAweapon.PlayFxWeaponUnpackSequence(self)
			end,
		
			PlayFxWeaponPackSequence = function(self)
				self.unit.Spinners.nozzle1:SetSpeed(0)
				self.unit.Spinners.nozzle2:SetSpeed(0)
				TAweapon.PlayFxWeaponPackSequence(self)
			end,
			},
		ARMDRAK_LASER = Class(TAweapon) {
		},
		CORKROG_ROCKET = Class(TAweapon) {},
	},
}

TypeClass = ARMDRAKE
