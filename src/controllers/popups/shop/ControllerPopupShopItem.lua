require('game_flow.src.views.popups.shop.ViewPopupShopItem')

ControllerPopupShopItem = classWithSuper(Controller, 'ControllerPopupShopItem')

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
end

function ControllerPopupShopItem.cleanup(self)
    self._view:cleanup()
    self._view = nil
    
    Controller.cleanup(self)
end

