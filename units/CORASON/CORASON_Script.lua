local TACloser = import('/mods/SCTA-master/lua/TAStructure.lua').TACloser

CORASON = Class(TACloser) {
	OnCreate = function(self)
		TACloser.OnCreate(self)
		self.Spinners = {
			dish = CreateRotator(self, 'dish', 'y', nil, 0, 0, 0),	
		}
		for k, v in self.Spinners do
			self.Trash:Add(v)
		end
	end,


	OpeningState = State {
		Main = function(self)
			self:EnableIntel('Sonar')
			--[[if not self.TAAnimating then
				self.TAAnimating = true]]
			self.Spinners.dish:SetSpeed(60)
			--end
			TACloser.OpeningState.Main(self)
	end,
	},


	ClosingState = State {
	Main = function(self)
		self:DisableIntel('Sonar')
	--[[if not self.TAAnimating then
				self.TAAnimating = true]]
		self.Spinners.dish:SetSpeed(0)
	--end
	TACloser.ClosingState.Main(self)
	end,
},
}

TypeClass = CORASON
