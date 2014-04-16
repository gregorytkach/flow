require('game_flow.src.models.game.cells.base.ECellType')
require('game_flow.src.models.game.cells.EFlowType')

--todo: remove and move all functions to manager editor
GridCreator     = classWithSuper(Object, 'GridCreator')

--self._bridgesCountLeft      = 4
--self._flowTypesCount    = 4

--
--Properties
--

function GridCreator.gridData(self)
    return self._gridData
end

function GridCreator.flowCount(self)
    return self._flowCount
end

function GridCreator.rowsCount(self)
    return self._rowsCount
end

function GridCreator.bridgesCount(self)
    return self._bridgesCount
end

function GridCreator.barriersCount(self)
    return self._barriersCount
end

--
--Methods
--

function GridCreator.init(self, params)
    
    math.randomseed(os.time())
    
    assert(params.columns       ~= nil)
    assert(params.rows          ~= nil)
    assert(params.flowCount     ~= nil)
    
    assert(params.bridgesCount  ~= nil)
    assert(params.barriersCount ~= nil)
    
    
    self._counts        = {}
    
    
    self._flowCount = params.flowCount
    
    self._rowsCount             = params.rows
    self._columnsCount          = params.columns
    
    self._bridgesCountLeft      = params.bridgesCount
    self._barriersCountLeft     = params.barriersCount
    
    self._bridgesCount          = params.bridgesCount
    self._barriersCount         = params.barriersCount
    
    self:createGrid()
    
end

function GridCreator.addFlow(self, value)
    
    self._flowCount = self._flowCount + value
    self:createGrid()
    
end

function GridCreator.addSize(self, value)
    
    self._rowsCount = self._rowsCount + value
    self._columnsCount = self._rowsCount
    
    self:createGrid()
    
end

function GridCreator.addBridge(self, value)
    
    self._bridgesCount = self._bridgesCount + value
    self._bridgesCountLeft = self._bridgesCount
    self:createGrid()
    
end

function GridCreator.addBarrier(self, value)
    
    self._barriersCount = self._barriersCount + value
    self._barriersCountLeft = self._barriersCount
    self:createGrid()
    
end

function GridCreator.createGrid(self)
    self._gridData  = {}
    self._points    = {}
    
    self:createEmptyGrid()
    
    local row    = 1
    local column = 1
    
    local count = math.floor(self._rowsCount * self._columnsCount / self._flowCount)
    
    for i = 1, self._flowCount - 1, 1 do
        self._counts[i] = count
    end
    
    self._counts[self._flowCount] = self._rowsCount * self._columnsCount - (self._flowCount - 1) * count
    
    local row    = 1
    local column = 1
    local step   = 1
    
    local flow_type = 0
    count = 1
    
    local cellDataPrev = nil
    
    for i = 1, self._rowsCount * self._columnsCount, 1 do
        local cellData  = self._gridData[row][column] 
        cellData._prev = cellDataPrev
        
        if cellData._prev ~= nil then
            cellData._prev._next = cellData
        end
        
        cellData.flow_type = flow_type
        
        if count == self._counts[flow_type + 1] then
            count = 1
            cellData.type       = ECellType.ECT_FLOW_POINT
            self:addPoint(cellData)
            
            cellData  = nil
            flow_type = flow_type + 1
            
        elseif count == 1 then
            
            cellData.type       = ECellType.ECT_FLOW_POINT
            self:addPoint(cellData)
            count = count + 1
        else
            count = count + 1
        end
        
        if row == self._rowsCount and step == 1 then
            column = column + 1
            step = - 1
        elseif row == 1 and step == -1 then 
            column = column + 1
            step = 1
            
        else
            row = row + step
        end
        
        cellDataPrev = cellData
        
    end
    
end

function GridCreator.createEmptyGrid(self)
    for rowIndex = 1, self._rowsCount, 1 do
        
        local row = {}
        
        for columnIndex = 1, self._columnsCount, 1 do
            
            local cellData
            
            cellData =
            {
                type            = ECellType.ECT_EMPTY,
                flow_type       = EFlowType.EFT_NONE,
            } 
            
            table.insert(row, cellData)
            
            cellData.x = columnIndex
            cellData.y = rowIndex
            
        end
        
        table.insert(self._gridData, row)
        
    end
end

function GridCreator.tryAddNeighbour(self, neighbours, cell, flow_type)
    
    local result = cell.type ~= ECellType.ECT_BARRIER and cell.type ~= ECellType.ECT_BRIDGE and cell.flow_type ~= flow_type 
    
    if result then
        
        table.insert(neighbours, cell)
        
    end
    
    return result
    
