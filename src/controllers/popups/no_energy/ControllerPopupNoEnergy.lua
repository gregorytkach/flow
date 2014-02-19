require('game_flow.src.views.popups.no_energy.ViewPopupNoEnergy')

ControllerPopupNoEnergy = classWithSuper(ControllerPopup, 'ControllerPopupNoEnergy')

--
-- Properties
--

function ControllerPopupNoEnergy.getType(self)
    return EPopupType.EPT_NO_ENERGY
end

--
-- Events
--

function ControllerPopupNoEnergy.onViewClicked(self, target, event)
    local result = ControllerPopup.onViewClicked(self, target, event)
    
    if(not result)then
        if(target == self._view:buttonBuy())then
            local currentState = GameInfo:instance():managerStates():currentState()
            
            currentState:hidePopup(function()
                local popupShop = currentState:getPopup(EPopupType.EPT_SHOP)
                popupShop:showEnergy()
                
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

function ControllerPopupNoEnergy.init(self)
    
    local paramsView =
    {
        controller = self
    }
    
    local paramsController = 
    {
        view = ViewPopupNoEnergy:new(paramsView)
    }
    
    ControllerPopup.init(self, paramsController)
    
    
end


