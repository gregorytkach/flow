require('game_flow.src.controllers.game.ControllerCell')
require('game_flow.src.controllers.game.ControllerCellBarrier')
require('game_flow.src.controllers.game.ControllerCellBridge')
require('game_flow.src.controllers.game.ControllerCellEmpty')
require('game_flow.src.controllers.game.ControllerCellFlowPoint')
require('game_flow.src.controllers.game.ControllerDog')

require('game_flow.src.views.game.ViewGrid')


ControllerGrid = classWithSuper(Controller, 'ControllerGrid')

--
--Properties
--

function ControllerGrid.updateType(self)
    return self._updateType
end

function ControllerGrid.dogByType(self, flowType)
    assert(flowType ~= nil)
    
    return self._dogsMap[flowType]
    
end

--
--Methods
--

function ControllerGrid.init(self)
    
    
    
    
    
    self._dogsMap       = {}
    self._dogsList      = {}
    
    self._managerGame = GameInfo:instance():managerGame() 
    
    self:createCells()
    
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

function ControllerGrid.update(self, type, flowType)
    
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
                if entry:type() == ECellType.ECT_FLOW_POINT and not entry:isStart() and entry:isPurchased() then
                    
                    cell:onInHouse(true)
                    local controllerDog = self._dogsMap[entry:flowType()]
                    controllerDog:view():sourceView().isVisible = false
                    
                elseif entry:type() == ECellType.ECT_FLOW_POINT and entry:isStart() and not entry:isPurchased() then
                    
                    local controllerDog = self._dogsMap[entry:flowType()]
                    
                    controllerDog:setCurrentCell(entry)
                    
                end
            end
        end
    elseif(type == EControllerUpdate.ECUT_GRID)then
        local currentCell = self._managerGame:currentCell()
        
        
        for indexRow, row in ipairs(self._cells)do
            for indexColumn, cell in ipairs(row)do
                local entry = cell:entry()
              
                local controllerDog = self._dogsMap[entry:flowType()]
                
                if entry:type() == ECellType.ECT_FLOW_POINT and entry:isStart() and not entry:isPurchased() and entry:cellNext() == nil and controllerDog:currentCell():cellPrevCached() == entry  then
                    controllerDog:setCurrentCell(entry)
               
                    
                elseif (entry:type() == ECellType.ECT_EMPTY or entry:type() == ECellType.ECT_BRIDGE)  and entry:cellPrev() ~= nil and entry:cellNext() == nil   then
                    
                    controllerDog:setCurrentCell(entry)
                
                elseif entry:type() == ECellType.ECT_FLOW_POINT and (entry:cellPrev() ~= nil or (entry:cellNext() == nil and entry:cellNextCached() ~=  nil) or entry == currentCell )then
                    
                    controllerDog:setCurrentCell(entry)
                end
                
                if entry:type() == ECellType.ECT_BRIDGE and (currentCell == entry:flowAdditional() or (entry:flowAdditional():cellPrev() ~= nil and entry:flowAdditional():cellNext() == nil)) then
                    
                    controllerDog = self._dogsMap[entry:flowAdditional():flowType()]
                    controllerDog:setCurrentCell(entry:flowAdditional()) 
                end
            end
        end
        
        self:sortDogs()
        
        
    elseif((type ==  EControllerUpdate.ECUT_DOG_UP) or (type ==  EControllerUpdate.ECUT_DOG_DOWN)) 
        and flowType ~= nil and flowType ~= EFlowType.EFT_NONE
        then
        
        
        local controllerDog = nil
        local currentCell          = self._managerGame:currentCell()
        local currentDogByFlowType = self._dogsMap[flowType]
        local currentCellByDog     = currentDogByFlowType:currentCell()
        
        local currentUpdateType = self._updateType
        self._updateType        = type
        
        if (type ==  EControllerUpdate.ECUT_DOG_UP) then
            
            local currentLineFlowType = self._managerGame:currentLineFlowType()
            
            if flowType == currentLineFlowType or currentLineFlowType == EFlowType.EFT_NONE or currentLineFlowType == nil then
                controllerDog = self._dogsMap[flowType]
                self._currentDog = controllerDog
            end
            
            
            if currentCellByDog ~= nil and currentCellByDog:type() == ECellType.ECT_FLOW_POINT and not currentCellByDog:isStart() then
                currentDogByFlowType:view():setInHouse(false)
                currentCellByDog:controller():onInHouse(false)
                currentDogByFlowType._cell = nil
                
            end
            
        else
            
            local currentLineFlowType = self._managerGame:currentLineFlowType()
            
            if flowType == currentLineFlowType or currentLineFlowType == EFlowType.EFT_NONE or currentLineFlowType == nil then
                controllerDog = self._currentDog
            end
                
            if currentCellByDog ~= nil and currentCellByDog:type() == ECellType.ECT_FLOW_POINT and not currentCellByDog:isStart() then
                
                currentDogByFlowType:view():setInHouse(true)
                currentCellByDog:controller():onInHouse(true)
                
                currentDogByFlowType._cell = currentCellByDog
                
            else
                
                currentDogByFlowType:view():setInHouse(false)
                
                if  currentDogByFlowType._cell ~= nil then
                     currentDogByFlowType._cell:controller():onInHouse(false)
                     currentDogByFlowType._cell = nil
                end
                
            end
          
        end
        
        if type ~= currentUpdateType then
            currentDogByFlowType:update(type)
        end
        
    elseif (type ==  EControllerUpdate.ECUT_DOG_DOWN) then
        local controllerDog = self._currentDog
        
        local currentCellByDog = nil
        
        if controllerDog ~= nil then  
            currentCellByDog = self._currentDog:currentCell()
        end
        
        if currentCellByDog ~= nil and currentCellByDog:type() == ECellType.ECT_FLOW_POINT and not currentCellByDog:isStart() then
                
                controllerDog:view():setInHouse(true)
                currentCellByDog:controller():onInHouse(true)
                
                controllerDog._cell = currentCellByDog
        end
        
        if controllerDog ~= nil and type ~= self._updateType then
            controllerDog:update(type)
            self._updateType = type
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

function ControllerGrid.createCells(self)
    
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
    
    local firstCellView = gridCellsViews[1][1] 
    
    self._offsetYDog = -0.3 * firstCellView:realHeight()
    
end

function ControllerGrid.removeCells(self)
    for indexRow, row in ipairs(self._cells)do
        for indexColumn, controllerCell in ipairs(row)do
            controllerCell:cleanup()
        end
    end
    
    self._cells = nil
    
    self._view:cleanup()
    self._view = nil
end

function ControllerGrid.cleanup(self)
    
    for _, controllerDog in ipairs(self._dogsList)do
        controllerDog:cleanup()
    end
    
    self._currentDog = nil
    
    self:removeCells()
    
    self._managerGame = nil
    
    Controller.cleanup(self)
end


