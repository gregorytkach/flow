ManagerEditor = classWithSuper(ManagerGame, 'ManagerEditor')

--
-- properties
-- 

function ManagerEditor.grid(self)
    
    return self._grid
    
end

--
-- methods
--

function ManagerEditor.shuffle(self, count)
    
    self._gridCreator:shuffles(count)
    print(self._gridCreator:getDataLines_timestamp())
    
end

function ManagerEditor.init(self, params)

    local paramsCreator =
    {
        rows            = 5,
        columns         = 5,
        bridgesCount    = 2,
        barriersCount   = 3

    }
        
    self._gridCreator = GridCreator:new(paramsCreator)
    
    
    local gridData = self._gridCreator:gridData()
    
    self._grid = {}
    
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
        
        table.insert(self._grid, row)
        
    end
    
    print(self._gridCreator:createFunctionGridData())
    ManagerGame.init(self, params)
    
end

function ManagerEditor.registerCurrentState(self, currentState)
    ManagerGame.registerCurrentState(self, currentState)
    
    self:timerStop()
end



