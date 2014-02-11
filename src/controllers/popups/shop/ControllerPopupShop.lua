require('game_flow.src.views.popups.shop.ViewPopupShop')
require('game_flow.src.controllers.popups.shop.ControllerPopupShopItem')

ControllerPopupShop = classWithSuper(ControllerPopup, 'ControllerPopupShop')

--
-- Properties
--

function ControllerPopupShop.getType(self)
    return EPopupType.EPT_SHOP
end

--
-- Events
--

function ControllerPopupShop.onViewClicked(self, target, event)
    
    local result = ControllerPopup.onViewClicked(self, target, event)
    
    if(not result)then
        
        if(target == self._view:buttonCurrency())then
            self:showCurrency()
        elseif(target == self._view:buttonEnergy())then
            self:showEnergy()
        else
            assert(false)
        end
        
    end
    
    return result
end


--
-- Methods
--

function ControllerPopupShop.init(self)
    
    local paramsView = 
    {
        controller = self
    }
    
    local paramsController =
    {
        view = ViewPopupShop:new(paramsView)
    }
    
    ControllerPopup.init(self, paramsController)
    
    self._items = {}
    
    local purchases = GameInfo:instance():managerPurchases():purchases()
    
    for i, purchase in ipairs(purchases)do
        
        if(purchase:type() == EPurchaseTypeBase.EPT_CURRENCY_SOFT or purchase:type() == EPurchaseTypeBase.EPT_ENERGY)then
            
            local paramsItem = 
            {
                entry = purchase
            }
            
            local controllerItem  = ControllerPopupShopItem:new(paramsItem)
            table.insert(self._items, controllerItem)
            
            if(purchase:type() == EPurchaseTypeBase.EPT_CURRENCY_SOFT)then
                self._view:contentCurrency():addItem(controllerItem:view())
            elseif(purchase:type() == EPurchaseTypeBase.EPT_ENERGY)then
                self._view:contentEnergy():addItem(controllerItem:view())
            else
                assert(false)
            end
            
        end
        
    end
    
    self:showCurrency()
    
end

function ControllerPopupShop.showCurrency(self)
    self._view:buttonCurrency():setIsEnabled(false)
    self._view:buttonEnergy():setIsEnabled(true)
    
    self._view:contentCurrency():sourceView().alpha   = 1
    self._view:contentEnergy():sourceView().alpha     = 0
end

function ControllerPopupShop.showEnergy(self)
    self._view:buttonCurrency():setIsEnabled(true)
    self._view:buttonEnergy():setIsEnabled(false)
    
    self._view:contentCurrency():sourceView().alpha   = 0
    self._view:contentEnergy():sourceView().alpha     = 1
end


function ControllerPopupShop.cleanup(self)
    
    for i, item in ipairs(self._items)do
        item:cleanup()
    end
    
    self._items = nil
    
    self._view:cleanup()
    self._view = nil
    
    ControllerPopup.cleanup(self)
end



