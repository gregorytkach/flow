require('game_flow.src.models.sounds.ESoundType')


ManagerSounds = classWithSuper(ManagerSoundsBase, 'ManagerSounds')

--
-- Properties
--

function ManagerSounds.needManageMemory(self)
    return false
end

--
--Events
--

--
--Methods
--

function ManagerSounds.init(self)
    ManagerSoundsBase.init(self)
    
    --sync sounds and music states
    application.sounds = application.music
end

function ManagerSounds.getMusicForState(self, stateType)
    local result = nil
    
    if(stateType == EStateType.EST_MAP)then
        
        result = application.dir_assets..'sounds/music_map.mp3'
        
    elseif(stateType == EStateType.EST_GAME)then
        
        result = application.dir_assets..'sounds/music_game.mp3'
        
    elseif(stateType == EStateType.EST_EDITOR)then
        --do nothing
    else
        assert(false)
    end
    
    return result
end

function ManagerSounds.loadSounds(self, stateType)
    
    self:loadSoundsBase()
    
    if(stateType == EStateType.EST_GAME)then
        
        self:loadSoundsGame()
        
    elseif(stateType == EStateType.EST_MAP)then
        
        self:loadSoundsMap()
        
    elseif(stateType == EStateType.EST_EDITOR)then
        --do nothing
    else
        assert(false)
    end
end

function ManagerSounds.loadSoundsBase(self)
    self._audioHandlers[ESoundTypeBase.ESTB_BUTTON_DOWN]    = audio.loadStream(application.dir_assets..'sounds/button_down.mp3')
    self._audioHandlers[ESoundTypeBase.ESTB_BUTTON_UP]      = audio.loadStream(application.dir_assets..'sounds/button_up.mp3')
    
    self._audioHandlers[ESoundType.EST_BUTTON_BUY]          = audio.loadStream(application.dir_assets..'sounds/button_buy.mp3')
    
    self._audioHandlers[ESoundType.EST_POPUP_SHOW]      = audio.loadStream(application.dir_assets..'sounds/popup_show.mp3')
end

function ManagerSounds.loadSoundsMap(self)
    
    --    ["EST_BUTTON_SPIN"]         = "EST_BUTTON_SPIN";
    
end

function ManagerSounds.loadSoundsGame(self)
    
    self._audioHandlers[ESoundType.EST_BUTTON_PURCHASE]     = audio.loadStream(application.dir_assets..'sounds/button_purchase.mp3')
    
    self._audioHandlers[ESoundType.EST_GAME_LOSE]          = audio.loadStream(application.dir_assets..'sounds/game_lose.mp3')
    self._audioHandlers[ESoundType.EST_GAME_WIN]           = audio.loadStream(application.dir_assets..'sounds/game_win.mp3')
    
end

function ManagerSounds.getSound(self, soundType)
    local result
    
    result = ManagerSoundsBase.getSound(self, soundType)
    
    return result
end
