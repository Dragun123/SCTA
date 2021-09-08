#CORE Diplomat - Mobile Rocket Launcher
#CORHRK
#
#Script created by Raevn

local TAWalking = import('/mods/SCTA-master/lua/TAMotion.lua').TAWalking
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon

CORHRK = Class(TAWalking) {
	Weapons = {
		CORTRUCK_ROCKET = Class(TAweapon) {

				PlayFxRackReloadSequence = function(self)
					self.unit:ShowBone('Missile1', true)
					--WaitSeconds(0.025)
					coroutine.yield(2)
					self.unit:ShowBone('Missile2', true)
				TAweapon.PlayFxRackReloadSequence(self)
			end,

			PlayFxWeaponUnpackSequence = function(self)
				self.unit:ShowBone('Missile1', true)
				---WaitSeconds(0.025)
				coroutine.yield(2)
				self.unit:ShowBone('Missile2', true)
				TAweapon.PlayFxWeaponUnpackSequence(self)
			end,
		},		
	},
}
TypeClass = CORHRK
