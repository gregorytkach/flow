require('game_flow.src.models.editor.GridCreator')

ManagerEditor = classWithSuper(ManagerGame, 'ManagerEditor')

--
-- properties
-- 

function ManagerEditor.gridCreator(self)
    
    return self._gridCreator
    
end

function ManagerEditor.grid(self)
    
    return self._gridEditor
    
end

function ManagerEditor.getDataGrid(self)
    return self._dataGrid
end

function ManagerEditor.getDataLines(self)
    return self._dataLines
end

--
-- events
--

function ManagerEditor.onAddFlow(self, value)
    
    assert(value ~= nil)
    
    local result = false
    
    local flowCountNew = self._gridCreator:flowCount() + value
    
    if flowCountNew <= tonumber(EFlowType.EFT_COUNT) and flowCountNew > 0  then
        self._gridCreator:addFlow(value)
        result = true
        
    end
    
    return result
end

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
    
    local functionDataLines = loadstring(dataLinesString)
    
    self._dataLines         = functionDataLines()
    
    print(self._dataLines )
    
    local dataGridString    = self._gridCreator:createFunctionDataGrid()
    print(dataGridString)
    
    local functionDataGrid  = loadstring(dataGridString)
    
    self._dataGrid          = functionDataGrid()
    
    print(self._dataGrid )
end

function ManagerEditor.init(self, params)
    
    local paramsCreator =
    {
        rows            = 5,
        columns         = 5,
        bridgesCount    = 2,
        barriersCount   = 3,
        flowCount       = 2,
    }
    
    self._gridCreator = GridCreator:new(paramsCreator)
    
    self:createGrid()
    
    
    
    ManagerGame.init(self, params)
    
end


function ManagerEditor.createGrid(self)
    local gridData = self._gridCreator:gridData()
    
    self._gridEditor = {}
    
    for rowIndex, rowData in ipairs(gridData)do
        
        local row = {}
        
        for columnIndex, cellData in ipairs(rowData)do
            
            local cell =  FactoryCells.getCell(cellData)
            
            if cellData.type == ECellType.ECT_BRIDGE and cellData.flowAdditional ~= nil then
                
                --not setter for _flowAdditional
                
                cell._flowAdditional = FactoryCells.getCell(cellData.flowAdditional)
                
            end
            
            table.insert(row, cell)
            
        end
        
        table.insert(self._gridEditor, row)
        
    end
end

function ManagerEditor.registerCurrentState(self, currentState)
    ManagerGame.registerCurrentState(self, currentState)
    
    self:timerStop()
end



