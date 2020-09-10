function GetDistanceBetweenTwoEntities(entity1, entity2)
    return VDist3(entity1:GetPosition(),entity2:GetPosition())
end

-- Function originally created to check if a Mass Storage can be queued in a location without overlapping
function CanBuildInSpot(originUnit, unitId, pos)
    local bp = __blueprints[unitId]
    local mySkirtX = bp.Physics.SkirtSizeX / 2
    local mySkirtZ = bp.Physics.SkirtSizeZ / 2

    -- Find the distance between my skirt and the skirt of a potential Quantum Gateway
    local xDiff = mySkirtX + 5 -- Using 5 because that's half the size of a Quantum Gateway, the largest stock structure
    local zDiff = mySkirtZ + 5

    -- Full extent of search rectangle
    local x1 = pos.x - xDiff
    local z1 = pos.z - zDiff
    local x2 = pos.x + xDiff
    local z2 = pos.z + zDiff

    -- Find all the units in that rectangle
    local units = GetUnitsInRect(Rect(x1, z1, x2, z2))

    -- Filter it down to structures and experimentals only
    units = EntityCategoryFilterDown(categories.STRUCTURE + categories.EXPERIMENTAL, units)

    -- Bail if there's nothing in range
    if not units[1] then return false end

    for _, struct in units do
        if struct ~= originUnit then
            local structPhysics = struct:GetBlueprint().Physics
            local structPos = struct:GetPosition()

            -- These can be positive or negative, so we need to make them positive using math.abs
            local xDist = math.abs(pos.x - structPos.x)
            local zDist = math.abs(pos.z - structPos.z)

            local skirtDiffx = mySkirtX + (structPhysics.SkirtSizeX / 2)
            local skirtDiffz = mySkirtZ + (structPhysics.SkirtSizeZ / 2)

            -- Check if the axis difference is smaller than the combined skirt distance
            -- If it is, we overlap, and can't build here
            if xDist < skirtDiffx and zDist < skirtDiffz then
                return false
            end
        end
    end

    return true
end

-- Note: Includes allied units in selection!!
function GetEnemyUnitsInSphere(unit, position, radius)
    local x1 = position.x - radius
    local y1 = position.y - radius
    local z1 = position.z - radius
    local x2 = position.x + radius
    local y2 = position.y + radius
    local z2 = position.z + radius
    local UnitsinRec = GetUnitsInRect(Rect(x1, z1, x2, z2))

    -- Check for empty rectangle
    if not UnitsinRec then
        return UnitsinRec
    end

    local RadEntities = {}
    for _, v in UnitsinRec do
        local dist = VDist3(position, v:GetPosition())
        if unit.Army ~= v.Army and dist <= radius then
            table.insert(RadEntities, v)
        end
    end

    return RadEntities
end

-- This function is like the one above, but filters out Allied units
function GetTrueEnemyUnitsInSphere(unit, position, radius, categories)
    local x1 = position.x - radius
    local y1 = position.y - radius
    local z1 = position.z - radius
    local x2 = position.x + radius
    local y2 = position.y + radius
    local z2 = position.z + radius
    local UnitsinRec = GetUnitsInRect(Rect(x1, z1, x2, z2))

    -- Check for empty rectangle
    if not UnitsinRec then
        return UnitsinRec
    end

    local RadEntities = {}
    for _, v in UnitsinRec do
        local dist = VDist3(position, v:GetPosition())
        local vArmy = v.Army
        if unit.Army ~= vArmy and not IsAlly(unit.Army, vArmy) and dist <= radius and EntityCategoryContains(categories or categories.ALLUNITS, v) then
            table.insert(RadEntities, v)
        end
    end

    return RadEntities
end

function GetDistanceBetweenTwoPoints(x1, y1, z1, x2, y2, z2)
    return (math.sqrt((x1-x2)^2 + (y1-y2)^2 + (z1-z2)^2))
end

function GetDistanceBetweenTwoVectors(v1, v2)
    return VDist3(v1, v2)
end

function XZDistanceTwoVectors(v1, v2)
    return VDist2(v1[1], v1[3], v2[1], v2[3])
end

function GetVectorLength(v)
    return math.sqrt(math.pow(v.x, 2) + math.pow(v.y, 2) + math.pow(v.z, 2))
end

