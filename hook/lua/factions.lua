do

    TAFactions = {
    {
        Key = 'arm',
        Category = 'ARM',
        DisplayName = "ARM",
        SoundPrefix = 'UEF',
        FactionInUnitBp = 'ARM',
        InitialUnit = 'armcom',
        CampaignFileDesignator = 'M',
        TransmissionLogColor = 'ff0000ff',
        Icon = "/mods/SCTA-master/textures/ui/common/widgets/faction-icons-alpha_bmp/arm_ico.dds",
        VeteranIcon = "/mods/SCTA-master/textures/ui/common/game/veteran-logo_bmp/arm-veteran_bmp.dds",
        SmallIcon = "/mods/SCTA-master/textures/ui/common/faction_icon-sm/arm_ico.dds",
        LargeIcon = "/mods/SCTA-master/textures/ui/common/faction_icon-lg/arm_ico.dds",
        TooltipID = 'lob_arm',
        DefaultSkin = 'uef',
        loadingMovie = '/movies/UEF_load.sfd',
        loadingColor = 'FFbadbdb',
        loadingTexture = '/UEF_load.dds',
        IdleEngTextures = {
            T1 = '/mods/SCTA-master/textures/ui/common/icons/units/armck_icon.dds',
            T2 = '/mods/SCTA-master/textures/ui/common/icons/units/armack_icon.dds',
            T2F = '/mods/SCTA-master/textures/ui/common/icons/units/armfark_icon.dds',
            T3 = '/mods/SCTA-master/textures/ui/common/icons/units/armch_icon.dds',
            SCU = '/mods/SCTA-master/textures/ui/common/icons/units/armdecom_icon.dds',
        },
        IdleFactoryTextures = {
            LAND = {
                '/mods/SCTA-master/textures/ui/common/icons/units/armlab_icon.dds',
                '/mods/SCTA-master/textures/ui/common/icons/units/armalab_icon.dds',
                '/mods/SCTA-master/textures/ui/common/icons/units/armgant_icon.dds',
            },
            AIR = {
                '/mods/SCTA-master/textures/ui/common/icons/units/armap_icon.dds',
                '/mods/SCTA-master/textures/ui/common/icons/units/armaap_icon.dds',
                '/mods/SCTA-master/textures/ui/common/icons/units/armplat_icon.dds',
            },
            NAVAL = {
                '/mods/SCTA-master/textures/ui/common/icons/units/armsy_icon.dds',
                '/mods/SCTA-master/textures/ui/common/icons/units/armasy_icon.dds',
                '/mods/SCTA-master/textures/ui/common/icons/units/armhp_icon.dds',
            },
        },
    },
    {
        Key = 'core',
        Category = 'CORE',
        DisplayName = "CORE",
        SoundPrefix = 'Cybran',
        FactionInUnitBp = 'CORE',
        InitialUnit = 'corcom',
        CampaignFileDesignator = 'O',
        TransmissionLogColor = 'ffff0000',
        Icon = "/mods/SCTA-master/textures/ui/common/widgets/faction-icons-alpha_bmp/core_ico.dds",
        VeteranIcon = "/mods/SCTA-master/textures/ui/common/game/veteran-logo_bmp/core-veteran_bmp.dds",
        SmallIcon = "/mods/SCTA-master/textures/ui/common/faction_icon-sm/core_ico.dds",
        LargeIcon = "/mods/SCTA-master/textures/ui/common/faction_icon-lg/core_ico.dds",
        TooltipID = 'lob_core',
        DefaultSkin = 'cybran',
        loadingMovie = '/movies/cybran_load.sfd',
        loadingColor = 'FFe24f2d',
        loadingTexture = '/cybran_load.dds',
        IdleEngTextures = {
            T1 = '/mods/SCTA-master/textures/ui/common/icons/units/corcv_icon.dds',
            T2 = '/mods/SCTA-master/textures/ui/common/icons/units/coracv_icon.dds',
            T2F = '/mods/SCTA-master/textures/ui/common/icons/units/cornecro_icon.dds',
            T3 = '/mods/SCTA-master/textures/ui/common/icons/units/corch_icon.dds',
            SCU = '/mods/SCTA-master/textures/ui/common/icons/units/cordecom_icon.dds',
        },
        IdleFactoryTextures = {
            LAND = {
                '/mods/SCTA-master/textures/ui/common/icons/units/corvp_icon.dds',
                '/mods/SCTA-master/textures/ui/common/icons/units/coravp_icon.dds',
                '/mods/SCTA-master/textures/ui/common/icons/units/corgant_icon.dds',
            },
            AIR = {
                '/mods/SCTA-master/textures/ui/common/icons/units/corap_icon.dds',
                '/mods/SCTA-master/textures/ui/common/icons/units/coraap_icon.dds',
                '/mods/SCTA-master/textures/ui/common/icons/units/corplat_icon.dds',
            },
            NAVAL = {
                '/mods/SCTA-master/textures/ui/common/icons/units/corsy_icon.dds',
                '/mods/SCTA-master/textures/ui/common/icons/units/corasy_icon.dds',
                '/mods/SCTA-master/textures/ui/common/icons/units/corhp_icon.dds',
            },
        },
    },
}

Factions = table.cat(Factions, TAFactions)

end

FactionIndexMap = {}

-- file designator to faction key
FactionDesToKey = {}

for index, value in Factions do
    FactionIndexMap[value.Key] = index
    FactionDesToKey[value.CampaignFileDesignator] = value.Key
end
