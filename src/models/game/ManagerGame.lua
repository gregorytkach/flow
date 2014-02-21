
require('game_flow.src.models.game.cells.EFlowType')

require('game_flow.src.models.game.cells.base.CellBase')
require('game_flow.src.models.game.cells.base.FactoryCells')
require('game_flow.src.models.game.cells.bridge.CellBridge')
require('game_flow.src.models.game.cells.barrier.CellBarrier')
require('game_flow.src.models.game.cells.empty.CellEmpty')
require('game_flow.src.models.game.cells.flowPoint.CellFlowPoint')


ManagerGame = classWithSuper(ManagerGameBase, 'ManagerGame') 

function ManagerGame.grid(self)
    
    return self._currentLevel:grid()
    
end

--
--Properties
--

function ManagerGame.isPlayerWin(self)
    return self._isPlayerWin
end

function ManagerGame.currentCell(self)
    
    return self._currentCell
    
end

function ManagerGame.setCurrentCell(self, cell)
    
    
    self._currentCell = cell
    if cell ~= nil  then
        
        self._currentState:update(EControllerUpdate.ECUT_SET_CURRENT_CELL)
        
    end
    
end


function ManagerGame.timeLeft(self)
    return self._timeLeft
end

function ManagerGame.currentLineFlowType(self)
    return self._currentLineFlowType
end

function ManagerGame.setCurrentLineFlowType(self, value)
    
    if value ~= EFlowType.EFT_NONE and value ~= nil   then
        
        self._currentLineFlowType = value:flowType()
        
    elseif (value == EFlowType.EFT_NONE or value == nil)  then
        
        self._currentLineFlowType = value
        
    end
    
    
    
end


--
--Events
--

function ManagerGame.onGameEnd(self)
    
    
    ManagerGameBase.onGameEnd(self)
end

function ManagerGame.onPlayerWin(self)
    self._isPlayerWin = true
    
    self:onGameEnd()
end

function ManagerGame.onPlayerLose(self)
    self._isPlayerWin = false
    
    local playerCurrent = GameInfo:instance():managerPlayers():playerCurrent()
    
    playerCurrent:setEnergy(playerCurrent:energy() - 1)
    
    self:onGameEnd()
end


function ManagerGame.onTimerTick(self)
    
    self._timeLeft = self._timeLeft - 1
    
    self._currentState:update(EControllerUpdate.ECUT_GAME_TIME)
    
    if(self._timeLeft == 0)then
        self:onPlayerLose()
    end
end

--
-- Purchases
--

function ManagerGame.onBuyAddTime(self)
    
    --todo: implement
--    self:timerStop()
--    
--    self._timeLeft = self._timeLeft + 15
--    
--    self._currentState:update(EControllerUpdate.ECUT_GAME_TIME)
--    
--    self:timerStart()
    
    self:onPlayerLose()
    
end


--
--Methods
--

function ManagerGame.init(self, params)
    ManagerGameBase.init(self, params)
    
    self._isPlayerWin   = false
    self._timeLeft      = self._currentLevel:timeLeft()
    
    self._cellsBytTypes = {}
    
    for rowIndex, row in ipairs(self:grid()) do
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
    
    local cacheCurrentCell = self._currentCell
    self:setCurrentCell(currentCell)
    
    self._setCurrentCell = cacheCurrentCell
    self:setCurrentCell(cacheCurrentCell)
    
    
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
