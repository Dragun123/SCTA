local TASeaCounter = import('/mods/SCTA-master/lua/TAMotion.lua').TASeaCounter

ARMSCRAM = Class(TASeaCounter) {
	OnCreate = function(self)
		TASeaCounter.OnCreate(self)
		self.Spinners = {
			fork = CreateRotator(self, 'fork', 'z', nil, 100, 50, 0),
		}
		self.Trash:Add(self.Spinners.fork)
	end,

}
TypeClass = ARMSCRAM