end

function GridCreator.tryAddCanBridge(self, neighbour, cellAfterPotentialBridge, flow_type)
    
    if self._bridgesCountLeft > 0 
        and neighbour.type ~= ECellType.ECT_FLOW_POINT
        and cellAfterPotentialBridge.type ~= ECellType.ECT_BRIDGE
        and neighbour.type ~= ECellType.ECT_BRIDGE
        and cellAfterPotentialBridge.type ~= ECellType.ECT_BARRIER
        and cellAfterPotentialBridge.flow_type ~= flow_type 
        and cellAfterPotentialBridge.flow_type ~= neighbour.flow_type 
        
        then
        
        neighbour.cellAfterPotentialBridge = cellAfterPotentialBridge
        
    else
        
        neighbour.cellAfterPotentialBridge = nil
        
    end 
    
end


function GridCreator.getNeighbours(self, cell)
    
    local result = {}
    
    local cellAfterPotentialBridge = nil
    
    if cell.x > 1  then
        
        local neighbour = self._gridData[cell.y][cell.x - 1]
        
        if self:tryAddNeighbour(result, neighbour, cell.flow_type) 
            and cell.x - 1 > 1 and self._bridgesCountLeft > 0  
            then
            
            cellAfterPotentialBridge = self._gridData[cell.y][cell.x - 2]
            self:tryAddCanBridge(neighbour, cellAfterPotentialBridge, cell.flow_type)
            
        else
            neighbour.cellAfterPotentialBridge = nil
        end
        
    end
    
    if cell.x < self._columnsCount then
        
        local neighbour = self._gridData[cell.y][cell.x + 1]
        
        if self:tryAddNeighbour(result, neighbour, cell.flow_type) 
            and cell.x + 1 < self._columnsCount   
            then
            
            cellAfterPotentialBridge = self._gridData[cell.y][cell.x + 2]
            self:tryAddCanBridge(neighbour, cellAfterPotentialBridge, cell.flow_type)
        else
            
            neighbour.cellAfterPotentialBridge = nil
            
        end
        
    end
    
    if cell.y > 1 then
        
        local neighbour = self._gridData[cell.y - 1][cell.x]
        
        if self:tryAddNeighbour(result, neighbour, cell.flow_type)
            and cell.y - 1 > 1   
            then
            
            cellAfterPotentialBridge = self._gridData[cell.y - 2][cell.x]
            self:tryAddCanBridge(neighbour, cellAfterPotentialBridge, cell.flow_type)
            
        else
            
            neighbour.cellAfterPotentialBridge = nil
            
        end
        
    end
    
    if cell.y < self._rowsCount then
        
        local neighbour = self._gridData[cell.y + 1][cell.x]
        
        if self:tryAddNeighbour(result, neighbour, cell.flow_type)
            and cell.y + 1 < self._rowsCount  
            then
            
            cellAfterPotentialBridge = self._gridData[cell.y + 2][cell.x]
            self:tryAddCanBridge(neighbour, cellAfterPotentialBridge, cell.flow_type)
            
        else
            
            neighbour.cellAfterPotentialBridge = nil
            
        end
        
    end
    
    return result
end


function GridCreator.addPoint(self, point)
    local result = point.type ~= ECellType.ECT_BRIDGE
    
    if result then
        
        point.type = ECellType.ECT_FLOW_POINT
        
        if table.indexOf(self._points, point) == nil then
            
            table.insert(self._points, point)
            
        end
        
        point.is_start = false
        
    end
    
    return result
end

--returns all cells from current cell to start
function GridCreator.getCellsToStartFrom(self, cellData)
    
    local result = {}
    
    local currentCell = cellData
    
    while currentCell ~= nil do
        
        table.insert(result, currentCell)
        
        currentCell = currentCell._prev
        
    end
    
    return result
end

--returns all cells from current cell to end
function GridCreator.getCellsToEndFrom(self, cellData)
    
    local result = {}
    
    local currentCell = cellData
    
    while currentCell ~= nil do
        
        table.insert(result, currentCell)
        
        currentCell = currentCell._next
        
    end
    
    return result
end


