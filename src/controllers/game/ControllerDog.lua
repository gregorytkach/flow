require('game_flow.src.views.game.ViewDog')
require('game_flow.src.views.game.EDogAnimationType')

ControllerDog = classWithSuper(Controller, 'ControllerDog')

--
--Properties
--

function ControllerDog.currentCell(self)
    return self._currentCell
end

function ControllerDog.setCurrentCell(self, value)
    
    if value == self._currentCell then
        return
    end
    
    assert(value ~= nil)
    
    if self._currentCell ~= nil and (self._currentCell:type() == ECellType.ECT_FLOW_POINT and not self._currentCell:isStart())  then
        self._currentCell:controller():onInHouse(false)
        self:view():setInHouse(false)
        self._cell = nil
    end
    
    self._currentCell = value
    
    if self._currentCell:type() == ECellType.ECT_FLOW_POINT and not self._currentCell:isStart() and ((self._currentCell:cellNext() == nil and self._currentCell:cellNextCached() ~= nil) or (not self:view():inHouse() and self:view():currentAnimationType() == EDogAnimationType.EDAT_IDLE) ) then
        
        self._currentCell:controller():onInHouse(true)
        
        self:view():setInHouse(true)
        
    end
    
    local viewCell = value:controller():view()
    self:view():setDogPosition(viewCell:sourceView())
    
    
    
end

function ControllerDog.flowType(self)
    return self._flowType
end

--
--Events
--


--
--Methods
--


function ControllerDog.init(self, params)
    
    assert(params.flow_type ~= nil)
    
    self._flowType = params.flow_type
    
    local paramsView = 
    {
        controller  = self,
        flow_type   = params.flow_type,
    }
    
    local paramsController = 
    {
        view = ViewDog:new(paramsView),
    }
    
    Controller.init(self, paramsController)
    
    self._managerGame = GameInfo:instance():managerGame()
    
end

function ControllerDog.transitionDog(self, type)
    
    self:tryCleanupTweenDogMoved()
    
    local source = self._view:currentAnimation()
    
    local yTarget = 0
    local onComplete = nil
    
    local offsetY = - 20
    local timeInterval
    
    if type == EDogAnimationType.EDAT_DOWN then
        
        source.y = offsetY
        
        onComplete = function () 
            self._tweenDogMoved = nil 
            self:update(EControllerUpdate.ECUT_DOG_IDLE)
        end
        
        timeInterval = Constants.DOG_TIME_DOWN
        
    else
        
        source.y = 0
        
        yTarget      = offsetY 
        timeInterval = Constants.DOG_TIME_UP
        
    end
    
    
    local tweenParams =
    {
        y           = yTarget,
        time        = timeInterval ,
        onComplete  = onComplete,
    }
    
    if type == EDogAnimationType.EDAT_DOWN then
        tweenParams.transition = GameInfo:instance():managerStates():easingProvider().easeOutBounce
    end
    
    self._tweenDogMoved = transition.to(source, tweenParams) 
end

function ControllerDog.update(self, type)
    
    if(type ==  EControllerUpdate.ECUT_DOG_UP)  then
        
        self._view:setCurrentAnimation(EDogAnimationType.EDAT_UP)
        self:transitionDog(EDogAnimationType.EDAT_UP)
        
    elseif (type ==  EControllerUpdate.ECUT_DOG_DOWN) then
        
        self._view:setCurrentAnimation(EDogAnimationType.EDAT_DOWN)
        self:transitionDog(EDogAnimationType.EDAT_DOWN)
        
    elseif (type ==  EControllerUpdate.ECUT_DOG_IDLE) then
        
        self._view:setCurrentAnimation(EDogAnimationType.EDAT_IDLE)
        
    else
        assert(false)
    end
    
end

function ControllerDog.tryCleanupTweenDogMoved(self)
    
    if self._tweenDogMoved == nil then
        return
    end
    
    transition.cancel(self._tweenDogMoved)
    self._tweenDogMoved = nil
    
end



function ControllerDog.cleanup(self)
    
    self:tryCleanupTweenDogMoved()
    
    self._managerGame = nil
    
    self._view:cleanup()
    self._view = nil
    
    Controller.cleanup(self)
    
end
