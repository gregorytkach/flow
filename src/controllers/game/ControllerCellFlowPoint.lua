

ControllerCellFlowPoint = classWithSuper(ControllerCell, 'ControllerCellFlowPoint')

--
--Events
--
function ControllerCellFlowPoint.onInHouse(self, value)
    
    assert(value ~= nil)
    
    if (value and self._tweenHouse ~= nil) or (not value and self._tweenHouse == nil)  then
        return
    end
    
    local houseFull = self._view:houseFull()
    local house     = self._view:house()
    local timeInterval = application.animation_duration * 4
    
    if value then
        
        if self._houseScale == nil then
            self._houseScaleStart = houseFull.yScale
            self._houseScale      = houseFull.yScale
            
            
            if self._currentState:controllerGrid():updateType() ~= EControllerUpdate.ECUT_DOG_DOWN then
                timeInterval = 1
            end
            
        elseif self._houseScale > self._houseScaleStart then 
            self._houseScale = 0.9 * self._houseScaleStart
            houseFull.isVisible = true
            house.isVisible = false
        else
            self._houseScale = 1.1 * self._houseScaleStart
            houseFull.isVisible = true
            house.isVisible = false
        end
    
        local tweenHouseParams =
        {
            yScale     = self._houseScale,
            time       = timeInterval,
            onComplete = function () 
                            self._currentState:controllerGrid():dogByType(self._entry:flowType()):update(EControllerUpdate.ECUT_DOG_IDLE)
                            self._tweenHouse = nil
                            self:onInHouse(true) 
                        end,
        }
        
        self._tweenHouse = transition.to(houseFull, tweenHouseParams)
        
    else
            
        houseFull.yScale = self._houseScaleStart
        houseFull.isVisible = false
        house.isVisible = true
        self._houseScale = nil
        self:tryTweenHouseCleanup()
    end
end

function ControllerCellFlowPoint.tryTweenHouseCleanup(self)
    
    if self._tweenHouse ~= nil then
        transition.cancel(self._tweenHouse) 
        self._tweenHouse = nil
    end
end

function ControllerCellFlowPoint.onInsideFirstTime(self)
    
    
    self._managerGame:destroyLinesWithType(self._entry:flowType())
    self._managerGame:setCurrentCell(self._entry)
    
    self:update(EControllerUpdate.ECUT_INCLUSION_IN_LINE)
    ControllerCell.onInsideFirstTime(self)
    
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

        self:tryOutHouse(cellPrev)
        
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
    self:tryTweenHouseCleanup()
    ControllerCell.cleanup(self)
end
