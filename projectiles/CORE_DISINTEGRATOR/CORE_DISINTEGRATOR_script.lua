#CORE Commander Disintegrator
#CORE_DISINTEGRATOR
#
#Script created by Raevn

local TALightCannonProjectile = import('/mods/SCTA-master/lua/TAProjectiles.lua').TALightCannonProjectile

CORE_DISINTEGRATOR = Class(TALightCannonProjectile) {
	OnCreate = function(self)
		TALightCannonProjectile.OnCreate(self)
		ForkThread(self.MovementThread,self)
	end,

	MovementThread = function(self)
		while not IsDestroyed(self) do
			local pos = self:GetPosition()
			if pos.y < GetTerrainHeight(pos.x, pos.z) then
				self:SetTurnRate(0)
				pos.y = GetTerrainHeight(pos.x, pos.z)
				DamageArea(self, pos, 1.5, 99999, 'DGun', true)
				self:SetPosition(pos, true)
				self:PlaySound(Sound({Cue = 'XPLOMAS2', Bank = 'TA_Sound', LodCutoff = 'Weapon_LodCutoff'}))
				CreateEmitterAtEntity(self, self:GetArmy(), '/mods/SCTA-master/effects/emitters/ta_missile_hit_04_emit.bp' ):ScaleEmitter(0.5)
			end
			WaitSeconds(0.1)
		end
	end,
}

TypeClass = CORE_DISINTEGRATOR
