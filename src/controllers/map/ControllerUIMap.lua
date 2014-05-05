require('game_flow.src.views.map.ViewUIMap')

ControllerUIMap = classWithSuper(Controller, 'ControllerUIMap')

--
--Events
--

function ControllerUIMap.onViewClicked(self, target, event)
    
    if (target == self._view:buttonSoundDisabled()) then
        
        application.sounds  = true
        application.music   = true
        
        --try play music
        GameInfo:instance():managerSounds():playMusic()
        
        self:updateButtonSound()
        
    elseif(target == self._view:buttonSound())then
        
        application.sounds  = false
        application.music   = false
        
        --try stop music
        GameInfo:instance():managerSounds():stopMusic()
        
        self:updateButtonSound()
        
    elseif(target == self._view:buttonBonus())then
        
        self._currentState:showPopup(EPopupType.EPT_BONUS)
        
    elseif(target == self._view:buttonHelp())then
        
        local popupTutorial = self._currentState:getPopup(EPopupType.EPT_TUTORIAL)
        
        popupTutorial:prepare()
        
        self._currentState:showPopup(EPopupType.EPT_TUTORIAL)
        
    elseif(target == self._view:buttonBuyCurrency())then
        local popupShop = self._currentState:getPopup(EPopupType.EPT_SHOP)
        popupShop:showEnergy()
        
        self._currentState:showPopup(EPopupType.EPT_SHOP)
        
    elseif(target == self._view:buttonBuyEnergy())then
        
        local popupShop = self._currentState:getPopup(EPopupType.EPT_SHOP)
        popupShop:showCurrency()
        
        self._currentState:showPopup(EPopupType.EPT_SHOP)
        
    elseif(target == self._view:buttonFreeCurrency())then
        
        GameInfo:instance():managerAdVungle():showAd(
        function()
            local player = GameInfo:instance():managerPlayers():playerCurrent()
            
            player:setCurrencySoft(player:currencySoft() + Constants.REWARD_VUNGLE_CURRENCY_SOFT)
            
        end)
        
    else
        
        assert(false)
        
    end
    
end


--
--Methods
--

function ControllerUIMap.init(self)
    
    local paramsView =
    {
        controller = self
    }
    
    local paramsController =
    {
        view = ViewUIMap:new(paramsView)
    }
    
    Controller.init(self, paramsController)
    
    self._currentState          = GameInfo:instance():managerStates():currentState()
    
    self._managerPlayers        = GameInfo:instance():managerPlayers()
    self._managerBonus          = GameInfo:instance():managerBonus()
    self._managerBonusEnergy    = GameInfo:instance():managerBonusEnergy()
    
    self:update(EControllerUpdateBase.ECUT_PLAYER_CURERNCY)
    self:update(EControllerUpdateBase.ECUT_PLAYER_ENERGY)
    
    self._timerUpdate = timer.performWithDelay(application.animation_duration, 
    function () 
        self:update(EControllerUpdateBase.ECUT_BONUS_TIME)
        self:update(EControllerUpdate.ECUT_BONUS_ENERGY_TIME)
    end, -1)
    
    self:updateTimerEnergy()
    
    self:updateButtonSound()
end

function ControllerUIMap.update(self, updateType)
    
    if(updateType == EControllerUpdate.ECUT_GAME_SCORES) then
        
        self._view:setScores(self._managerGame:getScores())
        
        
    elseif(updateType == EControllerUpdateBase.ECUT_PLAYER_CURERNCY)then
        
        self._view:setCurrency(self._managerPlayers:playerCurrent():currencySoft())
        
    elseif(updateType == EControllerUpdateBase.ECUT_PLAYER_ENERGY)then
        
        self._view:setEnergy(self._managerPlayers:playerCurrent():energy()) 
        
        if(self._managerPlayers:playerCurrent():energy() == Constants.ENERGY_LIMIT)then
            
        end
        
    elseif(updateType == EControllerUpdateBase.ECUT_BONUS_TIME)then
        
        self._view:setTimeBonus(self._managerBonus:timeLeft())
        
    elseif(updateType == EControllerUpdate.ECUT_BONUS_ENERGY_TIME)then
        
        self:updateTimerEnergy()
        
    else
        assert(false)
    end
    
end

function ControllerUIMap.updateTimerEnergy(self)
    self._view:setTimeEnergy(self._managerBonusEnergy:timeLeft())
end

function ControllerUIMap.updateButtonSound(self)
    
    self._view:buttonSoundDisabled():sourceView().isVisible  = not application.sounds
    self._view:buttonSound():sourceView().isVisible          = application.sounds
    
end

function ControllerUIMap.cleanup(self)
    
    timer.cancel(self._timerUpdate)
    self._timerUpdate = nil
    
    self._view:cleanup()
    self._view = nil
    
    Controller.cleanup(self)
end

