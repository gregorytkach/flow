require('game_flow.src.models.sounds.ESoundType')


ManagerSounds = classWithSuper(ManagerSoundsBase, 'ManagerSounds')

--
--Events
--
function ManagerSounds.onStateChanged(self, stateType)
    if(self._prevStateType == stateType)then
        return
    end
    
    if(stateType == EStateType.EST_GAME or 
        self._prevStateType == nil or 
        self._prevStateType == EStateType.EST_GAME)then
        
        self:stopMusic()
        
        self:unloadSounds()
        self._prevStateType = stateType
        
        if(application.music)then
            self:playMusic(stateType)
        end
        
        self:_loadSounds(stateType)
        
    end
    
end
--
--Methods
--

function ManagerSounds.init(self)
    ManagerSoundsBase.init(self)
end

function ManagerSounds._loadSounds(self, stateType)
    --todo:implement
    
    --    if(stateType == EStateType.EST_GAME)then
    --        self:_loadSounds(EStateType.EST_MAIN)
    
    --    else
    --        self:_loadSoundsButtons()
    --    end
end

function ManagerSounds._loadSoundsGame(self)
    self:_loadSoundsLobby()
    
    --bonuses
    for i = 0, 4, 1 do
        local soundName = string.format("assets/sounds/bonuses/bonus%i.mp3", i)
        
        self._audioHandlers[ESoundType["EST_BONUS"]..i] = audio.loadStream(soundName)
    end
    
end

function ManagerSounds.getSound(self, soundType)
    local result
    
    if(soundType == ESoundType.EST_BONUS)then
        
        result = self._audioHandlers[ESoundType.EST_BONUS..math.random(0, 4)]
        
    else
        
        result = ManagerSoundsLego.getSound(self, soundType)
        
    end
    
    return result
end
