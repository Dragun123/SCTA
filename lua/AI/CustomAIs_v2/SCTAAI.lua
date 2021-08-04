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
			name = '<LOC SctaAI_0001>AI: SCTA Arm',
		},
		{
			key = 'sctaaicore',
			name = '<LOC SctaAI_0002>AI: SCTA Core',
		},
		{
			key = 'sctaairandom',
			name = '<LOC SctaAI_0003>AI: SCTA Random',
		},
	},
	CheatAIList = {
		{
			key = 'sctaaiarmcheat',
			name = '<LOC SctaAI_0004>AIx: SCTA Arm',
		},
		{
			key = 'sctaaicorecheat',
			name = '<LOC SctaAI_0005>AIx: SCTA Core',
		},
		{
			key = 'sctaairandomcheat',
			name = '<LOC SctaAI_0006>AIx: SCTA Random',
		},
	},
}