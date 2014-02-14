require('game_flow.src.views.map.ViewStateMap')

require('game_flow.src.controllers.map.ControllerMapItem')

ControllerStateMap = classWithSuper(Controller, 'ControllerStateMap')

--
--Events
--

function ControllerStateMap.onViewClicked(self, target, event)
    local result = Controller.onViewClicked(self, target, event)
    
    return result
end

--
--Methods
--

function ControllerStateMap.init(self)
    
    local paramsView =
    {
        controller = self
    }
    
    local paramsController =
    {
        view = ViewStateMap:new(paramsView)
    }
    
    
    Controller.init(self, paramsController)
    
    self._items = {}
    
    local levels        = GameInfo:instance():managerLevels():levels()
    local currentLevel  = GameInfo:instance():managerLevels():firstIncompleteLevel()
    
    for i, level in ipairs(levels)do
        
        local paramsController = 
        {
            entry       = level,
            isCurrent   = currentLevel == level
        }
        
        local controller = ControllerMapItem:new(paramsController)
        
        table.insert(self._items, controller)
        
        self._view:viewItems():addItem(controller:view())
    end
    
    self._maxShowTimeFactor = 5
    
end

function ControllerStateMap.itemsShow(self, callback)
    for i, item in ipairs(self._items)do
        item:view():show(application.animation_duration * math.random(1, self._maxShowTimeFactor))
    end
    
    local delay = application.animation_duration * self._maxShowTimeFactor
    
    for i, item in ipairs(self._items)do
        item:showIcon(delay)
        
        delay = delay + 50
    end
    
    if(callback ~= nil)then
        self._timerItemsShow = timer.performWithDelay(delay, 
        function()
            self._timerItemsShow = nil
            callback()
        end,
        1)
    end
end

function ControllerStateMap.itemsHide(self, callback)
    for i, item in ipairs(self._items)do
        item:view():hide(application.animation_duration * math.random(1, self._maxShowTimeFactor))
    end
    
    local delay = application.animation_duration * self._maxShowTimeFactor
    
    if(callback ~= nil)then
        self._timerItemsHide = timer.performWithDelay(delay, 
        function()
            self._timerItemsHide = nil
            callback()
        end,
        1)
    end
    
    
end


function ControllerStateMap.cleanup(self)
    
    if(self._timerItemsHide)then
        timer.cancel(self._timerItemsHide)
        self._timerItemsHide = nil
    end
    
    if(self._timerItemsShow)then
        timer.cancel(self._timerItemsShow)
        self._timerItemsShow = nil
    end
    
    for i, item in ipairs(self._items)do
        item:cleanup()
    end
    
    self._items = nil
    
    self._view:cleanup()
    self._view = nil
    
    Controller.cleanup(self)
end

