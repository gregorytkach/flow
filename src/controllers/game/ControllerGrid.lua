require('game_flow.src.controllers.game.ControllerCell')
require('game_flow.src.controllers.game.ControllerCellBarrier')
require('game_flow.src.controllers.game.ControllerCellBridge')
require('game_flow.src.controllers.game.ControllerCellEmpty')
require('game_flow.src.controllers.game.ControllerCellFlowPoint')
require('game_flow.src.controllers.game.ControllerDog')

require('game_flow.src.views.game.ViewGrid')


ControllerGrid = classWithSuper(Controller, 'ControllerGrid')

--
--Methods
--

function ControllerGrid.init(self)
    
    local paramsView =
    {
        controller = self
    }
    
    local paramsController =
    {
        view = ViewGrid:new(paramsView)
    }
    
    Controller.init(self, paramsController)
    
    self._cells = {}
    
    self._dogsMap       = {}
    self._dogsList      = {}
    
    self._managerGame = GameInfo:instance():managerGame() 
    
    
    local gridCells = self._managerGame:grid()
    
    local gridCellsViews = {}
    
    local isPair = true
    
    for indexRow, row in ipairs(gridCells)do
        
        local controllersRow    = {}
        local viewsRow          = {}
        
        for indexColumn, cell in ipairs(row)do
            
            if indexColumn > 1 then
                isPair = not isPair
            elseif (indexRow / 2) == math.floor(indexRow / 2) then
                isPair = false
            else
                isPair = true
            end
            
            local paramsController =
            {
                entry  = cell,
                isPair = isPair
            }
            
            local controllerCell 
            
            if(cell:type() == ECellType.ECT_EMPTY)then
                
                controllerCell = ControllerCellEmpty:new(paramsController)
                
            elseif(cell:type() == ECellType.ECT_FLOW_POINT)then
                
                controllerCell = ControllerCellFlowPoint:new(paramsController)
                
            elseif(cell:type() == ECellType.ECT_BARRIER)then
                
                controllerCell = ControllerCellBarrier:new(paramsController)
                
            elseif(cell:type() == ECellType.ECT_BRIDGE)then
                
                controllerCell = ControllerCellBridge:new(paramsController)
                
            else
                
                assert(false)
                
            end
            
            table.insert(controllersRow, controllerCell)
            table.insert(viewsRow, controllerCell:view())
            
        end
        
        table.insert(self._cells, controllersRow)
        table.insert(gridCellsViews, viewsRow)
        
    end
    
    self:view():setCellsViews(gridCellsViews)
    
    local flowTypes = {}
    for i, row in ipairs(self._cells)do
        for i, controllerCell in ipairs(row)do
            
            if(controllerCell:entry():type() == ECellType.ECT_FLOW_POINT)then
                controllerCell:view():sourceView():toFront()
                
                local flowType = controllerCell:entry():flowType()
                
                if table.indexOf(flowTypes, flowType) == nil then
                    
                    table.insert(flowTypes, flowType)
                    
                end
                
            end
            
        end
    end
    
    
    self:initControllersDogs(flowTypes)
    
    local firstCellView = gridCellsViews[1][1] 
    
    self._offsetYDog = -0.3 * firstCellView:realHeight()
end

function ControllerGrid.initControllersDogs(self, flowTypes)
    for i, flowType in  ipairs(flowTypes)do    
        local controllerDog = {}
        
        local dogParams = 
        {
            flow_type = flowType,
        }
        
        controllerDog = ControllerDog:new(dogParams)
        
        local sourceDog = controllerDog:view():sourceView()
        controllerDog:view():hide()
        
        self._view:sourceView():insert(sourceDog)
        
        self._dogsMap[flowType] = controllerDog
        
        table.insert(self._dogsList, controllerDog)
    end
end

function ControllerGrid.update(self, type)
    
    if(type == EControllerUpdateBase.ECUT_SCENE_ENTER)then
        
        for indexRow, row in ipairs(self._cells)do
            for indexColumn, cell in ipairs(row)do
                cell:update(type)
                cell:view():establishBounds()
                
                
            end
        end
        
        self:update(EControllerUpdate.ECUT_SET_DOGS)
        
        for flowType, controllerDog in pairs(self._dogsMap)do
            --            controllerDog:view():sourceView().isVisible = true
            controllerDog:view():show()
            
        end
    elseif(type == EControllerUpdate.ECUT_SET_DOGS)then
        
        for indexRow, row in ipairs(self._cells)do
            for indexColumn, cell in ipairs(row)do
                local entry = cell:entry()
                
                if entry:type() == ECellType.ECT_FLOW_POINT and entry:isStart() then
                    
                    local sourceCell = cell:view():sourceView()
                    
                    local controllerDog = self._dogsMap[entry:flowType()]
                    
                    controllerDog:view():setDogPosition(sourceCell)
                    controllerDog:setCurrentCell(entry)
                end
            end
        end
        
    elseif(type == EControllerUpdate.ECUT_SET_CURRENT_CELL)then
        
        local currentCell = self._managerGame:currentCell()
        
        local controllerDog = self._dogsMap[currentCell:flowType()]
        
        controllerDog:setCurrentCell(currentCell)
        
        local viewCell = currentCell:controller():view()
        controllerDog:view():setDogPosition(viewCell:sourceView())
        
        self:sortDogs()
        
    elseif(type ==  EControllerUpdate.ECUT_DOG_UP) or (type ==  EControllerUpdate.ECUT_DOG_DOWN)  then
        
        local controllerDog 
        
        if (type ==  EControllerUpdate.ECUT_DOG_UP) then
            
            local flowType = self._managerGame:currentLineFlowType()
            
            controllerDog = self._dogsMap[flowType]
            self._currentDog = controllerDog
            
        else
            
            controllerDog = self._currentDog
            
        end
        
        
        if controllerDog ~= nil then
            controllerDog:update(type)
        end
        
    else
        assert(false)
    end
    
end

function ControllerGrid.sortDogs(self)
    local dogsSorted = {}
    
    for i = 2, #self._dogsList, 1 do
        local value = self._dogsList[i]
        
        local indexJ = i - 1
        
        local valueToCompare = self._dogsList[indexJ]
        
        while indexJ >= 1 and valueToCompare._currentCell._y > value._currentCell._y do
            self._dogsList[indexJ + 1] = self._dogsList[indexJ]
            
            indexJ = indexJ - 1
            
            valueToCompare = self._dogsList[indexJ]
        end
        
        self._dogsList[indexJ + 1] = value
    end
    
    for _, controllerDog in ipairs(self._dogsList) do
        controllerDog._view._sourceView:toFront()
    end
    
end

function ControllerGrid.cleanup(self)
    
    for _, controllerDog in ipairs(self._dogsList)do
        controllerDog:cleanup()
    end
    
    self._currentDog = nil
    
    for indexRow, row in ipairs(self._cells)do
        for indexColumn, controllerCell in ipairs(row)do
            controllerCell:cleanup()
        end
    end
    
    self._cells = nil
    
    self._view:cleanup()
    self._view = nil
    
    self._managerGame = nil
    
    Controller.cleanup(self)
end


