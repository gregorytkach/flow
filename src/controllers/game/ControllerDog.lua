require('game_flow.src.views.game.ViewDog')
require('game_flow.src.views.game.EDogAnimationType')

ControllerDog = classWithSuper(Controller, 'ControllerDog')

--
--Properties
--

function ControllerDog.flowType(self)
    return self._flowType
end
--
--Events
--





--
--Methods
--

function ControllerDog.update(self, type)
    
    if(type ==  EControllerUpdate.ECUT_DOG_UP) then
        
        self._view:setCurrentAnimation(EDogAnimationType.EDAT_UP)
        
    elseif (type ==  EControllerUpdate.ECUT_DOG_DOWN) then
        
        self._view:setCurrentAnimation(EDogAnimationType.EDAT_DOWN)
        
    elseif (type ==  EControllerUpdate.ECUT_DOG_IDLE) then
        
        self._view:setCurrentAnimation(EDogAnimationType.EDAT_IDLE)
        
    else
        
        assert(false)
        
    end
        
end

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


function ControllerDog.cleanup(self)
    
    self._managerGame = nil
    
    Controller.cleanup(self)
    
end
