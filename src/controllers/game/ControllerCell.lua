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
    
    if(event.phase == ETouchEvent.ETE_BEGAN) then
        
        if(self._view:isInsideEvent(event))then
            
            if( self._isInside == false)then
                
                local isInsideFirstTime = self._isInsideFirstTime
                
                self:onInsideFirstTime()
                
                local currentLineFlowType = self._managerGame:currentLineFlowType()
                
                if currentLineFlowType ~= self._entry:flowType() then
                    self._managerGame:setCurrentLineFlowType(self._entry)
                    --self._currentState:controllerGrid():update(EControllerUpdate.ECUT_GRID)
                end
                
                self._managerGame:cacheStates()
                
                if not isInsideFirstTime and self._entry:flowType() ~= EFlowType.EFT_NONE then
                    
                    self._currentState:controllerGrid():update(EControllerUpdate.ECUT_DOG_UP, self._entry:flowType())
                    
                    
                end
                
                if self._entry:type() == ECellType.ECT_FLOW_POINT then
                    self._managerGame:setCurrentCell(self._entry)
                    --
                end
                
            end
            
        end
        
    elseif(event.phase == ETouchEvent.ETE_MOVED)  then
        
        if(self._view:isInsideEvent(event))then
            
            if not self._isInside then
                self:onInside()
                
            end
            
        elseif(self._isInside == true)then
            
            self:onOutside()
            
            local target = nil
            
            local entry = self._entry
            
            if(event.x > self._view:x1() )then
                
                target = entry:neighborRight()
                
            elseif( event.x < self._view:x0() )then
                
                target = entry:neighborLeft() 
                
            elseif(event.y > self._view:y1() )then
                
                target = entry:neighborDown() 
                
            elseif(event.y < self._view:y0() )then
                
                target = entry:neighborUp()
                
            end
            
            if target == nil and  not self._view:isInsideEvent(event) and self._isInsideFirstTime then 
                
                self:onOutsideGridOrEndedTouch()
                
                self._isInside          = false
                self._isInsideFirstTime = false
            end
            
            --если на мост переходим по горизонтали, то берём дополнительную (верхнюю) ячейку
            if target ~= nil and target:type() == ECellType.ECT_BRIDGE and 
                (target == self._entry:neighborRight() or target == self._entry:neighborLeft()) 
                then
                
                target = target:flowAdditional()
                
            end
            
            local canSelectTarget = false
            
            if target ~= nil then
                canSelectTarget = self:canSelectTarget(target)
                
                local currentCell = self._managerGame:currentCell()
                if  currentCell == nil and
                    (entry:flowType() ~= EFlowType.EFT_NONE) then
                    self._managerGame:setCurrentLineFlowType(entry)
                    self._managerGame:setCurrentCell(entry)
                    
                end
            end
            
            --если c моста переходим по горизонтали, то берём дополнительную (верхнюю) ячейку
            if(target ~= nil) 
                and (entry:type() == ECellType.ECT_BRIDGE) 
                and (target == entry:neighborRight() or target == entry:neighborLeft()) 
                then
                
                entry = entry:flowAdditional()
                
                if canSelectTarget then
                    self._managerGame:setCurrentLineFlowType(entry)
                    self._managerGame:setCurrentCell(entry)
                end
                
            end
            
            if(canSelectTarget)then
                
                self:onTrySelect(target)
                
                if entry:flowType() == EFlowType.EFT_NONE 
                    and entry:flowTypeCached() ~= EFlowType.EFT_NONE 
                    and target ~= entry:cellPrevCached() 
                    and target:flowType() ~= entry:flowTypeCached()  
                    then
                    
                    self._managerGame:restoreLine(entry:cellPrevCached())
                    
                end
                
            elseif (target ~= nil and target:type() ~= ECellType.ECT_FLOW_POINT)then
                
                self._managerGame:setCurrentLineFlowType(target)
                
            else
                
                self._managerGame:setCurrentLineFlowType(EFlowType.EFT_NONE)
                
            end
            
        end
        
    elseif((event.phase == ETouchEvent.ETE_ENDED or event.phase == ETouchEvent.ETE_CANCELLED)) 
        then
        
        self._isInside = false
        
        if self._isInsideFirstTime  then
            self:onOutsideGridOrEndedTouch()
        end
        
        self._isInsideFirstTime = false
        
    end
