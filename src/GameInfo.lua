require('sdk.GameInfoBase')

require('game_flow.src.Constants')
require('game_flow.src.controllers.EControllerUpdate')
require('game_flow.src.views.EFontType')
require('game_flow.src.states.EStateType')
require('game_flow.src.models.levels.LevelInfo')


require("game_flow.src.models.resources.ManagerResources")
require("game_flow.src.models.particles.ManagerParticles")
require("game_flow.src.models.sounds.ManagerSounds")
require('game_flow.src.models.string.ManagerString')
require('game_flow.src.models.players.PlayerInfo')
require('game_flow.src.models.game.ManagerGame')
require('game_flow.src.models.editor.ManagerEditor')
require('game_flow.src.models.cache.ManagerCacheFlow')
require('game_flow.src.models.remote.ManagerRemoteFlow')
require('game_flow.src.models.remote.RemoteConnectorFlow')

require('game_flow.src.views.popups.base.ViewPopupFlowBase')

require('game_flow.src.controllers.popups.EPopupType')
require('game_flow.src.models.purchases.EPurchaseType')
require('game_flow.src.models.bonus.EBonusType')


require('game_flow.src.controllers.popups.shop.ControllerPopupShop')
require('game_flow.src.controllers.popups.win.ControllerPopupWin')
require('game_flow.src.controllers.popups.game_over.ControllerPopupGameOver')
require('game_flow.src.controllers.popups.no_energy.ControllerPopupNoEnergy')
require('game_flow.src.controllers.popups.no_currency.ControllerPopupNoCurrency')
require('game_flow.src.controllers.popups.bonus.ControllerPopupBonus')


GameInfo = classWithSuper(GameInfoBase, 'GameInfo')

--
-- Events
--

function GameInfo.onGameStartComplete(self, response)
    if(response:status() == EResponseType.ERT_OK)then
        local data = response:response()
        
        assert(data.players         ~= nil)
        assert(data.purchases       ~= nil)
        assert(data.bonus           ~= nil)
        assert(data.bonus_energy    ~= nil)
        assert(data.levels          ~= nil)
        
        self._managerLevels:deserialize(data.levels)
        
        --todo: implement server side deserialization in manager proxy
        self._managerString:setCurrentLanguage(ELanguageType.ELT_ENGLISH)
        self._managerBonusEnergy:deserialize(data.bonus_energy)
        self._managerPlayers:deserialize(data.players)
        self._managerPurchases:deserialize(data.purchases)
        self._managerBonus:deserialize(data.bonus)
        
        local paramsGame = 
        {
            currentLevel = self._managerLevels:firstIncompleteLevel()
        }
        
--                self:onGameStart(ManagerEditor:new(paramsGame))
        --        self._managerStates:setState(EStateType.EST_EDITOR)
        --        
        
--        self:onGameStart(ManagerGame:new(paramsGame))
--        self._managerStates:setState(EStateType.EST_GAME)
        
        self._managerStates:setState(EStateType.EST_MAP)
    end
end

--
-- Methods
--
function GameInfo.init(self)
    
    application.dir_assets  = 'game_flow/assets/'
    application.dir_data    = 'game_flow/data/'
    application.server_url  = 'app1.greemlins.com'
    
    GameInfoBase.init(self)
end

function GameInfo.initManagers(self)
    
    self._managerCache          = ManagerCacheFlow:new()
    
    local paramsConnector =
    {
        protocol = EProtocolType.EPT_HTTP
    }
    
    local paramsRemote = 
    {
        manager_cache       = self._managerCache,
        remote_connector    = RemoteConnectorFlow:new(paramsConnector) 
    }
    
    self._managerRemote         = ManagerRemoteFlow:new(paramsRemote)
    
    self._managerResources      = ManagerResources:new()
    self._managerFonts          = ManagerFontsBase:new()
    self._managerParticles      = ManagerParticles:new()
    self._managerStates         = ManagerStatesBase:new()
    self._managerString         = ManagerString:new()
    self._managerSounds         = ManagerSounds:new()
    self._managerPurchases      = ManagerPurchasesBase:new()
    self._managerBonus          = ManagerBonusBase:new(BonusInfoBase)
    self._managerBonusEnergy    = ManagerBonusEnergyBase:new(BonusInfoBase)
    self._managerPlayers        = ManagerPlayersBase:new(PlayerInfo)
    self._managerLevels         = ManagerLevelsBase:new(LevelInfo) 
    
    local paramsAd = 
    {
    }
    
    self._managerAd             = ManagerAdBase:new(paramsAd)
    
    GameInfoBase.initManagers(self)
end

function GameInfo.registerStates(self)
    
    self._managerStates:registerState(EStateType.EST_GAME,     "game_flow.src.states.game.StateGameCreator")
    self._managerStates:registerState(EStateType.EST_MAP,      "game_flow.src.states.map.StateMapCreator")
    self._managerStates:registerState(EStateType.EST_EDITOR,   "game_flow.src.states.editor.StateEditorCreator")
    
    GameInfoBase.registerStates(self)
end

function GameInfo.loadFonts(self)
    
    local fontsDir = application.dir_assets..'fonts/'
    
    local font0Pattern = string.format("%sfont_%i%s", fontsDir, EFontType.EFT_0, application.scaleSuffix)
    self._managerFonts:loadFont(EFontType.EFT_0, font0Pattern..'.fnt', font0Pattern..'.png', 20)
    
    local font1Pattern = string.format("%sfont_%i%s", fontsDir, EFontType.EFT_1, application.scaleSuffix)
    self._managerFonts:loadFont(EFontType.EFT_1, font1Pattern..'.fnt', font1Pattern..'.png', 22)
    
    local font2Pattern = string.format("%sfont_%i%s", fontsDir, EFontType.EFT_2, application.scaleSuffix)
    self._managerFonts:loadFont(EFontType.EFT_2, font2Pattern..'.fnt', font2Pattern..'.png', 22)
    
    GameInfoBase.loadFonts(self)
end




