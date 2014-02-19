LevelInfo = classWithSuper(LevelInfoBase, 'LevelInfo')

--
--Properties
--

function LevelInfo.grid(self)
    return self._grid
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

function LevelInfo.deserialize(self, data)
    LevelInfoBase.deserialize(self, data)
    
    assert(data.grid_data ~= nil)
    assert(data.time_left ~= nil)
    
    self._timeLeft = data.time_left
    
    self._grid = {}
    
    
    for rowIndex, rowData in ipairs(data.grid_data)do
        
        local row = {}
        
        for columnIndex, cellData in ipairs(rowData)do
            
            local cell =  FactoryCells.getCell(cellData)
            
            table.insert(row, cell)
            
        end
        
        table.insert(self._grid, row)
        
    end
    
    
    --fill neighbors
    
    for rowIndex, row in ipairs(self._grid)do
        
        for columnIndex, cell in ipairs(row)do
            
            if(rowIndex > 1)then
                local rowUp = self._grid[rowIndex - 1]
                local cellUp = rowUp[columnIndex]
                
                cell:setNeighborUp(cellUp)
            end
            
            if(rowIndex < #self._grid)then
                local rowDown = self._grid[rowIndex + 1]
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
