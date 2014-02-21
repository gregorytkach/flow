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

require('game_flow.src.views.popups.base.ViewPopupFlowBase')

require('game_flow.src.controllers.popups.EPopupType')
require('game_flow.src.models.purchases.EPurchaseType')

require('game_flow.src.controllers.popups.shop.ControllerPopupShop')
require('game_flow.src.controllers.popups.win.ControllerPopupWin')
require('game_flow.src.controllers.popups.game_over.ControllerPopupGameOver')
require('game_flow.src.controllers.popups.no_energy.ControllerPopupNoEnergy')
require('game_flow.src.controllers.popups.no_currency.ControllerPopupNoCurrency')
require('game_flow.src.controllers.popups.bonus.ControllerPopupBonus')


GameInfo = classWithSuper(GameInfoBase, 'GameInfo')

--
-- Methods
--
function GameInfo.init(self)
    
    application.assets_dir = 'game_flow/assets/'
    
    self._managerResources      = ManagerResources:new()
    self._managerFonts          = ManagerFontsBase:new()
    self._managerParticles      = ManagerParticles:new()
    self._managerStates         = ManagerStatesBase:new()
    self._managerString         = ManagerString:new()
    self._managerSounds         = ManagerSounds:new()
    self._managerPurchases      = ManagerPurchasesBase:new()
    self._managerBonus          = ManagerBonusEnergyBase:new(BonusInfoBase)
    self._managerPlayers        = ManagerPlayersBase:new(PlayerInfo)
    self._managerLevels         = ManagerLevelsBase:new(LevelInfo)
    
    GameInfoBase.init(self)
end

function GameInfo.registerStates(self)
    
    self._managerStates:registerState(EStateType.EST_GAME,     "game_flow.src.states.game.StateGameCreator")
    self._managerStates:registerState(EStateType.EST_MAP,      "game_flow.src.states.map.StateMapCreator")
    self._managerStates:registerState(EStateType.EST_EDITOR,   "game_flow.src.states.editor.StateEditorCreator")
    
    GameInfoBase.registerStates(self)
end

function GameInfo.loadFonts(self)
    
    local fontsDir = application.assets_dir..'fonts/'
    
    local font0Pattern = string.format("%sfont_%i%s", fontsDir, EFontType.EFT_0, application.scaleSuffix)
    self._managerFonts:loadFont(EFontType.EFT_0, font0Pattern..'.fnt', font0Pattern..'.png', 20)
    
    local font1Pattern = string.format("%sfont_%i%s", fontsDir, EFontType.EFT_1, application.scaleSuffix)
    self._managerFonts:loadFont(EFontType.EFT_1, font1Pattern..'.fnt', font1Pattern..'.png', 22)
    
    local font2Pattern = string.format("%sfont_%i%s", fontsDir, EFontType.EFT_2, application.scaleSuffix)
    self._managerFonts:loadFont(EFontType.EFT_2, font2Pattern..'.fnt', font2Pattern..'.png', 22)
    
    GameInfoBase.loadFonts(self)
end