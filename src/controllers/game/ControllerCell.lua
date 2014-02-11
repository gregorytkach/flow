require('game_flow.src.views.game.cells.ViewCell')

ControllerCell = classWithSuper(Controller, 'ControllerCell')

--
--Properties
--

function ControllerCell.entry(self)
    return self._entry
end


--
--Events
--

function ControllerCell.touch(self, event)
    
    local currentLineFlowType = self._managerGame:currentLineFlowType()
    
    if(event.phase == ETouchEvent.ETE_BEGAN) then
        
        if(self._view:isInsideEvent(event))then
            
            if( self._isInside == false)then
                
                self:onInsideFirstTime()
                
                self._managerGame:setCurrentLineFlowType(self._entry:flowType())
                
                self._managerGame:cacheStates()
                
            end
        end
        
    elseif(event.phase == ETouchEvent.ETE_MOVED) then
        
        if(self._view:isInsideEvent(event))then
            
            if not self._isInside then
                self:onInside()
            end
            
        elseif(self._isInside == true)then
            
            self:onOutside()
            
            local target = nil
            
            if(event.x > self._view:x1())then
                
                target = self._entry:neighborRight()
                
            elseif( event.x < self._view:x0())then
                
                target = self._entry:neighborLeft() 
                
            elseif(event.y > self._view:y1())then
                
                target = self._entry:neighborDown() 
                
            elseif(event.y < self._view:y0())then
                
                target = self._entry:neighborUp()
                
            end
            
            
            if(target ~= nil and self:canSelectTarget(target))then
                
                self:onTrySelect(target)
                
                if self._entry:flowType() == EFlowType.EFT_NONE 
                    and self._entry:flowTypeCached() ~= EFlowType.EFT_NONE 
                    and target ~= self._entry:cellPrevCached() then
                    
                    self._managerGame:restoreLine(self._entry:cellPrevCached())
                    
                end
                
            elseif (target ~= nil and target:type() ~= ECellType.ECT_FLOW_POINT)then
                self._managerGame:setCurrentLineFlowType(target:flowType())
            else
                self._managerGame:setCurrentLineFlowType(EFlowType.EFT_NONE)
            end
            
        end
        
    elseif(event.phase == ETouchEvent.ETE_ENDED or event.phase == ETouchEvent.ETE_CANCELLED)then
        
        self._isInside = false
        
        self._managerGame:setCurrentLineFlowType(nil)
        self._managerGame:destroyCache()
        
    end
end

function ControllerCell.onInsideFirstTime(self)
    
    self._isInside = true
    
end

function ControllerCell.onInside(self)
    self._isInside = true
end

function ControllerCell.onOutside(self)
    
    self._isInside = false
    
end

--
--Methods
--

function ControllerCell.init(self, params)
    assert(params           ~= nil)
    assert(params.entry     ~= nil)
    assert(params.isPair    ~= nil)
    
    self._isPair = params.isPair 
    self._entry  = params.entry
    self._entry:setController(self)
    
    
    
    local paramsController = 
    {
        view = self:createView(),
        type = self._entry:type()
    }
    
    Controller.init(self, paramsController)
    
    self._source        = self._view:sourceView()
    
    self._view:hideAllLines()
    
    self._isInside = false
    
    self._managerGame = GameInfo:instance():managerGame()
end

function ControllerCell.createView(self)
    local result = nil 
    
    local paramsView = 
    {
        controller   = self,
        isPair       = self._isPair
    }
    
    result = ViewCell:new(paramsView)
    
    return result
    
end

function ControllerCell.update(self, updateType)
    if(updateType == EControllerUpdateBase.ECUT_SCENE_ENTER)then
        
        Runtime:addEventListener(ERuntimeEvent.ERE_TOUCH, self)
        
    elseif(updateType == EControllerUpdate.ECUT_CELL_NEXT)then
        
        self:updateCellNext()
        
    elseif(updateType == EControllerUpdate.ECUT_INCLUSION_IN_LINE)then
        
        self._view:setPath(self._entry:flowType())
        
    elseif(updateType == EControllerUpdate.ECUT_EXCLUSION_FROM_LINE)then
        
        self._view:setPath(nil)
        
    else
        assert(false)
    end
    
end

function ControllerCell.updateCellNext(self)
    local cellNext = self._entry:cellNext()
    
    if(cellNext == nil)then
        
        self._view:hideAllLines()
        
    elseif(cellNext == self._entry:neighborDown())then
        
        self._view:showLineDown(EFlowType.EFT_0)
        
    elseif(cellNext == self._entry:neighborUp())then
        
        self._view:showLineUp()
        
    elseif(cellNext == self._entry:neighborLeft())then
        
        self._view:showLineLeft()
        
    elseif(cellNext == self._entry:neighborRight())then
        
        self._view:showLineRight()
        
    else
        
        assert(false)
        
    end
    
end

function ControllerCell.canSelectTarget(self, target)
    local result = false
    
    local currentLineFlowType = self._managerGame:currentLineFlowType()
    
    local isTargetBarrier       = target:type()         == ECellType.ECT_BARRIER
    local currentLineIsEmpty    = currentLineFlowType   == self._entry:flowType()
    local currentLineSame       = currentLineFlowType   == nil
    
    if(currentLineIsEmpty)then
        --        print(1)
    end
    
    if(currentLineSame)then
        --        print(1)
    end
    
    result = (not isTargetBarrier) and (currentLineSame or currentLineIsEmpty)
    
    if target:type() == ECellType.ECT_FLOW_POINT then
        result = result and currentLineFlowType == self._entry:flowType()
    end
    
    return result
    
end

function ControllerCell.buildLine(self, lineCell, newCell)
    lineCell:setCellNext(newCell)
    
    self._managerGame:setCurrentLineFlowType(lineCell:flowType())
end


function ControllerCell.cleanup(self)
    
    Runtime:removeEventListener(ERuntimeEvent.ERE_TOUCH, self)
    
    self._view:cleanup()
    self._view = nil
    
    Controller.cleanup(self)
end
