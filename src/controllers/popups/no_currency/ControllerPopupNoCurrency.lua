require('game_flow.src.views.popups.no_currency.ViewPopupNoCurrency')

ControllerPopupNoCurrency = classWithSuper(ControllerPopup, 'ControllerPopupNoCurrency')

--
-- Properties
--

function ControllerPopupNoCurrency.getType(self)
    return EPopupType.EPT_NO_CURRENCY
end

--
-- Events
--
function ControllerPopupNoCurrency.onViewClicked(self, target, event)
    local result = ControllerPopup.onViewClicked(self, target, event)
    
    if(not result)then
        if(target == self._view:buttonBuy())then
            local currentState = GameInfo:instance():managerStates():currentState()
            
            currentState:hidePopup(function()
                local popupShop = currentState:getPopup(EPopupType.EPT_SHOP)
                popupShop:showCurrency()
                
                currentState:showPopup(EPopupType.EPT_SHOP)
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

function ControllerPopupNoCurrency.init(self)
    
    local paramsView =
    {
        controller = self
    }
    
    local paramsController = 
    {
        view = ViewPopupNoCurrency:new(paramsView)
    }
    
    ControllerPopup.init(self, paramsController)
    
    
end


function ControllerPopupNoCurrency.cleanup(self)
    
    self._view:cleanup()
    self._view = nil
    
    ControllerPopup.cleanup(self)
end


