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
                self._view:buttonClose():show()
                
                local bonus = bonuses[bonusIndex]
                
                self._view:setReward(bonus:contentCount())
                
                self:applyBonus(bonus)
                
                self._managerBonus:onBonusClaimed()
                
                self:updateTime()
            end)
            
            self._view:buttonSpin():setIsEnabled(false)
            
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
    
end

function ControllerPopupBonus.updateTime(self)
    
    self._view:setTime(self._managerBonus:timeLeft())
    
    local isBonusAvailable =  self._managerBonus:isBonusAvailable()
    
    if(self._isBonusAvailable  ~= isBonusAvailable)then
        
        self._isBonusAvailable  = isBonusAvailable
        
        if(self._isBonusAvailable)then
            self._view:buttonClose():hide()
            self._view:buttonSpin():show()
            self._view:buttonSpin():setIsEnabled(true)
        else
            self._view:buttonClose():show()
            self._view:buttonSpin():hide()
        end
    end
    
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
        
    elseif(value:type() == EBonusType.EBT_PURCHASE_TIME)then
        
        self._playerCurrent:setFreePurchaseTime(self._playerCurrent:freePurchaseTime() + 1)
        
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
