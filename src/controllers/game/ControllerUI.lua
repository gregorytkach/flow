require('game_flow.src.views.game.ViewUI')
require('game_flow.src.controllers.game.ControllerPurchases')

ControllerUI = classWithSuper(Controller, 'ControllerUI')

--
--Events
--

function ControllerUI.onViewClicked(self, target, event)
    
    if (self._view:buttonHome() == target) then
        
        GameInfo:instance():onGameEnd()
        
                GameInfo:instance():managerStates():setState(EStateTypeBase.EST_EMPTY)

--        GameInfo:instance():managerStates():setState(EStateType.EST_MAP)
        
    elseif (self._view:buttonHelp() == target) then 
        
    elseif (self._view:buttonShop() == target) then
        GameInfo:instance():managerStates():currentState():showPopup(EPopupType.EPT_SHOP)
    else
        
        assert(false)
        
    end
    
end


--
--Methods
--

function ControllerUI.init(self)
    
    local paramsView =
    {
        controller = self
    }
    
    local paramsController =
    {
        view = ViewUI:new(paramsView)
    }
    
    Controller.init(self, paramsController)
    
    self._managerGame    = GameInfo:instance():managerGame()
    
    self._managerPlayers = GameInfo:instance():managerPlayers()
    
    self._view:labelCurrencySoft():sourceView():setText(self._managerPlayers:playerCurrent():currencySoft()) 
    
    
    self._controllerPurchases = ControllerPurchases:new()
    
    self._view:setViewPurchases(self._controllerPurchases:view())
end

function ControllerUI.update(self, updateType)
    
    if (updateType == EControllerUpdate.ECUT_GAME_TIME) then
        
        self._view:setTime(self._managerGame:timeLeft())
        
    elseif(updateType == EControllerUpdate.ECUT_GAME_SCORES) then
        
        self._view:setScores(self._managerGame:getScores())
        
    elseif(updateType == EControllerUpdateBase.ECUT_PLAYER_CURERNCY)then
        
        self._view:labelCurrencySoft():setValue(self._managerPlayers:playerCurrent():currencySoft())
        
    elseif(updateType == EControllerUpdate.ECUT_FREE_PURCHASE_ADD_TIME or
        updateType == EControllerUpdate.ECUT_FREE_PURCHASE_RESOLVE or
        updateType == EControllerUpdate.ECUT_FREE_PURCHASE_SHOW_TURN)then
        
        self._controllerPurchases:update(updateType)
        
    else
        assert(false, updateType)
    end
    
end

function ControllerUI.cleanup(self)
    
    self._controllerPurchases:cleanup()
    self._controllerPurchases = nil
    
    self._view:cleanup()
    self._view = nil
    
    Controller.cleanup(self)
end

