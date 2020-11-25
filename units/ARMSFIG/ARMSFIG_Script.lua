#CORE Avenger - Fighter
#ARMSFIG
#
#Script created by Raevn

local TASeaair = import('/mods/SCTA-master/lua/TAair.lua').TASeaair
local TAweapon = import('/mods/SCTA-master/lua/TAweapon.lua').TAweapon

ARMSFIG = Class(TASeaair) {
	moving = false,

	OnCreate = function(self)
		TASeaair.OnCreate(self)
		self.Sliders = {
			chassis = CreateSlider(self, 0),
		}
		for k, v in self.Sliders do
			self.Trash:Add(v)
		end
		self.Spinners = {
			base = CreateRotator(self, 0, 'z', nil, 0, 0, 0),
			winga = CreateRotator(self, 'LWing', 'y', nil, 0, 0, 0),
			wingb = CreateRotator(self, 'RWing', 'y', nil, 0, 0, 0),
		}		
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
	end,


	OpenWings = function(self)
		--TURN winga to z-axis <-91.21> SPEED <63.22>;
		self.Spinners.winga:SetGoal(30)
		self.Spinners.winga:SetSpeed(30)

		--TURN wingb to z-axis <91.21> SPEED <63.22>;
		self.Spinners.wingb:SetGoal(-30)
		self.Spinners.wingb:SetSpeed(30)
		self.moving = true
	end,

	CloseWings = function(self)
		self.moving = false
		--TURN winga to z-axis <0> SPEED <63.13>;
		self.Spinners.winga:SetGoal(0)
		self.Spinners.winga:SetSpeed(63)

		--TURN wingb to z-axis <0> SPEED <63.13>;
		self.Spinners.wingb:SetGoal(0)
		self.Spinners.wingb:SetSpeed(63)
	end,

	Weapons = {
		CORVTOL_MISSILE = Class(TAweapon) {},
		
	},
}

TypeClass = ARMSFIG