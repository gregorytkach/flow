require('game_flow.src.views.game.cells.ViewCellWithView')

ControllerCellBarrier = classWithSuper(ControllerCell, 'ControllerCellBarrier')

--
--Events
--

function ControllerCellBarrier.canSelectTarget(self, target)
    return false
end
--
--Methods
--

function ControllerCellBarrier.init(self, params)
    ControllerCell.init(self, params)
end

function ControllerCellBarrier.createView(self)
    local result = nil 
    
    local paramsView = 
    {
        controller   = self,
        isPair       = self._isPair
    }
    
    result = ViewCellWithView:new(paramsView)
    
    return result
end

function ControllerCellBarrier.onTrySelect(self, target)
    assert(false)
end