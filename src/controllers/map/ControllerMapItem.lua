
require('game_flow.src.views.map.ViewMapItemBase')
require('game_flow.src.views.map.ViewMapItemComplete')
require('game_flow.src.views.map.ViewMapItemCurrent')

ControllerMapItem = classWithSuper(Controller, 'ControllerMapItem')

--
-- Properties
--
function ControllerMapItem.entry(self)
    return self._entry
end

--
-- Events
-- 

function ControllerMapItem.onViewClicked(self, target, event)
    local result = Controller.onViewClicked(self, target, event)
    
    if(not result)then
        if(target == self._view:button())then
            
            local playerCurrent = GameInfo:instance():managerPlayers():playerCurrent()
            
            if (playerCurrent:energy() > 0) then
                
                local paramsGame = 
                {
                    currentLevel = self._entry
                }
                --todo change
                GameInfoBase:instance():managerStates():setState(EStateTypeBase.EST_EMPTY)
                
                --                GameInfoBase:instance():onGameStart(ManagerGame:new(paramsGame))
                --                GameInfoBase:instance():managerStates():setState(EStateType.EST_GAME)
            else
                
                GameInfoBase:instance():managerStates():currentState():showPopup(EPopupType.EPT_NO_ENERGY)
                
            end
        end
    end
    
    return result
end

--
-- Methods
--

function ControllerMapItem.init(self, params)
    assert(params.entry     ~= nil)
    assert(params.isCurrent ~= nil)
    
    self._isCurrent =params.isCurrent
    self._entry     = params.entry
    
    local paramsView = 
    {
        controller = self
    }
    
    local view = nil
    
    if(self._isCurrent)then
        view = ViewMapItemCurrent:new(paramsView)
    elseif(self._entry:progress():isComplete())then
        view = ViewMapItemComplete:new(paramsView)
    else
        
        view = ViewMapItemBase:new(paramsView)
        view:createImageItem(EResourceType.ERT_STATE_MAP_ITEM_CLOSE)
    end
    
    local paramsController = 
    {
        view = view
    }
    
    Controller.init(self, paramsController)
    
end

function ControllerMapItem.showIcon(self, delay)
    if(not self._isCurrent and self._entry:progress():isComplete())then
        self._view:animateIcon(delay)
    end
end

function ControllerMapItem.cleanup(self)
    
    self._view:cleanup()
    self._view = nil
    
    Controller.cleanup(self)
end

