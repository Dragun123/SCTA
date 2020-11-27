local OldTAFactory = TAFactory
 
TAFactory = Class(OldTAFactory) {
    OnCreate = function(self)
        OldTAFactory.OnCreate(self)
        self.TAEngiMod(self)
    end,
    
    TAEngiMod = function(self)
        local faction = {'ARM','CORE'},
        local type = { 'PLATFORM', 'LAB', 'GANTRY', },
        LOG(faction)
        --This fills the catFlags with categories from the categoriesCheckTable if it finds them.
        for key, CatsList in categoriesCheckTable do
            for _, category in CatsList do
                if EntityCategoryContains(categories[category], self) then
                    catFlags[key] = categories[category]
                    break
                end
            end
        end

        local aiBrain = self:GetAIBrain()
        --Add build restrictions
        if EntityCategoryContains(categories.FACTORY * categories.PLANT, self) then
        if self.FindPlantType(aiBrain, categories.LAB) then   
        end
    end
    end,

    --self.FindPlantType(aiBrain, category)
    FindPlantType = function(aiBrain, category)
        for id, unit in aiBrain:GetListOfUnits(category, false, true) do
            if not unit.Dead and not unit:IsBeingBuilt() then
                return true
            end
        end
        return false
    end,
}