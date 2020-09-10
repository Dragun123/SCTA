#CORE Fortitude Missile Defense - Anti Missile Defense System
#CORFMD
#
#Script created by Raevn

local TAnoassistbuild = import('/mods/SCTA/lua/TAnoassistbuild.lua').TAnoassistbuild
local TAweapon = import('/mods/SCTA/lua/TAweapon.lua').TAweapon

CORFMD = Class(TAnoassistbuild) {
	currentRound = 1,
	PackTime = 0,

	OnCreate = function(self)
		TAnoassistbuild.OnCreate(self)
		self.Sliders = {
			dummy = CreateSlider(self, 'dummy'),
			drawer = CreateSlider(self, 'drawer'),
			wedge = CreateSlider(self, 'wedge'),
		}
		for k, v in self.Sliders do
			self.Trash:Add(v)
		end
	end,

	Weapons = {
		FMD_ROCKET = Class(TAweapon) {
		OnWeaponFired = function(self)
			self.unit:ShowBone('dummy', true)
			TAweapon.OnWeaponFired(self)
		end,

		},
	},
}

TypeClass = CORFMD
