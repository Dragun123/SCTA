local oldARMHAWK = ARMHAWK
ARMHAWK = Class(oldARMHAWK) {
	OnStopBeingBuilt = function(self)
		self:SetMaintenanceConsumptionActive()
		oldARMHAWK.OnStopBeingBuilt(self)
end
}
TypeClass = ARMHAWK