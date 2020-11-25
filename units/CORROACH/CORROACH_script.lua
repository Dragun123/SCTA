#CORE Roach - Crawling Bomb
#CORROACH
#
#Script created by Raevn


local TAWalking = import('/mods/SCTA-master/lua/TAMotion.lua').TAWalking
local TABomb = import('/mods/SCTA-master/lua/TAweapon.lua').TABomb
local TAKami = import('/mods/SCTA-master/lua/TAweapon.lua').TAKami

CORROACH = Class(TAWalking) {
	attacked = false,

	Weapons = {
			DeathWeapon = Class(TABomb) {},
			Suicide = Class(TAKami) {        
				OnFire = function(self)			
					#disable death weapon
					self.unit:SetDeathWeaponEnabled(false)
					TAKami.OnFire(self)
				end,
			},
		},
}
TypeClass = CORROACH