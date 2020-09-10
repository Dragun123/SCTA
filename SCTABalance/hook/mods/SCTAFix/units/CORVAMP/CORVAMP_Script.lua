local oldCORVAMP = CORVAMP
CORVAMP = Class(oldCORVAMP) {
	OnStopBeingBuilt = function(self)
	self:SetMaintenanceConsumptionActive()
	oldCORVAMP.OnStopBeingBuilt(self)	
	end
}

TypeClass = CORVAMP