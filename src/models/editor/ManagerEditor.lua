require('game_flow.src.models.editor.GridCreator')

ManagerEditor = classWithSuper(ManagerGame, 'ManagerEditor')

--
-- properties
-- 

function ManagerEditor.gridCreator(self)
    return self._gridCreator
end

function ManagerEditor.getDataGrid(self)
    return self._dataGrid
end

function ManagerEditor.getDataLines(self)
    return self._dataLines
end

function ManagerEditor.flowCount(self)
    return self._flowCount
end

function ManagerEditor.setFlowCount(self, value)
    
    assert(value ~= nil)
    
    if(self._flowCount == value)then
        return
    end
    
    self._flowCount = value
    
    --todo: remove
    self._gridCreator._flowCount = value
    
    self._gridCreator:createGrid()
    
end

function ManagerEditor.gridSize(self)
    return self._gridSize
end


function ManagerEditor.bridgesCount(self)
    return self._bridgesCount
end

function ManagerEditor.barriersCount(self)
    return self._barriersCount
end

--
-- events
--

function ManagerEditor.onAddSize(self, value)
    
    assert(value ~= nil)
    
    local result = false
    
    local rowsCountNew = self._gridCreator:rowsCount() + value
    
    if rowsCountNew <= Constants.MAX_GRID_SIZE and rowsCountNew >= Constants.MIN_GRID_SIZE then
        self._gridCreator:addSize(value)
        result = true
    end
    
    return result
end

function ManagerEditor.onAddBridge(self, value)
    
    assert(value ~= nil)
    
    local result = false
    
    local bridgesCountNew = self._gridCreator:bridgesCount() + value
    
    if bridgesCountNew <= Constants.MAX_COUNT_BRIDGES and bridgesCountNew >= 0 then
        self._gridCreator:addBridge(value)
        result = true
    end
    
    return result
end

function ManagerEditor.onAddBarrier(self, value)
    
    assert(value ~= nil)
    
    local result = false
    
    local barriersCountNew = self._gridCreator:bridgesCount() + value
    
    if barriersCountNew <= Constants.MAX_COUNT_BARRIERS and barriersCountNew >= 0 then
        self._gridCreator:addBarrier(value)
        result = true
    end
    
    return result
end

--
-- methods
--

function ManagerEditor.shuffle(self, count)
    
    self._gridCreator:shuffles(count)
    
    local dataLinesString   = self._gridCreator:createFunctionDataLines()
    print(dataLinesString)
    
    self._dataLines         = self._gridCreator:createFormatDataLines()
    
    local dataGridString    = self._gridCreator:createFunctionDataGrid()
    print(dataGridString)
    
    self._dataGrid          = self._gridCreator:gridDataFormat()
    
    local json              = require('json')
    
    print(json.encode(self._dataLines))
    print(json.encode(self._dataGrid))
    
end

function ManagerEditor.init(self, params)
    
    self._gridSize              = 5
    
    self._bridgesCount          = 2
    self._bridgesCountLeft      = self._bridgesCount
    
    self._barriersCount         = 3
    self._barriersCountLeft     = self._barriersCount
    
    self._flowCount             = 2
    
    self._gridCreator = GridCreator:new()
    
    math.randomseed(os.time())
    
    self:recreateGridData()
    
    self._grid = self:createGrid()
    
    --    ManagerGame.init(self, params)
    
end

function ManagerEditor.recreateGridData(self)
    self._cellsCounter  = self:createCellsCounter()
    self._gridData      = self:createGridData()
end

function ManagerEditor.registerCurrentState(self, currentState)
    ManagerGame.registerCurrentState(self, currentState)
    
    self:timerStop()
end

function ManagerEditor.createCellsCounter(self)
    local result = {}
    
    --represents min cells count in line
    local cellsInLine = math.floor(self._gridSize * self._gridSize / self._flowCount)
    
    for i = 0, self._flowCount - 2, 1 do
        local flowType = EFlowType['EFT_'..i]
        
        result[flowType] = cellsInLine
    end
    
    local flowTypeLast = EFlowType['EFT_'..(self._flowCount - 1)]
    
    result[flowTypeLast] = self._gridSize * self._gridSize - (self._flowCount - 1) * cellsInLine
    
    return result
end

function ManagerEditor.createGridData(self)
    local result        = self:createEmptyGrid()
    
    self._flowPoints    = {}
    
    local row                   = 1
    local column                = 1
    local step                  = 1
    
    local flowTypeNumber        = 0
    local cellsInCurrentLine    = 1
    
    local cellDataPrev = nil
    
    for i = 1, self._gridSize * self._gridSize, 1 do
        
        local flowType      = EFlowType['EFT_'..flowTypeNumber]
        local cellsCountMax = self._cellsCounter[flowType]
        
        local cellData      = result[row][column]
        
        print(column..":"..row)
        
        if cellDataPrev ~= nil then
            cellDataPrev._next = cellData
            
            cellData._prev = cellDataPrev
        end
        
        cellData.flow_type = flowType
        
        --last cell in line must be flow point
        if cellsInCurrentLine == cellsCountMax then
            cellData.type       = ECellType.ECT_FLOW_POINT
            
            cellsInCurrentLine  = 1
            
            flowTypeNumber      = flowTypeNumber + 1
            
            self:addPoint(cellData)
            
            cellData  = nil
            
        elseif cellsInCurrentLine == 1 then --first cell must be a flow point
            
            cellData.type       = ECellType.ECT_FLOW_POINT
            
            cellsInCurrentLine = cellsInCurrentLine + 1
            
            self:addPoint(cellData)
        else
            cellsInCurrentLine = cellsInCurrentLine + 1
        end
        
        cellDataPrev = cellData
        
        if row == self._gridSize and step == 1 then
            column = column + 1
            step = - 1
        elseif row == 1 and step == -1 then 
            column = column + 1
            step = 1
        else
            row = row + step
        end
        
    end
    
    return result
end

function ManagerEditor.createEmptyGrid(self)
    local result = {}
    
    for rowIndex = 1, self._gridSize, 1 do
        
        local rows = {}
        
        for columnIndex = 1, self._gridSize, 1 do
            
            local cellData =
            {
                type            = ECellType.ECT_EMPTY,
                flow_type       = EFlowType.EFT_NONE,
                x               = columnIndex,
                y               = rowIndex
            } 
            
            table.insert(rows, cellData)
        end
        
        table.insert(result, rows)
    end
    
    return result
end


--todo: review
function ManagerEditor.addPoint(self, point)
    local result = point.type ~= ECellType.ECT_BRIDGE
    
    if result then
        
        point.type = ECellType.ECT_FLOW_POINT
        
        if table.indexOf(self._flowPoints, point) == nil then
            
            table.insert(self._flowPoints, point)
            
        end
        
        point.is_start = false
        
    end
    
    return result
end

function ManagerEditor.createGrid(self)
    local result = {}
    
    for _, rowData in ipairs(self._gridData)do
        
        local row = {}
        
        for _, cellData in ipairs(rowData)do
            
            local cell =  FactoryCells.getCell(cellData)
            
            if  cellData.type == ECellType.ECT_BRIDGE 
                and cellData.flowAdditional ~= nil then
                
                --not setter for _flowAdditional
                cell._flowAdditional = FactoryCells.getCell(cellData.flowAdditional)
            end
            
            table.insert(row, cell)
            
        end
        
        table.insert(result, row)
        
    end
    
    return result
end