end

function ControllerCell.onOutsideGridOrEndedTouch(self)
    self._currentState:controllerGrid():update(EControllerUpdate.ECUT_DOG_DOWN, self._entry:flowType())
    
    self._managerGame:setCurrentLineFlowType(nil)
    self._managerGame:destroyCache()
    self._managerGame:setCurrentCell(nil)
    
end

function ControllerCell.onInsideFirstTime(self)
    
    if self._entry:flowType() ~= EFlowType.EFT_NONE and not self._isInside then
        self._managerGame:destroyLine(self._entry)
    end
    
    
    self:onInside()
    self._isInsideFirstTime = true
    
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
    self._currentState = GameInfo:instance():managerStates():currentState()
    
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
        
    elseif(updateType == EControllerUpdate.ECUT_CELL_PURCHASED)then
        
        self._view:setIsEnabled(false)
        
        self._view:setPath(self._entry:flowType())
        
        
        Runtime:removeEventListener(ERuntimeEvent.ERE_TOUCH, self)
        
    else
        assert(false)
    end
    
end

function ControllerCell.updateCellNext(self)
    local cellNext = self._entry:cellNext()
    
    --    if(cellNext == nil)then
    --        
    --        self._view:hideAllLines()
    --        
    --    elseif(cellNext == self._entry:neighborDown())then
    --        
    --        self._view:showLineDown(EFlowType.EFT_0)
    --        
    --    elseif(cellNext == self._entry:neighborUp())then
    --        
    --        self._view:showLineUp()
    --        
    --    elseif(cellNext == self._entry:neighborLeft())then
    --        
    --        self._view:showLineLeft()
    --        
    --    elseif(cellNext == self._entry:neighborRight())then
    --        
    --        self._view:showLineRight()
    --        
    --    else
    --        
    --        assert(false)
    --        
    --    end
    
end

function ControllerCell.canSelectTarget(self, target)
    local result = false
    
    local currentLineFlowType = self._managerGame:currentLineFlowType()
    
    local isTargetBarrier       = target:type()         == ECellType.ECT_BARRIER
    local currentLineIsEmpty    = currentLineFlowType   == self._entry:flowType()
    local currentLineSame       = currentLineFlowType   == nil
    local isTargetPurchased     = target:isPurchased()
    
    result = (not isTargetBarrier) and (currentLineSame or currentLineIsEmpty) and (not isTargetPurchased)
    
    if target:type() == ECellType.ECT_FLOW_POINT then
        result = result and currentLineFlowType == self._entry:flowType()
    end
    
    return result
    
end


function ControllerCell.tryBuildLine(self, lineCell, newCell)
    
    if newCell:type() == ECellType.ECT_FLOW_POINT and newCell:flowType() ~= lineCell:flowType() then
        return
    end
    
    if self._managerGame:currentCell() == lineCell then -- проверка на совпадение с текущей ячейкой 
        lineCell:setCellNext(newCell)
        
        self._managerGame:setCurrentLineFlowType(newCell)
        self._managerGame:setCurrentCell(newCell)
        self._currentState:controllerGrid():update(EControllerUpdate.ECUT_GRID)
    end
    
    if(newCell:type() == ECellType.ECT_FLOW_POINT)then
        self._managerGame:tryValidate()
    end
    
end

--function ControllerCell.tryOutHouse(self, cellPrev)
--    if cellPrev:type() == ECellType.ECT_FLOW_POINT and not cellPrev:isStart() then
--                
--        cellPrev:controller():onInHouse(true)
--        local controllerDog = self._currentState:controllerGrid():dogByType(cellPrev:flowType())
--        controllerDog:view():setInHouse(true)
--        controllerDog:setCurrentCell(cellPrev)
--            
--                
--    end
--end


function ControllerCell.cleanup(self)
    
    Runtime:removeEventListener(ERuntimeEvent.ERE_TOUCH, self)
    
    self._view:cleanup()
    self._view = nil
    
    self._currentState = nil
    
    Controller.cleanup(self)
end
