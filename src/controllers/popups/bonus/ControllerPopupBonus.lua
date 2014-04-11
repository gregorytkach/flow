require('game_flow.src.views.popups.bonus.ViewPopupBonus')

ControllerPopupBonus = classWithSuper(ControllerPopup, 'ControllerPopupBonus')

--
-- Properties
--
function ControllerPopupBonus.getType(self)
    return EPopupType.EPT_BONUS
end

--
-- Events
--

function ControllerPopupBonus.onViewClicked(self, target, event)
    local result = ControllerPopup.onViewClicked(self, target, event)
    
    if(not result)then
        
        if(target == self._view:buttonSpin())then
            
            local bonuses       = GameInfo:instance():managerBonus():bonuses()
            math.randomseed(os.time())
            
            local bonusIndex    = math.random(1, #bonuses)
            
            self._view:setBonus(bonusIndex, 
            function()
                
                self._view:buttonSpin():hide()
                self._view:buttonBuy():show()
                
                self._view:buttonClose():setIsEnabled(true)
                
                local bonus = bonuses[bonusIndex]
                
                self._view:setReward(bonus:contentCount(), bonus:type())
                
                self:applyBonus(bonus)
                
                self._managerBonus:onBonusClaimed()
                
                self:updateTime()
            end)
            
            self._view:buttonSpin():setIsEnabled(false)
            self._view:buttonClose():setIsEnabled(false)
            
        elseif(target == self._view:buttonBuy())then
            --todo: buy free spins
            print('todo: implement purchases', ELogLevel.ELL_WARNING)
            
            self._playerCurrent:setFreeBonusSpins(self._playerCurrent:freeBonusSpins() + self._purchaseBonusSpin:contentCount())
            
        else
            assert(false)
        end
        
    end
    
    return result
end

--
-- Methods
--

function ControllerPopupBonus.init(self)
    
    local paramsView =
    {
        controller = self
    }
    
    local paramsController =
    {
        view = ViewPopupBonus:new(paramsView)
    }
    
    ControllerPopup.init(self, paramsController)
    
    self._managerBonus      = GameInfo:instance():managerBonus()
    self._playerCurrent     = GameInfo:instance():managerPlayers():playerCurrent()
    
    self:updateTime()
    
    self._timerUpdate = timer.performWithDelay(application.animation_duration * 4, 
    function () 
        self:updateTime()
    end, 
    -1)
    
    self._purchaseBonusSpin = GameInfo:instance():managerPurchases():getPurchaseFirst(EPurchaseType.EPT_BONUS_SPIN)
    
    self._view:setPurchasePrice(self._purchaseBonusSpin:priceHard())
    
    self._playerCurrent = GameInfo:instance():managerPlayers():playerCurrent()
end

function ControllerPopupBonus.update(self, updateType)
    if(updateType == EControllerUpdate.ECUT_FREE_BONUS_SPINS)then
        self:updateButtons()
    else
        assert(false)
    end
end

function ControllerPopupBonus.updateTime(self)
    
    self._view:setTime(self._managerBonus:timeLeft())
    
    self:updateButtons()
    
end

function ControllerPopupBonus.updateButtons(self)
    
    local isBonusAvailable =  self._managerBonus:isBonusAvailable() or self._playerCurrent:freeBonusSpins() > 0
    
    if(self._isBonusAvailable  == isBonusAvailable)then
        return
    end
    
    self._isBonusAvailable  = isBonusAvailable
    
    print('change bonus state')
    print(self._isBonusAvailable)
    
    if(self._isBonusAvailable)then
        self._view:buttonBuy():hide()
        self._view:buttonSpin():show()
        
        self._view:buttonSpin():setIsEnabled(true)
    else
        self._view:buttonBuy():show()
        self._view:buttonSpin():hide()
    end
    
    local labelButtonSpin = ""
    
end

function ControllerPopupBonus.applyBonus(self, value)
    assert(value ~= nil)
    
    if(value:type() == EBonusType.EBT_CURRENCY)then
        
        self._playerCurrent:setCurrencySoft(self._playerCurrent:currencySoft() + value:contentCount())
        
    elseif(value:type() == EBonusType.EBT_ENERGY)then
        
        self._playerCurrent:setEnergy(self._playerCurrent:energy() + value:contentCount())
        
    elseif(value:type() == EBonusType.EBT_PURCHASE_RESOLVE)then
        
        self._playerCurrent:setFreePurchaseResolve(self._playerCurrent:freePurchaseResolve() + 1)
        
    elseif(value:type() == EBonusType.EBT_PURCHASE_SHOW_TURN)then
        
        self._playerCurrent:setFreePurchaseShowTurn(self._playerCurrent:freePurchaseShowTurn() + 1)
        
    elseif(value:type() == EBonusType.EBT_PURCHASE_ADD_TIME)then
        
        self._playerCurrent:setFreePurchaseAddTime(self._playerCurrent:freePurchaseAddTime() + 1)
        
    else
        assert(false)
    end
end

function ControllerPopupBonus.cleanup(self)
    timer.cancel(self._timerUpdate)
    self._timerUpdate = nil
    
    self._managerBonus    = nil 
    self._playerCurrent    = nil
    
    self._view:cleanup()
    self._view = nil
    
    ControllerPopup.cleanup(self)
end
