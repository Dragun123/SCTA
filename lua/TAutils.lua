local util = import('/lua/utilities.lua')

function GetAngleTA(x1, z1, x2, z2)
	local dx = x2 - x1
	local dz = z2 - z1

	local angle = math.atan(math.abs(dz) / math.abs(dx))

	if dz < 0 then
		if dx < 0 then
			angle = math.pi - angle
		elseif dx == 0 then
			angle = math.pi / 2
		end
	elseif dz > 0 then
		if dx < 0 then
			angle = math.pi + angle
		elseif dx > 0 then
			angle = 2 * math.pi - angle
		elseif dx == 0 then
			angle = 3 * math.pi
		end
	else
		if dx < 0 then
			angle = math.pi
		else
			angle = 0
		end
	end
	return (angle / math.pi) * 180 + 90
end

--[[function QueueDelayedWreckage(self,overkillRatio, bp, completed, pos, orientation, health)
	ForkThread(CreateWreckage, self, overkillRatio, bp, completed, pos, orientation, health)
end]]--


--[[function CreateWreckage(self,overkillRatio, bp, completed, pos, orientation, health)
	local TAWreckage = import('/mods/SCTA-master/lua/TAWreckage.lua').TAWreckage
	while not IsDestroyed(self) do
		WaitSeconds(0.4)
	end

	local wreck = bp.Wreckage.Blueprint
	if wreck and completed == 1 then
			
		local prop = CreateProp( pos, wreck )
		pbp = prop:GetBlueprint()


		prop:SetScale(pbp.Display.UniformScale)
		prop:SetOrientation(orientation, true)

		local mass = (pbp.Economy.ReclaimMassMax or 0)
		local energy = (pbp.Economy.ReclaimEnergyMax or 0)
		#change this to point to the wreckage prop intead of the unit blueprint?
		local time = (bp.Wreckage.ReclaimTimeMultiplier or 1) 

		prop:SetMaxReclaimValues(time, mass, energy)

		prop.OriginalUnit = self.OriginalUnit or self
		if not pbp.Physics.BlockPath then
		end
		--prop:DoTakeDamage(prop, overkillRatio * health, Vector(0,0,0), 'Normal')
        	prop.AssociatedBP = bp.BlueprintId
	end
end]]--

targetingFacilityData = {}

function registerTargetingFacility(army)
    if (targetingFacilityData[army]) then
        targetingFacilityData[army] = targetingFacilityData[army] + 1
    else
        targetingFacilityData[army] = 1
    end

end

function unregisterTargetingFacility(army)
    if (targetingFacilityData[army]) then
        targetingFacilityData[army] = targetingFacilityData[army] - 1
    else
        targetingFacilityData[army] = 0
    end
end

function ArmyHasTargetingFacility(army)
    return (targetingFacilityData[army] > 0 and GetArmyBrain(army):GetEconomyStored('ENERGY') > 0)
end