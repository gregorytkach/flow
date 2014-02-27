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
    
    self._dogs    = {}
    
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
        
        self._dogs[flowType] = controllerDog
    end
end

function ControllerGrid.update(self, type)
    
    if(type == EControllerUpdateBase.ECUT_SCENE_ENTER)then
        
        for indexRow, row in ipairs(self._cells)do
            for indexColumn, cell in ipairs(row)do
                cell:update(type)
                cell:view():establishBounds()
                
                local entry = cell:entry()
                
                if entry:type() == ECellType.ECT_FLOW_POINT and entry:isStart() then
                    
                    local sourceCell = cell:view():sourceView()
                    
                    local controllerDog = self._dogs[entry:flowType()]
                    
                    controllerDog:view():setDogPosition(sourceCell)
                    controllerDog:setRow(entry:y())
                end
                
            end
        end
        
        for flowType, controllerDog in pairs(self._dogs)do
            --            controllerDog:view():sourceView().isVisible = true
            controllerDog:view():show()
            
        end
        
    elseif(type == EControllerUpdate.ECUT_SET_CURRENT_CELL)then
        
        local currentCell = self._managerGame:currentCell()
        
        local viewCell = currentCell:controller():view()
        
        local controllerDog = self._dogs[currentCell:flowType()]
        
        controllerDog:setRow(currentCell:y())
        
        controllerDog:view():setDogPosition(viewCell:sourceView())
        
        local dogsForSort = {}
        
        for i = 1, #self._dogs, 1 do
            
            local maxRowControllerDog = self._dogs[1]
            for key, controllerDog in pairs(self._dogs) do
                
                if table.indexOf(self._dogs, controllerDog) == nil and controllerDog:row() > maxRowControllerDog:row() then
                    
                    maxRowControllerDog = controllerDog
                end
                
                table.insert(dogsForSort, maxRowControllerDog)
                
            end
        end
        
        for key, controllerDog in pairs(dogsForSort) do
            controllerDog:view():sourceView():toFront()
        end
        
    elseif(type ==  EControllerUpdate.ECUT_DOG_UP) or (type ==  EControllerUpdate.ECUT_DOG_DOWN)  then
        
        if self._currentDog ~= nil then
            
            self._currentDog:tryCleanupTweenDogMoved()
            
        end
        
        local controllerDog 
        
        if (type ==  EControllerUpdate.ECUT_DOG_UP) then
            
            local flowType = self._managerGame:currentLineFlowType()
            
            controllerDog = self._dogs[flowType]
            self._currentDog = controllerDog
            
        else
            
            controllerDog = self._currentDog
            
        end
        
        
        if controllerDog then
            controllerDog:update(type)
        end
        
    else
        assert(false)
    end
    
end




function ControllerGrid.cleanup(self)
    
    if self._currentDog ~= nil then
        
        self._currentDog:tryCleanupTweenDogMoved()
        
    end
    
    for indexRow, row in ipairs(self._cells)do
        for indexColumn, controllerCell in ipairs(row)do
            controllerCell:cleanup()
        end
    end
    
    self._cells = nil
    
    self._view:cleanup()
    self._view = nil
    
    self._managerGame = nil
    self._currentDog = nil
    
    Controller.cleanup(self)
end


