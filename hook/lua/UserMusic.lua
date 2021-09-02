--#****************************************************************************
--# UserMusic
--# Copyright © 2006 Gas Powered Games, Inc.  All rights reserved.
--#
--#****************************************************************************

--#****************************************************************************
--# Config options

local TABattleCues = {
    Sound({Cue = 'Battle', Bank = 'TA_Music'}),
}
local TAPeaceCues = {
    Sound({Cue = 'Building', Bank = 'TA_Music'}),
}
local coinFlip = math.random(2)

function StartBattleMusic()
    BattleStart = GameTick()
    --LOG('Battle...')
    --LOG(coinFlip)
    ----This Chooses what Music you get when playing. Its half supreme commander and half TA
    if coinFlip == 1 then
    PlayMusic(BattleCues[BattleCueIndex], 0) -- immediately
    BattleCueIndex = math.mod(BattleCueIndex,table.getn(BattleCues)) + 1
    else
    PlayMusic(TABattleCues[BattleCueIndex], 0)
    BattleCueIndex = math.mod(BattleCueIndex,table.getn(TABattleCues)) + 1
    end
    if battleWatch then KillThread(battleWatch) end
    battleWatch = ForkThread(
        function ()
            while GameTick() - LastBattleNotify < PeaceTimer do
                --WaitSeconds(1)
                coroutine.yield(11)
            end

            StartPeaceMusic()
        end
)
end

function StartPeaceMusic()
    BattleStart = 0
    BattleEventCounter = 0
    LastBattleNotify = GameTick()
    --LOG('Peace...') 
    --LOG(coinFlip)
    if coinFlip == 1 then
    PlayMusic(TAPeaceCues[PeaceCueIndex], 3)
    PeaceCueIndex = math.mod(PeaceCueIndex, table.getsize(TAPeaceCues)) + 1
    else 
    PlayMusic(PeaceCues[PeaceCueIndex], 3)
    PeaceCueIndex = math.mod(PeaceCueIndex, table.getsize(PeaceCues)) + 1
    end
end