require('game_flow.src.views.game.ViewPurchases')

ControllerPurchases = classWithSuper(Controller, 'ControllerPurchases')

--
-- Events
--

function ControllerPurchases.onViewClicked(self, target, event)
    local needShowPopupNoCurrency = false
    
    if (self._view:buttonResolve() == target) then
        
    elseif (self._view:buttonShowTurn() == target) then
        
        self._managerGame:onBuyPurchaseLine()
        
    elseif (self._view:buttonAddTime() == target) then
        
        local applyPurchase = false
        
        if(self._playerCurrent:freePurchaseAddTime() > 0)then
            
            self._playerCurrent:setFreePurchaseAddTime(self._playerCurrent:freePurchaseAddTime() - 1)
            
            applyPurchase = true
        elseif(self._playerCurrent:currencySoft() >= self._purchaseAddTime:priceSoft())then
            
            self._playerCurrent:setCurrencySoft(self._playerCurrent:currencySoft() - self._purchaseAddTime:priceSoft())
            
            applyPurchase = true
        else
            needShowPopupNoCurrency = true
        end
        
        if(applyPurchase)then
            self._managerGame:onBuyAddTime()        
        end
    else
        assert(false)
    end
    
    if(needShowPopupNoCurrency)then
        GameInfo:instance():managerStates():currentState():showPopup(EPopupType.EPT_NO_CURRENCY)
    end
    
end

--
-- Methods
--

function ControllerPurchases.init(self)
    
    local paramsView = 
    {
        controller = self
    }
    
    local paramsController =
    {
        view = ViewPurchases:new(paramsView)
    }
    
    Controller.init(self, paramsController)
    
    self._managerGame    = GameInfo:instance():managerGame()
    self._playerCurrent  = GameInfo:instance():managerPlayers():playerCurrent()
    self._textFormatFree = GameInfo:instance():managerString():getString(EStringType.EST_GAME_PURCHASE_FREE)
    
    local purchases = GameInfo:instance():managerPurchases():purchases()
    
    for i, purchase in ipairs(purchases) do
        
        if(purchase:type() == EPurchaseType.EPT_ADD_TIME)then
            self._purchaseAddTime = purchase
        elseif(purchase:type() == EPurchaseType.EPT_RESOLVE)then
            self._purchaseResolve = purchase
        elseif(purchase:type() == EPurchaseType.EPT_SHOW_TURN)then
            self._purchaseShowTurn = purchase
        end
        
    end
    
    self:updateButtonAddTime()
    self:updateButtonResolve()
    self:updateButtonShowTurn()
    
end

function ControllerPurchases.update(self, updateType)
    
    if(updateType == EControllerUpdate.ECUT_FREE_PURCHASE_RESOLVE)then
        self:updateButtonResolve()
    elseif(updateType == EControllerUpdate.ECUT_FREE_PURCHASE_SHOW_TURN)then
        self:updateButtonShowTurn()
    elseif(updateType == EControllerUpdate.ECUT_FREE_PURCHASE_ADD_TIME)then
        self:updateButtonAddTime()
    else
        assert(false)
    end
    
end

function ControllerPurchases.updateButtonResolve(self)
    
    local text                  = nil
    local iconCurrencyVisible   = nil
    
    if(self._playerCurrent:freePurchaseResolve() > 0)then
        text = string.format(self._textFormatFree, self._playerCurrent:freePurchaseResolve())
        iconCurrencyVisible  = false
    else
        text                = self._purchaseResolve:priceSoft()
        iconCurrencyVisible = true
    end
    
    self._view:setTextButtonResolve(text, iconCurrencyVisible)
end

function ControllerPurchases.updateButtonShowTurn(self)
    
    local text                  = nil
    local iconCurrencyVisible   = nil
    
    if(self._playerCurrent:freePurchaseShowTurn() > 0)then
        text = string.format(self._textFormatFree, self._playerCurrent:freePurchaseShowTurn())
        iconCurrencyVisible  = false
    else
        text                = self._purchaseShowTurn:priceSoft()
        iconCurrencyVisible = true
    end
    
    self._view:setTextButtonShowTurn(text, iconCurrencyVisible)
    
end

function ControllerPurchases.updateButtonAddTime(self)
    
    local text                  = nil
    local iconCurrencyVisible   = nil
    
    if(self._playerCurrent:freePurchaseAddTime() > 0)then
        text = string.format(self._textFormatFree, self._playerCurrent:freePurchaseAddTime())
        iconCurrencyVisible  = false
    else
        text                = self._purchaseAddTime:priceSoft()
        iconCurrencyVisible = true
    end
    
    self._view:setTextButtonAddTime(text, iconCurrencyVisible)
    
end

function ControllerPurchases.cleanup(self)
    
    self._view:cleanup()
    self._view = nil
    
    Controller.cleanup(self)
end

