do

local TAupgrades =
{
    -- TAs
    ['armlab'] = {'armdlab'},
    ['armdlab'] = {'armadlab'},
    ['corlab'] = {'cordlab'}, 
    ['cordlab'] = {'coradlab'},
    ['armap'] = {'armdap'},
    ['armdap'] = {'armadap'},
    ['corap'] = {'cordap'},
    ['cordap'] = {'coradap'},
    ['armsy'] = {'armdsy'},
    ['armdsy'] = {'armadsy'},
    ['corsy'] = {'cordsy'},  
    ['cordsy'] = {'coradsy'},
    ['armvp'] = {'armdvp'},
    ['armdvp'] = {'armadvp'},
    ['corvp'] = {'cordvp'},
    ['cordvp'] = {'coradvp'},
    ['armmex'] = {'armmass'}, 
    ['cormex'] = {'cormass'},
    ['armrad'] = {'armarad'},
    ['corrad'] = {'corarad'},
    ['armarad'] = {'armxrad'},
    ['corarad'] = {'corxrad'},
    ['armsonar'] = {'armason'},
    ['corsonar'] = {'corason'},
}

upgradeTab = table.merged(upgradeTab, TAupgrades)

end
