LevelInfo = classWithSuper(LevelInfoBase, 'LevelInfo')

--
--Properties
--

function LevelInfo.gridClone(self)
    local result = {}
    
    result = self:createGrid(self._dataGrid)
    
    self:initNeighborsFor(result)
    
    return result
end

function LevelInfo.timeLeft(self)
    return self._timeLeft
end

--
--Methods
--


function LevelInfo.init(self)
    LevelInfoBase.init(self)
end

function LevelInfo.createNotPurchasedLinesFor(self, grid)
    assert(grid                 ~= nil)
    assert(self._dataLines      ~= nil)
    
    
    local result = {}
    
    for flowType, dataLine in pairs(self._dataLines)do
        
        assert(result[flowType] == nil, 'Line data already established')
        
        local cells = {}
        
        
        for i, positionCellCurrent in ipairs(dataLine)do
            assert(positionCellCurrent.x ~= nil)
            assert(positionCellCurrent.y ~= nil)
            
            local cell = grid[positionCellCurrent.y][positionCellCurrent.x]
            
            assert(cell ~= nil, 'Not found cell')
            
            
            if i > 1 then
                
                local positionCellPrev = dataLine[i - 1]
                if positionCellPrev.x == positionCellCurrent.x then
                    local step = 1
                    
                    if positionCellPrev.y > positionCellCurrent.y then
                        step = -1
                    end
                    
                    for j = positionCellPrev.y, positionCellCurrent.y , step do
                        local cell = grid[j][positionCellCurrent.x]
                        
                        if table.indexOf(cells, cell) == nil then
                            table.insert(cells, cell)
                        end
                    end
                    
                else
                    
                    local step = 1
                    
                    if positionCellPrev.x > positionCellCurrent.x then
                        step = -1
                    end
                    
                    for j = positionCellPrev.x, positionCellCurrent.x , step do
                        local cell = grid[positionCellCurrent.y][j]
                        
                        if cell:type() == ECellType.ECT_BRIDGE then
                            cell = cell:flowAdditional()
                        end
                        if table.indexOf(cells, cell) == nil then
                            table.insert(cells, cell)
                        end
                    end
                    
                end
                
                
                
            end
            
            if table.indexOf(cells, cell) == nil then
                table.insert(cells, cell)
            end
            
        end
        
        
        
        result[flowType] = cells
        
    end
    
    return result
end


function LevelInfo.deserialize(self, data)
    LevelInfoBase.deserialize(self, data)
    
    assert(data.data_grid ~= nil)
    assert(data.data_lines ~= nil)
    assert(data.time_left ~= nil)
    
    self._timeLeft  = tonumber(data.time_left)
    self._dataGrid  = data.data_grid 
    self._dataLines = data.data_lines
    
end

function LevelInfo.createGrid(self, dataGrid)
    assert(dataGrid ~= nil)
    
    local result = {}
    
    for rowIndex, rowData in ipairs(dataGrid)do
        
        local row = {}
        
        for columnIndex, cellData in ipairs(rowData)do
            
            local cellDataClone = getClone(cellData)
            
            local cell =  FactoryCells.getCell(cellDataClone)
            
            table.insert(row, cell)
            
        end
        
        table.insert(result, row)
        
    end
    
    return result
end



function LevelInfo.initNeighborsFor(self, grid)
    assert(grid ~= nil)
    
    for rowIndex, row in ipairs(grid)do
        
        for columnIndex, cell in ipairs(row)do
            
            if(rowIndex > 1)then
                local rowUp = grid[rowIndex - 1]
                local cellUp = rowUp[columnIndex]
                
                cell:setNeighborUp(cellUp)
            end
            
            if(rowIndex < #grid)then
                local rowDown = grid[rowIndex + 1]
                local cellDown = rowDown[columnIndex]
                
                cell:setNeighborDown(cellDown)
                
            end
            
            if(columnIndex > 1)then
                local cellLeft = row[columnIndex - 1]
                
                cell:setNeighborLeft(cellLeft)
            end
            
            if(columnIndex < #row)then
                local cellRight = row[columnIndex + 1]
                
                cell:setNeighborRight(cellRight)
            end
            
        end
    end
end
