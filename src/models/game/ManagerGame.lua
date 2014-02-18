
require('game_flow.src.models.game.cells.EFlowType')

require('game_flow.src.models.game.cells.base.CellBase')
require('game_flow.src.models.game.cells.base.FactoryCells')
require('game_flow.src.models.game.cells.bridge.CellBridge')
require('game_flow.src.models.game.cells.barrier.CellBarrier')
require('game_flow.src.models.game.cells.empty.CellEmpty')
require('game_flow.src.models.game.cells.flowPoint.CellFlowPoint')


ManagerGame = classWithSuper(ManagerGameBase, 'ManagerGame') 

--
--Properties
--


function ManagerGame.currentCell(self)
    
    return self._currentCell
    
end

function ManagerGame.setCurrentCell(self, cell)
    
    
    self._currentCell = cell
    if cell ~= nil then
        
        self._currentState:update(EControllerUpdate.ECUT_SET_CURRENT_CELL)
        if cell:type() ~= ECellType.ECT_FLOW_POINT then
            self:setCurrentLineFlowType(cell)
        end
        
    end
    
end


function ManagerGame.timeLeft(self)
    return self._timeLeft
end

function ManagerGame.currentLineFlowType(self)
    return self._currentLineFlowType
end

function ManagerGame.setCurrentLineFlowType(self, value)
    
    if value ~= EFlowType.EFT_NONE and value ~= nil and  self._currentLineFlowType ~= value:flowType() then
        
        local flowType = value:flowType()
        
        if flowType ~= self._currentLineFlowType and self._currentLineFlowType ~= EFlowType.EFT_NONE and self._currentLineFlowType ~= nil then
            self._currentState:update(EControllerUpdate.ECUT_DOG_DOWN)
        end
        
        self._currentLineFlowType = flowType
        
        if value:cellNext() == nil and self._currentLineFlowType ~= EFlowType.EFT_NONE and self._currentLineFlowType ~= nil then
            self._currentState:update(EControllerUpdate.ECUT_DOG_UP)
            
        end
        
    elseif (value == EFlowType.EFT_NONE or value == nil)  then
        
        if self._currentLineFlowType ~= EFlowType.EFT_NONE and self._currentLineFlowType ~= nil  then
            self._currentState:update(EControllerUpdate.ECUT_DOG_DOWN)
            
        end
        
        self._currentLineFlowType = value
        
    end
    
    
    
end


--
--Events
--

function ManagerGame.timerStart(self)
    self._timerGame = timer.performWithDelay(application.animation_duration * 4, 
    function() 
        self:onTimerTick()
    end, 
    self._timeLeft)
end

function ManagerGame.timerStop(self)
    if(self._timerGame ~= nil)then
        timer.cancel(self._timerGame)
        self._timerGame = nil
    end
end

function ManagerGame.onGameEnd(self)
    
    
    ManagerGameBase.onGameEnd(self)
end

function ManagerGame.onTimerTick(self)
    
    self._timeLeft = self._timeLeft - 1
    
    self._currentState:update(EControllerUpdate.ECUT_GAME_TIME)
end

--
-- Purchases
--

function ManagerGame.onBuyAddTime(self)
    
    self:timerStop()
    
    self._timeLeft = self._timeLeft + 15
    
    self._currentState:update(EControllerUpdate.ECUT_GAME_TIME)
    
    self:timerStart()
    
end


--
--Methods
--

function ManagerGame.init(self, params)
    ManagerGameBase.init(self, params)
    
    self._timeLeft  = self._currentLevel:timeLeft()
    
    self._cellsBytTypes = {}
    
    for rowIndex, row in ipairs(self._currentLevel:grid()) do
        for columnIndex, cell in ipairs(row) do
            
            local cells = self._cellsBytTypes[cell:type()]
            
            if(cells == nil)then
                cells = {}
            end
            
            table.insert(cells, cell)
            
            self._cellsBytTypes[cell:type()] = cells
        end
    end
end

function ManagerGame.registerCurrentState(self, currentState)
    ManagerGameBase.registerCurrentState(self, currentState)
    
    self:timerStart()
end

function ManagerGame.getCellsByType(self, type)
    local result = self._cellsBytTypes[type]
    
    assert(result ~= nil)
    
    return result
end

function ManagerGame.getCellsByTypeAndFlow(self, type, flowType)
    local result = {}
    
    for i, cell in ipairs(self:getCellsByType(type))do
        
        if(cell:flowType() == flowType)then
            table.insert(result, cell)
        end
        
    end
    
    return result
end

function ManagerGame.destroyLinesWithType(self, flowType)
    assert(flowType ~= nil)
    
    local cellsPoint = self:getCellsByTypeAndFlow(ECellType.ECT_FLOW_POINT, flowType)
    
    for i, cell in ipairs(cellsPoint)do
        cell:controller():update(EControllerUpdate.ECUT_EXCLUSION_FROM_LINE)
        
        self:destroyLine(cell)
    end
end

function ManagerGame.setCurrentCellCache(self, currentCell)
    
    local cacheCurrentCell = self:currentCell()
    self:setCurrentCell(currentCell)

    if cacheCurrentCell ~= nil then
        self:setCurrentCell(cacheCurrentCell)
    end
    
end

function ManagerGame.destroyLine(self, cellStart)
    local cellCurrent = cellStart
    
    -- установка текущей ячейки, если удаляется текущая линия
    
    if self._currentLineFlowType == cellStart:flowType() and self._currentLineFlowType ~= EFlowType.EFT_NONE 
    or self._currentLineFlowType == EFlowType.EFT_NONE then
    
        self:setCurrentCell(cellStart)
        
    else
        
        self:setCurrentCellCache(cellStart)
        
    end
    
    while(cellCurrent ~= nil) do
        local cellNext = cellCurrent:cellNext()
        
        cellCurrent:setCellNext(nil)
        
        cellCurrent = cellNext
    end
    
end

function ManagerGame.restoreLine(self, cellStart)
    local cellCurrent = cellStart
    local cellNext = cellCurrent
    
    while(cellNext ~= nil)  do
        
        if not cellNext:restoreState() then
            
            cellCurrent = cellNext
            break
            
        end
        cellCurrent = cellNext
        cellNext = cellCurrent:cellNext()
    end
    
    if cellCurrent ~= nil then
        
        self:setCurrentCellCache(cellCurrent)
        
    end
    
end

function ManagerGame.cacheStates(self)
    
    for rowIndex, row in ipairs(self._currentLevel:grid()) do
        for columnIndex, cell in ipairs(row) do
            cell:cacheState()
            
            if cell:type() == ECellType.ECT_BRIDGE then
                
                local flowAdditional = cell:flowAdditional()
                
                if flowAdditional ~= nil and flowAdditional:flowType() ~= EFlowType.EFT_NONE then
                    
                    flowAdditional:cacheState()
                    
                end
                
            end
            
        end
    end
    
    
    
end

function ManagerGame.destroyCache(self)
    
    for rowIndex, row in ipairs(self._currentLevel:grid()) do
        for columnIndex, cell in ipairs(row) do
            cell:destroyCache()
            
            if cell:type() == ECellType.ECT_BRIDGE then
                
                local flowAdditional = cell:flowAdditional()
                
                if flowAdditional ~= nil then
                    
                    flowAdditional:destroyCache()
                    
                end
                
            end
            
        end
    end
end

function ManagerGame.cleanup(self)
    
    self:timerStop()
    
    ManagerGameBase.cleanup(self)
end