function GridCreator.makeBridge(self, bridge, neighbour)
    
    bridge.type = ECellType.ECT_BRIDGE
    
    if math.abs(bridge.x - neighbour.x) == 1 then
        
        bridge.flowAdditional =
        {
            type          = ECellType.ECT_BRIDGE,
            flow_type      = neighbour.flow_type,
        } 
        
    else
        
        bridge.flowAdditional =
        {
            type          = ECellType.ECT_BRIDGE,
            flow_type      = bridge.flow_type,
            _next         = bridge._next,
            _prev         = bridge._prev,
        }
        
        if bridge._prev ~= nil then
            bridge._prev._next = bridge.flowAdditional
        end
        
        if bridge._next ~= nil then
            bridge._next._prev = bridge.flowAdditional
        end
        
        bridge.flow_type = neighbour.flow_type
        
    end
    
    bridge.flowAdditional.x = bridge.x
    bridge.flowAdditional.y = bridge.y
    
    self._bridgesCountLeft = self._bridgesCountLeft - 1
end

function GridCreator.tryMakeBarrier(self)
    
    local indexesCounts = {}
    
    for i = 1, #self._counts, 1 do
        
        local count = self._counts[i]
        
        if count > 3 then
            table.insert(indexesCounts, i)
        end
        
        
    end
    
    if #indexesCounts > 0 then
        
        local flow_type = indexesCounts[math.random(#indexesCounts)] - 1
        
        local points = {}
        
        for i = 1, #self._points, 1 do
            
            local point = self._points[i]
            if point.flow_type == flow_type then
                
                table.insert(points, point)
                
            end
            
        end
        
        local cell = points[math.random(#points)]
        
        local result = false
        
        local cellPrev = cell._prev
        
        if cellPrev ~= nil then
            
            result = self:addPoint(cellPrev)
            
            if result then
                
                cellPrev._next = nil 
                
            end
            
        end
        
        local cellNext = cell._next
        
        if cellNext ~= nil then
            
            result = self:addPoint(cellNext)
            
            if result then
                
                cellNext._prev = nil
                
            end
            
        end
        
        if result then
            
            cell.type = ECellType.ECT_BARRIER 
            table.remove(self._points, table.indexOf(self._points, cell))
            cell._prev = nil
            cell._next = nil
            
            self._counts[cell.flow_type + 1] = self._counts[cell.flow_type + 1] - 1
            cell.flow_type = EFlowType.EFT_NONE
            self._barriersCountLeft = self._barriersCountLeft - 1
            
        end
    end
    
end

function GridCreator.tryChange(self, flow_point, neighbours)
    
    local neighbour = nil 
    local point     = flow_point
    
    if math.random(2) == 1 then
        
        local neighboursCanBridge = {}
        
        for i = 1, #neighbours, 1 do
            
            neighbour = neighbours[i]
            if neighbour.cellAfterPotentialBridge ~= nil then
                table.insert(neighboursCanBridge, neighbour)
            end
            
        end
        
        if #neighboursCanBridge > 0 then
            neighbour = neighboursCanBridge[math.random(#neighboursCanBridge)]
        else
            neighbour = nil
        end
        
    end
    
    local bridge = nil
    
    if  neighbour == nil  then
        
        neighbour = neighbours[math.random(#neighbours)]
        
    else
        
        bridge      = neighbour
        neighbour   = neighbour.cellAfterPotentialBridge
        
    end
    
    local countPrev = 0
    
    
    local currentCell = neighbour
    
    while currentCell ~= nil do
        
        currentCell = currentCell._prev
        countPrev = countPrev + 1
        
    end
    
    local countNext = 0
    
    currentCell = neighbour
    
    while currentCell ~= nil do
        
        currentCell = currentCell._next
        countNext = countNext + 1
        
    end
    
    local isPrevChange  = false
    local isNextChange  = false
    local flow_type     = neighbour.flow_type
    
    local addCells 
    
    if math.random(2) == 1 then
        
        if self._counts[flow_type + 1] - countPrev >= 3 then
            
            isPrevChange = true
            
            if neighbour._next ~= nil  then
                
                isPrevChange = self:addPoint(neighbour._next)
                
                if isPrevChange then
                    neighbour._next._prev = nil
                end
                
            end
            
            if isPrevChange then
                addCells = self:getCellsToStartFrom(neighbour)
            end
            
            
        elseif self._counts[flow_type + 1] - countNext >= 3 then
            
            isNextChange = true
            
            if neighbour._prev ~= nil  then
                
                isNextChange = self:addPoint(neighbour._prev) 
                
                if isNextChange then
                    neighbour._prev._next = nil
                end
                
            end
            
            if isNextChange then
                addCells = self:getCellsToEndFrom(neighbour)
            end
            
        end
        
    else
        
        
        if self._counts[flow_type + 1] - countNext >= 3 then
            
            isNextChange = true
            
            if neighbour._prev ~= nil  then
                
                isNextChange = self:addPoint(neighbour._prev) 
                
                if isNextChange then
                    neighbour._prev._next = nil
                end
                
            end
            
            if isNextChange then
                addCells = self:getCellsToEndFrom(neighbour)
            end
            
        elseif self._counts[flow_type + 1] - countPrev >= 3 then
            
            isPrevChange = true
            
            if neighbour._next ~= nil  then
                
                isPrevChange = self:addPoint(neighbour._next)
                
                if isPrevChange then
                    neighbour._next._prev = nil
                end
                
            end
            
            if isPrevChange then
                addCells = self:getCellsToStartFrom(neighbour)
            end
            
        end
        
    end
    
    local result = isNextChange or isPrevChange
    
    if  result then
        
        if bridge ~= nil then
            
            self:makeBridge(bridge, neighbour)
            
            if bridge.flowAdditional.flow_type == flow_type then
                
                bridge = bridge.flowAdditional
                
            end
            
            table.insert(addCells, 1, bridge)
            
        end
        
        if point._prev ~= nil then
            
            local cellPrev = point
            
            for i = 1, #addCells, 1  do
                
                local cell = addCells[i]
                cell._prev = cellPrev
                cellPrev._next = cell
                cellPrev = cell
                cell.flow_type = point.flow_type
                
            end
            
            cellPrev._next = nil
            
            self:addPoint(cellPrev)
            
        elseif point._next ~= nil then
            
            local cellNext = point
            
            for i = 1, #addCells, 1  do 
                
                local cell = addCells[i]
                cell._next = cellNext
                cellNext._prev = cell
                cellNext = cell
                cell.flow_type = point.flow_type
            end
            
            cellNext._prev = nil
            
            self:addPoint(cellNext)
            
        end
        
        
        point.type = ECellType.ECT_EMPTY
        table.remove(self._points, table.indexOf(self._points, point))
        
        
        if isNextChange then
            
            self._counts[flow_type + 1] = self._counts[flow_type + 1] - countNext 
            self._counts[point.flow_type + 1] = self._counts[point.flow_type + 1] + #addCells 
            
        else
            
            
            self._counts[flow_type + 1] = self._counts[flow_type + 1] - countPrev 
            self._counts[point.flow_type + 1] = self._counts[point.flow_type + 1] + #addCells  
            
        end
        
    end 
    
    return result
    
end

function GridCreator.shuffle(self)
    
    local point = self._points[math.random(#self._points)]
    
    
    local neighbours = self:getNeighbours(point)
    
    if #neighbours > 0 then
        
        self:tryChange(point, neighbours) 
        
        if (self._barriersCountLeft > 0) then
            if math.random(3) == 1 then
                self:tryMakeBarrier()   
            end
        end
        
    end
    
end

function GridCreator.createDataLines(self)
    local result = {}
    
    for i = 0, EFlowType.EFT_COUNT - 1, 1 do
        
        local point = nil
        for j = 1, #self._points, 1 do
            
            point = self._points[j]
            if point.flow_type == i then
                break
            end
            
        end
        
        local cellsByType = nil
        
        if point._prev ~= nil then
            cellsByType = self:getCellsToStartFrom(point) 
        else
            cellsByType = self:getCellsToEndFrom(point) 
        end
        
        for j = #cellsByType, 1, -1 do
            
            local cell = cellsByType[j]
            local needCell = cell.type == ECellType.ECT_FLOW_POINT 
            
            if not needCell then
                
                needCell = cell._prev.x ~= cell._next.x and cell._prev.y ~= cell._next.y 
            end
            
            if not needCell then
                table.remove(cellsByType, j)
            end
            
        end
        
        for i = 1, #cellsByType, 1 do
            local cell = cellsByType[i]
            table.insert(result, cell)
        end
        
    end
    
    return result
end

function GridCreator.createFunctionDataLines(self)
    local functionName = 'getDataLines_'..os.time()..'()'
    
    local result = 'local function '..functionName..'\n'..
    
    '\tlocal result =\n'
    
    local dataBaseCells = self:createDataLines()
    
    print(dataBaseCells)
    
    result = result..'\t{\n'
    
    local j = 1
    for i = 0, EFlowType.EFT_COUNT - 1, 1 do
        
        local needAddInfoAboutFlowType = false
        local infoAboutFlowType = ""
        
        
        local flowTypeStr = EFlowType['EFT_'..i]
        
        infoAboutFlowType = infoAboutFlowType..'\t\t'..'['..flowTypeStr..'] =\n'
        infoAboutFlowType = infoAboutFlowType..'\t\t{\n'
        
        local cell = dataBaseCells[j]
        
        while cell.flow_type == i do
            
            needAddInfoAboutFlowType = true
            
            infoAboutFlowType = infoAboutFlowType..'\t\t\t{\n'
            
            infoAboutFlowType = infoAboutFlowType..'\t\t\t\tx = '..cell.x..',\n'
            infoAboutFlowType = infoAboutFlowType..'\t\t\t\ty = '..cell.y..',\n'
            infoAboutFlowType = infoAboutFlowType..'\t\t\t}'
            
            if j < #dataBaseCells then
                j = j + 1
                cell = dataBaseCells[j]
                
                if cell.flow_type ~= i then
                    infoAboutFlowType = infoAboutFlowType..'\n' 
                    
                else
                    infoAboutFlowType = infoAboutFlowType..',\n' 
                end
            else
                infoAboutFlowType = infoAboutFlowType..'\n' 
                break
            end
        end
        
        
        if i == EFlowType.EFT_COUNT - 1 then
            
            infoAboutFlowType = infoAboutFlowType..'\t\t}\n'
            
        else
            
            infoAboutFlowType = infoAboutFlowType..'\t\t},\n'
            
        end
        
        if(needAddInfoAboutFlowType)then
            result = result..infoAboutFlowType
        end
        
    end
    
    result = result..'\t}\n'..
    'return result\n'..
    'end'
    
    result = result..'\n'..'return '..functionName
    
    return result
    
end

function GridCreator.createFunctionDataGrid(self)
    
    local functionName = 'getDataGrid_'..os.time()..'()'
    
    local result = 'local function '..functionName..'\n'..
    
    '\tlocal result = {}\n\n'..
    
    '\tfor rowIndex = 1, '..self._rowsCount..', 1 do\n\n'..
    
    '\t\tlocal row = {}\n\n'..
    
    '\t\tfor columnIndex = 1, '..self._columnsCount..', 1 do\n\n'..
    
    '\t\t\tlocal cellData\n\n'
    
    local elsePrefix = ''
    
    local tabsCellData = '\t\t\t\t'
    
    for rowIndex = 1, self._rowsCount, 1 do
        for columnIndex = 1, self._columnsCount, 1 do
            
            local cellData = self._gridData[rowIndex][columnIndex]
            if cellData.type ~= ECellType.ECT_EMPTY then
                
                result = result..'\t\t\t'..elsePrefix..'if(rowIndex == '..rowIndex..' and columnIndex == '..columnIndex..')then\n'..
                tabsCellData..'cellData = \n'..
                tabsCellData..'{\n'..
                
                tabsCellData..'\ttype = ECellType.'..cellData.type..',\n'
                
                local flowType = EFlowType.EFT_NONE
                
                if(cellData.type == ECellType.ECT_FLOW_POINT)then
                    flowType = cellData.flow_type
                    local is_start = 'false'
                    
                    if cellData.is_start then
                        is_start = 'true'
                    end
                    
                    result = result..tabsCellData..'\tis_start = '..is_start..',\n'
                    
                end
                
                result = result..tabsCellData..'\tflow_type = EFlowType.EFT_'..flowType..',\n'..
                
                tabsCellData..'}\n'
                
                elsePrefix = 'else'
                
            end
            
        end
    end
    
    result = result..'\t\t\telse\n'..
    tabsCellData..'cellData = \n'..
    tabsCellData..'{\n'..
    
    tabsCellData..'\ttype = ECellType.ECT_EMPTY,\n'..
    tabsCellData..'\tflow_type = EFlowType.EFT_NONE,\n'..
    tabsCellData..'}\n'..
    '\t\t\tend\n\n'..
    
    '\t\t\tcellData.x = columnIndex\n'..
    '\t\t\tcellData.y = rowIndex\n\n'..
    '\t\t\ttable.insert(row, cellData)\n'..
    '\t\tend\n\n'..
    
    '\t\ttable.insert(result, row)\n'..
    '\tend\n\n'..
    
    '\treturn result\n\n'..
    'end'
    
   result = result..'\n'..'return '..functionName
    
    return result
end

function GridCreator.shuffles(self, count)
    
    for j = 1, count, 1 do
        
        self:shuffle()
        
    end
    
    local flowPoints = {}
    
    for r, row in ipairs(self._gridData)do
        
        for c, cell in ipairs(row)do
            
            if(cell.type == ECellType.ECT_FLOW_POINT)then
                
                cell.is_start = flowPoints[cell.flow_type] == nil
                
                if(cell.is_start)then
                    flowPoints[cell.flow_type] = cell
                end
                
            end
            
        end
    end
    
end