require('game_flow.src.views.popups.game_over.ViewPopupGameOver')

ControllerPopupGameOver = classWithSuper(ControllerPopup, 'ControllerPopupGameOver')

--
-- Properties
-- 

function ControllerPopupGameOver.getType(self)
    return EPopupType.EPT_GAME_OVER
end

--
-- Events
--

function ControllerPopupGameOver.onButtonCloseClicked(self)
    GameInfo:instance():onGameEnd()
    
    GameInfo:instance():managerStates():setState(EStateType.EST_MAP)
end

--
-- Methods
--

function ControllerPopupGameOver.init(self)
    
    local paramsView =
    {
        controller = self
    }
    
    local paramsController =
    {
        view = ViewPopupGameOver:new(paramsView)
    }
    
    ControllerPopup.init(self, paramsController)
    
end

function ControllerPopupGameOver.cleanup(self)
    self._view:cleanup()
    self._view = nil
    
    ControllerPopup.cleanup(self)
end




