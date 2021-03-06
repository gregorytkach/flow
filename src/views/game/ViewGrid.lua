ViewGrid = classWithSuper(ViewBase, 'ViewGrid')

--
--Properties
--
function ViewGrid.setCellsViews(self, value)
    assert(value ~= nil)
    
    self._cells = value
    
    for indexRow, row in ipairs(self._cells)do
        
        for indexColumn, cellView in ipairs(row)do
            self._sourceView:insert(cellView:sourceView()) 
        end
        
    end
end


--
--Methods
--

function ViewGrid.init(self, params)
    ViewBase.init(self, params)
    
    self._sourceView = display.newGroup()
    
end

function ViewGrid.placeViews(self)
    ViewBase.placeViews(self)
    
    local cellStandart = nil
    
    for _, row in ipairs(self._cells) do 
        
        for _, cell in ipairs(row)  do 
            
            local isCellWithView = cell:isA(ViewCellWithView)
            local isCellBridge   = cell:isA(ViewCellBridge)
            
            if(not isCellBridge and not isCellWithView) then
                cellStandart = cell
            end
            
            if(cellStandart ~= nil)then
                break
            end
            
        end
        
        if(cellStandart ~= nil)then
            break
        end
    end
    
    local cellWidth  = cellStandart:realWidth()      
    local cellHeight = cellStandart:realHeight()
    
    local offsetX = 0
    local offsetY = 0
    
    local startX = -((#self._cells[1] - 1) * offsetX + cellWidth  * #self._cells[1])    / 2 + cellWidth  / 2
    local startY = -((#self._cells    - 1) * offsetY + cellHeight * #self._cells)       / 2 + cellHeight / 2
    
    local currentX = startX
    local currentY = startY
    
    for indexRow, row in ipairs(self._cells)do
        
        for indexColumn, cellView in ipairs(row)do
            cellView:sourceView().x = currentX
            cellView:sourceView().y = currentY
            
            cellView:placeViews()
            
            currentX = currentX + cellWidth + offsetX
        end
        
        currentX = startX
        currentY = currentY + cellHeight  + offsetY
    end
end

