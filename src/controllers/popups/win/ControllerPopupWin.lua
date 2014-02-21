require('game_flow.src.views.popups.win.ViewPopupWin')

ControllerPopupWin = classWithSuper(ControllerPopup, 'ControllerPopupWin')

--
-- Properties
--

function ControllerPopupWin.getType(self)
    return EPopupType.EPT_WIN
end

--
-- Events
--

function ControllerPopupWin.onButtonCloseClicked(self)
    GameInfo:instance():onGameEnd()
    
    GameInfo:instance():managerStates():setState(EStateType.EST_MAP)
end

--
-- Methods
--


function ControllerPopupWin.init(self)
    
    local paramsView =
    {
        controller = self
    }
    
    local paramsController =
    {
        view = ViewPopupWin:new(paramsView)
    }
    
    ControllerPopup.init(self, paramsController)
    
    
    self._view:setRewardCurrency(100)
    
    local managerGame = GameInfo:instance():managerGame()
    
    assert(managerGame ~= nil)
    
    self._view:setRewardCurrency(managerGame:currentLevel():rewardCurrencySoft())
    
end

function ControllerPopupWin.cleanup(self)
    self._view:cleanup(self)
    self._view = nil
    
    ControllerPopup.cleanup(self)
end

