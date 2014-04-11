require('game_flow.src.views.popups.tutorial.ViewPopupTutorial')
ControllerPopupTutorial = classWithSuper(ControllerPopup, 'ControllerPopupTutorial')

--
-- Properties
--

function ControllerPopupTutorial.getType(self)
    return EPopupType.EPT_TUTORIAL
end

--
-- Events
--

function ControllerPopupTutorial.onViewClicked(self, target, event)
    local result = ControllerPopup.onViewClicked(self, target, event)
    
    
    if(not result)then
        
        if(target == self._view:buttonNext())then
            
            self._step = self._step + 1
            self:prepare(self._step)
            
        else
            assert(false)
        end
        
    end
    
    return result
end


--
-- Methods
--

function ControllerPopupTutorial.init(self)
    
    local paramsView = 
    {
        controller = self
    }
    
    local paramsController = 
    {
        view = ViewPopupTutorial:new(paramsView)
    }
    
    ControllerPopup.init(self, paramsController)
    
end

function ControllerPopupTutorial.prepare(self, step)
    
    
    if(step == nil)then
        --need show from first step to current
        
        self._step = 1
        
    else
        self._step = step
        
    end
    
    self._view:showStep(self._step)
    self:prepareButtonClose()
end

function ControllerPopupTutorial.prepareButtonClose(self)
    local managerTutorial = GameInfo:instance():managerTutorial()
    
    local stepCurrent = managerTutorial:stepCurrent()
    
    if(self._step < stepCurrent) then
         --need show button next
        self._view:buttonClose():sourceView().isVisible = false
        self._view:buttonNext():sourceView().isVisible  = true
    else
        --need show button close
        self._view:buttonClose():sourceView().isVisible  = true
        self._view:buttonNext():sourceView().isVisible   = false
    end
end

function ControllerPopupTutorial.cleanup(self)
    Object.cleanup(self)
end