function NormalizeVector(v)
    local length = GetVectorLength(v)
    if length > 0 then
        local invlength = 1 / length
        return Vector(v.x * invlength, v.y * invlength, v.z * invlength)
    else
        return Vector(0,0,0)
    end
end

function GetDifferenceVector(v1, v2)
    return Vector(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z)
end

function GetDirectionVector(v1, v2)
    return NormalizeVector(Vector(v1.x - v2.x, v1.y - v2.y, v1.z - v2.z))
end

function GetScaledDirectionVector(v1, v2, scale)
    local vec = GetDirectionVector(v1, v2)
    return Vector(vec.x * scale, vec.y * scale, vec.z * scale)
end

function GetMidPoint(v1, v2)
    return Vector((v1.x + v2.x) * 0.5, (v1.y + v2.y) * 0.5, (v1.z + v2.z) * 0.5)
end

function GetRandomFloat(nmin, nmax)
    return (Random() * (nmax - nmin) + nmin)
end

function GetRandomInt(nmin, nmax)
    return math.floor(Random() * (nmax - nmin + 1) + nmin)
end

function GetRandomOffset(sx, sy, sz, scalar)
    sx = sx * scalar
    sy = sy * scalar
    sz = sz * scalar
    local x = Random() * sx - (sx * 0.5)
    local y = Random() * sy
    local z = Random() * sz - (sz * 0.5)

    return x, y, z
end

function GetRandomOffset2(sx, sy, sz, scalar)
    sx = sx * scalar
    sy = sy * scalar
    sz = sz * scalar
    local x = Random(-1.0, 1.0) * sx - (sx * 0.5)
    local y = Random(-1.0, 1.0) * sy
    local z = Random(-1.0, 1.0) * sz - (sz * 0.5)

    return x, y, z
end

function GetClosestVector(vFrom, vToList)
    local dist, cDist, retVec = 0
    if vToList then
        dist = GetDistanceBetweenTwoVectors(vFrom, vToList[1])
        retVec = vToList[1]
    end

    for kTo, vTo in vToList do
        cDist = GetDistanceBetweenTwoVectors(vFrom, vTo)
        if dist > cDist then
            dist = cDist
            retVec = vTo
        end
    end

    return retVec
end

function Cross(v1, v2)
    return Vector((v1.y * v2.z) - (v1.z * v2.y), (v1.z * v2.x) - (v1.x * v2.z), (v1.x * v2.y) - (v1.y - v2.x))
end

function DotP(v1, v2)
    return (v1.x * v2.x) + (v1.y * v2.y) + (v1.z * v2.z)
end

function GetAngleInBetween(v1, v2)
    -- Normalize the vectors
    local vec1 = {}
    local vec2 = {}
    vec1 = NormalizeVector(v1)
    vec2 = NormalizeVector(v2)
    local dotp = DotP(vec1, vec2)

    return math.acos(dotp) * (360 / (math.pi * 2))
end

function UserConRequest(string)
    if not Sync.UserConRequests then
        Sync.UserConRequests = {}
    end
    table.insert(Sync.UserConRequests, string)
end

function GetAngle(x1, z1, x2, z2)
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

function DoTaperedAreaDamage(instigator, position, radius, damage, projectile, targetEntity, damageType, damageFriendly, damageSelf, edgeEffectiveness)
	local precision = math.floor(radius * 2) + 1
	local pulse = 0
	local edge = edgeEffectiveness or 0

        if radius and radius > 0 then
		if edge * damage > 0 then
			DamageArea(instigator, position, radius, damage * edge, damageType, damageFriendly, damageSelf or false)
		end
		while pulse < precision do
			local factor = (pulse + 1) / precision
       			if damage and damage - edge > 0 then
	            		DamageArea(instigator, position, radius * factor, damage / precision + (1 - factor) * damage * edge, damageType, damageFriendly, damageSelf or false)
        		end
			pulse = pulse + 1
		end
	elseif targetEntity then
		Damage(instigator, position, targetEntity, damage, damageType)
	end
end

