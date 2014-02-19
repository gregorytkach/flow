require('game_flow.src.models.game.cells.base.ECellType')
require('game_flow.src.models.game.cells.EFlowType')

GridCreator     = classWithSuper(Object, 'GridCreator')

--self._bridgesCountLeft      = 4
--self._flowTypesCount    = 4

--
--Properties
--

function GridCreator.gridData(self)
    return self._gridData
end

--
--Methods
--

function GridCreator.init(self, params)
    
    math.randomseed(os.time())
    
    assert(params.columns       ~= nil)
    assert(params.rows          ~= nil)
    
    assert(params.bridgesCount  ~= nil)
    assert(params.barriersCount ~= nil)
    
    
    self._counts        = {}
    self._points        = {}
    
    self._rowsCount             = params.rows
    self._columnsCount          = params.columns
    
    self._bridgesCountLeft      = params.bridgesCount
    self._barriersCountLeft     = params.barriersCount
    
    self._gridData  = {}
    
    self:createEmptyGrid()
    
    self:initFlowLines()
    
    self._counts[4] = self._counts[4] * 2
    
    --todo: rewrite
    for rowIndex = 1, 5, 1 do
        local cellData          = self._gridData[rowIndex][self._columnsCount]
        cellData.flow_type      = EFlowType.EFT_3
    end
    
    for columnIndex = 1, self._columnsCount - 1, 1 do
        
        for rowIndex = 1, self._rowsCount - 1, 1 do
            
            local cellData = self._gridData[rowIndex][columnIndex] 
            cellData._next = self._gridData[rowIndex + 1][columnIndex]
            
        end
        
    end
    
    for columnIndex = 1, self._columnsCount - 1, 1 do
        
        for rowIndex = 2, self._rowsCount, 1 do
            
            local cellData = self._gridData[rowIndex][columnIndex] 
            cellData._prev = self._gridData[rowIndex - 1][columnIndex]
            
        end
        
    end
    
    local cellData = self._gridData[self._rowsCount][self._columnsCount - 1] 
    cellData._next = self._gridData[self._rowsCount][self._columnsCount]
    
    cellData        = self._gridData[self._rowsCount][self._columnsCount]
    cellData._prev  = self._gridData[self._rowsCount][self._columnsCount - 1]
    
    for rowIndex = self._rowsCount - 1, 1, -1 do
        
        local cellData = self._gridData[rowIndex + 1][self._columnsCount] 
        cellData._next = self._gridData[rowIndex][self._columnsCount]
        
    end
    
    for rowIndex = self._rowsCount, 2, -1 do
        
        local cellData = self._gridData[rowIndex - 1][self._columnsCount] 
        cellData._prev = self._gridData[rowIndex][self._columnsCount]
        
    end
    
end

function GridCreator.initFlowLines(self)
    for columnIndex = 1, self._columnsCount - 1, 1 do
        
        local cellData      = self._gridData[1][columnIndex]
        cellData.type       = ECellType.ECT_FLOW_POINT
        
        table.insert(self._points, cellData)
        
        local flow_type = columnIndex - 1
        
        for rowIndex = 1, self._rowsCount, 1 do
            
            cellData = self._gridData[rowIndex][columnIndex]
            cellData.flow_type   = flow_type
            
        end
        
        if columnIndex == self._columnsCount - 1 then
            cellData      = self._gridData[1][self._columnsCount]
        else
            cellData      = self._gridData[self._rowsCount][columnIndex]
        end
        
        cellData.type       = ECellType.ECT_FLOW_POINT
        table.insert(self._points, cellData)
        
        self._counts[flow_type + 1] = self._rowsCount
        
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
        
        --print(#addCells)
        
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
    
    print(#self._points)
    
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

function GridCreator.shuffles(self, count)
    
    for j = 1, count, 1 do
        
        self:shuffle()
        
    end
    
    for i = 1, #self._points, 1 do
        
        local point = self._points[i]
        point.is_start = false
        
    end
end