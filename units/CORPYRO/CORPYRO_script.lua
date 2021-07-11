#CORE Pyro - Assault Kbot
#CORPYRO
#
#Script created by Raevn


local TAWalking = import('/mods/SCTA-master/lua/TAMotion.lua').TAWalking
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon
  
CORPYRO = Class(TAWalking) {
	OnCreate = function(self)
		TAWalking.OnCreate(self)
		self.lastSound = 0
	end,


	OnStopBeingBuilt = function(self, builder, layer)
		TAWalking.OnStopBeingBuilt(self, builder, layer)
		ForkThread(self.SoundThread,self)
        end,

      	Weapons = {
		FLAMETHROWER = Class(TAweapon) {
			OnWeaponFired = function(self)
				TAweapon.OnWeaponFired(self)
				---LOG(self.unit.lastSound)
				if self.unit.lastSound == 0 then
					self:PlaySound(Sound({Cue = 'FLAMHVY1', Bank = 'TA_Sound', LodCutoff = 'Weapon_LodCutoff'}))
					self.unit.lastSound = 12
				end
			end,
		},

	},

	SoundThread = function(self)
		while not IsDestroyed(self) do
			if self.lastSound > 0 then
				self.lastSound = self.lastSound - 1
			end
			WaitSeconds(0.1)
		end
	end,
}
TypeClass = CORPYRO