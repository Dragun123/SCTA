#ARM Metal Storage - Increases Metal Storage
#ARMMSTOR
#
#Script created by Raevn

local TAStructure = import('/mods/SCTA-master/lua/TAStructure.lua').TAStructure

ARMMSTOR = Class(TAStructure) {
    OnLayerChange = function(self, new, old)
        TAStructure.OnLayerChange(self, new, old)
        if new ~= 'Land' then
            CreateAnimator(self):PlayAnim(self:GetBlueprint().Display.AnimationWater, false):SetRate(1)
            --CreateAnimator(self):PlayAnim('/mods/SCTA-master/units/ARMMSTOR/ARMMSTOR2/ARMMSTOR2_WaterTransform.sca', false):SetRate(1)
        end
    end,

    OnStopBeingBuilt = function(self,builder,layer)
        TAStructure.OnStopBeingBuilt(self,builder,layer)
        for i = 1, 2 do
            self.Trash:Add(CreateStorageManip(self, 'Store_00'..i, 'MASS', 0, 0, 0, 0, (layer == 'Land' and 9.5 or 15) * __blueprints.armmstor.Display.UniformScale, 0))
        end
        for i = 1, 4 do
                                      --(unit, bone, axis, [goal], [speed], [accel], [goalspeed])
            self.Trash:Add(CreateRotator(self, 'Fan_00'..i, 'z', nil, 0, 20, 500))
        end
    end,
}

TypeClass = ARMMSTOR
