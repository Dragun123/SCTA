do

local TAupgrades =
{
    -- TAs
    ['armlab'] = 'armdlab',
    ['armdlab'] = 'armadlab',
    ['corlab'] = 'cordlab', 
    ['cordlab'] = 'coradlab',
    ['armap'] = 'armdap',
    ['corap'] = 'cordap',
    ['armsy'] = 'armdsy',
    ['armdsy'] = 'armadsy',
    ['corsy'] = 'cordsy',  
    ['cordsy'] = 'coradsy',
    ['armvp'] = 'armdvp',
    ['armdvp'] = 'armadvp',
    ['corvp'] = 'cordvp',
    ['cordvp'] = 'coradvp',
    ['armmex'] = 'armmass', 
    ['cormex'] = 'cormass',
    ['armrad'] = 'armarad',
    ['corrad'] = 'corarad',
    ['armarad'] = 'armtarg',
    ['corarad'] = 'cortarg',
    ['armsonar'] = 'armason',
    ['corsonar'] = 'corason',
}

upgradeTab = table.merged(upgradeTab, TAupgrades)

end
