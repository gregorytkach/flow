require('game_flow.src.views.game.ViewDog')
require('game_flow.src.views.game.EDogAnimationType')

ControllerDog = classWithSuper(Controller, 'ControllerDog')

--
--Properties
--

function ControllerDog.row(self)
    
    return self._row
    
end

function ControllerDog.setRow(self, row)
    assert(row ~= nil)
    self._row = row
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
    
    local source = self._view:currentAnimation()
    
    local yTarget = 0
    local onComplete = nil
    
    local offsetY = - 30
    
    if type == EDogAnimationType.EDAT_DOWN then
        
        source.y = offsetY
        
        onComplete = function () 
            self._tweenDogMoved = nil 
            self:update(EControllerUpdate.ECUT_DOG_IDLE)
        end
        
    else
        
        source.y = 0
        
        yTarget = offsetY 
        
    end
    
        
    local tweenParams =
    {
        y           = yTarget,
        time        = application.animation_duration * 4 ,
        onComplete  = onComplete,
    }

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
   
    if self._tweenDogMoved ~= nil then
        transition.cancel(self._tweenDogMoved)
        self._tweenDogMoved = nil
    end
    
end

function ControllerDog.cleanup(self)
    
    self:tryCleanupTweenDogMoved()
    
    self._managerGame = nil
    
    Controller.cleanup(self)
    
end