function CalcDamageTaper(positionEpicentre, positionEntity, radius, edgeEffectiveness)
    # spherical above, cylindrical below

    local edge = edgeEffectiveness or 0.0
    local taperCoef = (1.0-edge)/radius

    local dx = positionEpicentre.x - positionEntity.x
    local dy = positionEpicentre.y - positionEntity.y
    local dz = positionEpicentre.z - positionEntity.z

    local r = math.sqrt(dx*dx + dy*dy + dz*dz)
    if r > radius then
        return 0.0

    else
        return (1.0 - taperCoef*r)
    end

end


function Clamp(x,lb,ub)
    if x >= ub then
        return ub
    elseif x <= lb then
        return lb
    else
        return x
    end
end


function QueueDelayedWreckage(self,overkillRatio, bp, completed, pos, orientation, health)
	ForkThread(CreateWreckage, self, overkillRatio, bp, completed, pos, orientation, health)
end


function CreateWreckage(self,overkillRatio, bp, completed, pos, orientation, health)
	local TAWreckage = import('/mods/SCTA/lua/TAWreckage.lua').TAWreckage
	while not IsDestroyed(self) do
		WaitSeconds(0.4)
	end

	local wreck = bp.Wreckage.Blueprint
	if wreck and completed == 1 then
			
		local prop = CreateProp( pos, wreck )
		bp = prop:GetBlueprint()


		prop:SetScale(bp.Display.UniformScale)
		prop:SetOrientation(orientation, true)

		local mass = (bp.Economy.ReclaimMassMax or 0)
		local energy = (bp.Economy.ReclaimEnergyMax or 0)
		#change this to point to the wreckage prop intead of the unit blueprint?
		local time = (bp.Wreckage.ReclaimTimeMultiplier or 1) 

		prop:SetMaxReclaimValues(time, mass, energy)

		prop.OriginalUnit = self.OriginalUnit or self
		if bp.Physics.BlockPath == false then
		end
		prop:DoTakeDamage(prop, overkillRatio * health, Vector(0,0,0), 'Normal')
        	prop.AssociatedBP = bp.BlueprintId
	end
end

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


function StringTokeniser (s,tok)

    local line = s
    local tokStart = nil
    local tokEnd = 0
    return function ()
        while line do
            local s, e = string.find(line, ";", tokEnd+1)
            if s then
                tokStart = tokEnd+1
                tokEnd = s
                return string.sub(line, tokStart, tokEnd-1)
            else
                tokStart = tokEnd+1
                substr = string.sub(line, tokStart)
                line = nil
                return substr
            end
        end
        return nil
    end
end


function WordIterator(s)

    local pos,_ = string.find(s,'%S',1)
    return function()
        while pos do
            local nextPos,_ = string.find(s,'%s',pos)

            if nextPos then
                word = string.sub(s,pos,nextPos-1)
                pos,_ = string.find(s,'%S',nextPos)
            else
                word = string.sub(s,pos)
                pos = nil
            end
            return word
        end
        return nil
    end

end


function Cobler(script, spinners, sliders)

    local words
    for line in StringTokeniser(script,';') do
        words = { }
        for word in WordIterator(line) do
            table.insert(words,word)
        end

        if words[1] == "SLEEP" then
            local seconds = tonumber(string.sub(words[2],2,-2)) / 1000.0
            --LOG('SLEEP '..seconds)
            WaitSeconds(seconds)

        elseif words[1] == "TURN" then
            local bone = words[2]
            local axis = words[4]
            local angle = tonumber(string.sub(words[5],2,-2))
            local speed = tonumber(string.sub(words[7],2,-2))
            local spinner = spinners[bone]
            if spinner then
                spinner:SetGoal(angle)
                spinner:SetSpeed(speed)
            else
                LOG('invalid spinner for command: TURN '..bone..' '..angle..' '..speed)
            end

        elseif words[1] == "MOVE" then
            local bone = words[2]
            local axis = words[4]
            local goal = tonumber(string.sub(words[5],2,-2))
            local speed = tonumber(string.sub(words[7],2,-2))
            local slider = sliders[bone]
            if slider then
                if axis == 'x-axis' then
                    slider:SetGoal(goal, 0, 0)
                elseif axis == 'y-axis' then
                    slider:SetGoal(0, goal, 0)
                elseif axis == 'z-axis' then
                    slider:SetGoal(0, 0, goal)
                end
                slider:SetSpeed(speed)
            else
                LOG('invalid slider for command: MOVE '..bone..' '..axis..' '..goal..' '..speed)
            end
        end
    end
end