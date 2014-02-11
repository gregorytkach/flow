require('game_flow.src.views.game.cells.ViewCellBridge')

ControllerCellBridge = classWithSuper(ControllerCell, 'ControllerCellBridge')

--
--Events
--

function ControllerCellBridge.canSelectTarget(self, target)
    local result = false
    
    local currentLineFlowType = self._managerGame:currentLineFlowType()
    
    local isTargetHorizontal    = target == self._entry:neighborLeft()  or target == self._entry:neighborRight()
    local isTargetVertical      = target == self._entry:neighborUp()    or target == self._entry:neighborDown()
    
    local isTargetBarrier               = target:type() == ECellType.ECT_BARRIER
    local currentLineIsEmpty            = currentLineFlowType == nil
    local currentLineIsSameMain         = self._entry:flowType() == currentLineFlowType 
    local currentLineIsSameAdditional   = self._entry:flowAdditional() ~= nil and self._entry:flowAdditional():flowType() == currentLineFlowType
    
    --    result = (not isTargetBarrier) and (currentLineIsEmpty or currentLineIsSameMain or currentLineIsSameAdditional)
    
    return result
end
--
--Methods
--

function ControllerCellBridge.init(self, params)
    ControllerCell.init(self, params)
end

function ControllerCellBridge.createView(self)
    local result = nil 
    
    local paramsView = 
    {
        controller   = self,
        isPair       = self._isPair
    }
    
    result = ViewCellBridge:new(paramsView)
    
    return result
end

function ControllerCellBridge.onTrySelect(self, target)
    assert(false)
end


function ControllerCellBridge.update(self, updateType)
    
    if(updateType == EControllerUpdate.ECUT_CELL_NEXT)then
        
        ControllerCell.update(self, updateType)
        
    elseif(updateType == EControllerUpdate.ECUT_INCLUSION_IN_LINE)then
        
        self._view:setPath(self._entry:flowType())
        
    elseif(updateType == EControllerUpdate.ECUT_EXCLUSION_FROM_LINE)then
        
        self._view:setPath(nil)
        
    end
    
end