
CellFlowPoint = classWithSuper(CellBase, 'CellFlowPoint')

--
--Properties
--

function CellFlowPoint.type(self)
    return ECellType.ECT_FLOW_POINT
end

function CellFlowPoint.isStart(self)
    return self._isStart
end

--
--Events

--

--
--Methods
--
function CellFlowPoint.restoreState(self)
    
    local result = CellBase.restoreState(self)
    if not self._isStart then
        GameInfo:instance():managerStates():currentState():controllerGrid():dogByType(self._flowType):view():setInHouse(false)
    end
    return result
end

function CellFlowPoint.init(self, params)
    assert(params.is_start ~= nil)
    
    CellBase.init(self, params)
    
    assert(self._flowType       ~= EFlowType.EFT_NONE)
    
    self._isStart = params.is_start
end


