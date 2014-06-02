require('game_flow.src.views.popups.shop.ViewPopupShopItem')

ControllerPopupShopItem = classWithSuper(Controller, 'ControllerPopupShopItem')

--
-- Events
--

function ControllerPopupShopItem.onViewClicked(self, target, event)
    local result = Controller.onViewClicked(self, target, event)
    
    if(not result)then
        
        if(self._view:buttonBuy() == target)then
            
            self._managerPurchases:onTryPurchase(self._entry, 
            function() --complete purchase
                self._view:buttonBuy():setIsEnabled(false)
                
                if(self._entry:type() == EPurchaseTypeBase.EPT_CURRENCY_SOFT)then
                    self._playerCurrent:setCurrencySoft(self._playerCurrent:currencySoft() + self._entry:contentCount())
                elseif(self._entry:type() == EPurchaseTypeBase.EPT_ENERGY)then
                    self._playerCurrent:setEnergy(self._playerCurrent:energy() + self._entry:contentCount())
                else
                    assert(false, self._entry:type())
                end
            end,
            function() --error purhcase
                self._view:buttonBuy():setIsEnabled(true)
            end)
            
        else
            assert(false)
        end
        
        
    end
    
    return result 
end



--
-- Methods
--

function ControllerPopupShopItem.init(self, params)
    assert(params.entry ~= nil)
    
    self._entry = params.entry
    
    local paramsView = 
    {
        controller  = self,
        entry       = self._entry
    }
    
    local paramsController = 
    {
        view = ViewPopupShopItem:new(paramsView)
    }
    
    
    Controller.init(self, paramsController)
    
    self._managerPurchases = GameInfo:instance():managerPurchases()
    self._playerCurrent    = GameInfo:instance():managerPlayers():playerCurrent()
    
end

function ControllerPopupShopItem.cleanup(self)
    self._view:cleanup()
    self._view = nil
    
    Controller.cleanup(self)
end

