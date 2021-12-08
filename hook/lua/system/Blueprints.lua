do
    local TAExtractBuildMeshBlueprint = ExtractBuildMeshBlueprint

    function ExtractBuildMeshBlueprint(bp)
        local FactionName = bp.General.FactionName
        if FactionName == 'ARM' or FactionName == 'CORE' then
            local meshid = bp.Display.MeshBlueprint
            if not meshid then return end

            local meshbp = original_blueprints.Mesh[meshid]
            if not meshbp then return end

            local shadername = 'TABuild'

            local buildmeshbp = table.deepcopy(meshbp)
            if buildmeshbp.LODs then
                for i,lod in buildmeshbp.LODs do
                    lod.ShaderName = shadername
                end
            end
            buildmeshbp.BlueprintId = meshid .. '_build'
            bp.Display.BuildMeshBlueprint = buildmeshbp.BlueprintId
            MeshBlueprint(buildmeshbp)
        else
            TAExtractBuildMeshBlueprint(bp)
        end
    end

    local TAExtractCloakMeshBlueprint = ExtractCloakMeshBlueprint

    function ExtractCloakMeshBlueprint(bp)
        local FactionName = bp.General.FactionName
        if FactionName == 'ARM' or FactionName == 'CORE' then
            local meshid = bp.Display.MeshBlueprint
            if not meshid then return end

            local meshbp = original_blueprints.Mesh[meshid]
            if not meshbp then return end

            local cloakmeshbp = table.deepcopy(meshbp)
            if cloakmeshbp.LODs then
                for i, lod in cloakmeshbp.LODs do
                    lod.ShaderName = 'TACloak'
                end
            end
            cloakmeshbp.BlueprintId = meshid .. '_cloak'
            bp.Display.CloakMeshBlueprint = cloakmeshbp.BlueprintId
            MeshBlueprint(cloakmeshbp)
        else
            TAExtractCloakMeshBlueprint(bp)
        end
    end

    local TAExtractWreckageBlueprint = ExtractWreckageBlueprint

    function ExtractWreckageBlueprint(bp)
        local FactionName = bp.General.FactionName
        if FactionName == 'ARM' or FactionName == 'CORE' then
            local meshid = bp.Display.MeshBlueprint
            if not meshid then return end

            local meshbp = original_blueprints.Mesh[meshid]
            if not meshbp then return end

            local wreckbp = table.deepcopy(meshbp)
            if wreckbp.LODs then
                for i,lod in wreckbp.LODs do
                    if lod.ShaderName == 'TMeshAlpha' or lod.ShaderName == 'NormalMappedAlpha' or lod.ShaderName == 'UndulatingNormalMappedAlpha' then
                        lod.ShaderName = 'BlackenedNormalMappedAlpha'
                    else
                        lod.ShaderName = 'Wreckage'
                        lod.SpecularName = '/env/common/props/wreckage_noise.dds'
                        lod.NormalName = '/mods/SCTA-master/meshes/rockteeth/rockteeth_NormalsTS.dds'
                        lod.AlbedoName = '/mods/SCTA-master/meshes/rockteeth/rockteeth_Albedo.dds'
                    end
                end
            end
            wreckbp.BlueprintId = meshid .. '_wreck'
            bp.Display.MeshBlueprintWrecked = wreckbp.BlueprintId
            MeshBlueprint(wreckbp)
        else
            TAExtractWreckageBlueprint(bp)
        end
    end


    local SCTAModBlueprints = ModBlueprints

    function ModBlueprints(all_blueprints)
        SCTAModBlueprints(all_blueprints)
        TAGiveVet(all_blueprints.Unit)
    end

    function TAGiveVet(all_bps)
        for id, bp in all_bps do
            local FactionName = bp.General.FactionName
            if (FactionName == 'ARM' or FactionName == 'CORE') and bp.Weapon and bp.CategoriesHash then
                local mul = bp.CategoriesHash.TECH1 and 1
                or bp.CategoriesHash.TECH2 and 2
                or bp.CategoriesHash.TECH3 and 3
                or bp.CategoriesHash.EXPERIMENTAL and 5
                or 10

                -- Replacing these with elseif means that if Buffs isn't defined the unit never gets given a Regen table. It's not a "double check" it's a sequential check.
                if not bp.Buffs then bp.Buffs = {} end
                if not bp.Buffs.Regen then
                    bp.Buffs.Regen = {
                        Level1 = 1 * mul,
                        Level2 = 2 * mul,
                        Level3 = 3 * mul,
                        Level4 = 4 * mul,
                        Level5 = 5 * mul,
                    }
                end
                if not bp.Veteran then
                    bp.Veteran =  {
                        Level1 = 3 * mul,
                        Level2 = 6 * mul,
                        Level3 = 9 * mul,
                        Level4 = 12 * mul,
                        Level5 = 15 * mul,
                    }
                end
            end
        end
    end
end
