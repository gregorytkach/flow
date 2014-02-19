require('game_flow.src.views.game.ViewDog')

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

function ControllerDog.update(self, updateType)
    
    if(updateType == EControllerUpdateBase.ECUT_SCENE_ENTER)then
        
    else
        assert(false)
    end
    
end

function ControllerDog.cleanup(self)
    
    self._managerGame = nil
    
    Controller.cleanup(self)
    
end
