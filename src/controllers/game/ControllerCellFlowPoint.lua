

ControllerCellFlowPoint = classWithSuper(ControllerCell, 'ControllerCellFlowPoint')

--
--Events
--

function ControllerCellFlowPoint.onInsideFirstTime(self)
    
    self._managerGame:setCurrentCell(self._entry)
    self._managerGame:destroyLinesWithType(self._entry:flowType())
    
    self:update(EControllerUpdate.ECUT_INCLUSION_IN_LINE)
    
    ControllerCell.onInside(self)
end

function ControllerCellFlowPoint.canSelectTarget(self, target)
    local result = ControllerCell.canSelectTarget(self, target)
    
    if(result and target ~= self._entry:cellPrev())then
        local isLineComplete = self:isLineComplete()
        
        result = not isLineComplete
    end
    
    
    return result
end

--
--Methods
--

function ControllerCellFlowPoint.init(self, params)
    ControllerCell.init(self, params)
end

function ControllerCellFlowPoint.createView(self)
    local result = nil 
    
    local paramsView = 
    {
        controller   = self,
        isPair       = self._isPair
    }
    
    result = ViewCellWithView:new(paramsView)
    
    return result
end

function ControllerCellFlowPoint.onTrySelect(self, target)
    
    if(self._entry:cellNext() ~= nil) then
        
        self._managerGame:destroyLine(self._entry)
        
        
    end
    
    local isNext = target:cellNext() == self._entry
    
    local cellPrev = target:cellPrev()
    
    if(cellPrev ~= nil) then
        
        self._managerGame:destroyLine(cellPrev)
        
    end
    
    if(target:type() == ECellType.ECT_FLOW_POINT)  then
        
        if(target:flowType() == self._entry:flowType())then
        
            self:tryBuildLine(self._entry, target)
            
        else
            --do nothing
        end
        
    elseif isNext and cellPrev ~= nil then
        
        self:tryBuildLine(cellPrev, target)
        
    else 
        
        self:tryBuildLine(self._entry, target)
        
    end
    
end

function ControllerCellFlowPoint.isLineComplete(self)
    local result = false
    
    local isStartPoint = true 
    
    local cellCurrent = self._entry:cellNext() 
    
    if(cellCurrent == nil)then
        cellCurrent = self._entry:cellPrev()
        isStartPoint = false
    end
    
    while(cellCurrent ~= nil)do
        
        if(cellCurrent:type() == self._entry:type())then
            result = true
            break
        end
        
        if(isStartPoint)then
            cellCurrent = cellCurrent:cellNext()
        else
            cellCurrent = cellCurrent:cellPrev()
        end
        
    end
    
    return result
end

function ControllerCellFlowPoint.cleanup(self)
    ControllerCell.cleanup(self)
end
