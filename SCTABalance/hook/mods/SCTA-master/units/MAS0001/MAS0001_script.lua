
local oldMAS0001 = MAS0001

MAS0001 = Class(oldMAS0001) {
    OnStopBeingBuilt = function(self,builder,layer)
		---This removes the build restrictions on Base Game Supcom Factions
		self:RemoveBuildRestriction(categories.PRODUCTSC1)
		if __blueprints['xnl0001'] then
			---If Nomad ACU exists remove build restrictions
			self:RemoveBuildRestriction(categories.NOMADS)
		end
		oldMAS0001.OnStopBeingBuilt(self,builder,layer)
    end,
}


TypeClass = MAS0001

