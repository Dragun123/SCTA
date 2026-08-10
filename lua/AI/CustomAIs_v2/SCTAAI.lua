--[[
    File    :   /lua/AI/CustomAIs_v2/SCTAAI.lua
    Author  :   SoftNoob
    Summary :
        Lists AIs to be included into the lobby, see /lua/AI/CustomAIs_v2/SorianAI.lua for another example.
        Loaded in by /lua/ui/lobby/aitypes.lua, this loads all lua files in /lua/AI/CustomAIs_v2/
]]

AI = {
	Name = 'SCTAAI',
	Version = '1',
	AIList = {
		{
			key = 'sctaaiarm',
			name = '<LOC SctaAI_0001>AI: SCTA ARM',
		},
		{
			key = 'sctaaicore',
			name = '<LOC SctaAI_0002>AI: SCTA CORE',
		},
		{
			key = 'sctaairandom',
			name = '<LOC SctaAI_0003>AI: SCTA Random',
		},
	{
            key = 'm28taarmai',
            name = '<LOC SctaAI_0004>AI: M28 SCTA ARM',
        },
        {
            key = 'm28tacoreai',
            name = '<LOC SctaAI_0005>AI: M28 SCTA CORE',
        },
        {
            key = 'm28tarandomai',
            name = '<LOC SctaAI_0006>AI: M28 SCTA Random',
        },
	},
	CheatAIList = {
		{
			key = 'sctaaiarmcheat',
			name = '<LOC SctaAI_0007>AIx: SCTA ARM',
		},
		{
			key = 'sctaaicorecheat',
			name = '<LOC SctaAI_0008>AIx: SCTA CORE',
		},
		{
			key = 'sctaairandomcheat',
			name = '<LOC SctaAI_0009>AIx: SCTA Random',
		},
        {
            key = 'm28taarmaicheat',
            name = '<LOC SctaAI_0010>AIx: M28 SCTA ARM',
        },
        {
            key = 'm28tacoreaicheat',
            name = '<LOC SctaAI_0011>AIx: M28 SCTA CORE',
        },
        {
            key = 'm28tarandomaicheat',
            name = '<LOC SctaAI_0012>AIx: M28 SCTA Random',
        },
	},
}