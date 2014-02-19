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
    
    
    local gridCells = self._managerGame:currentLevel():grid()
    
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
    
    for i, row in ipairs(self._cells)do
        for i, controllerCell in ipairs(row)do
            
            if(controllerCell:entry():type() == ECellType.ECT_FLOW_POINT)then
                controllerCell:view():sourceView():toFront()
            end
            
        end
    end
    
    for i = 0, EFlowType.EFT_COUNT - 1, 1 do
        
        local dogParams = 
        {
            flow_type = i,
        }
        
        local dog = ControllerDog:new(dogParams)
                
        table.insert(self._dogs, dog)
        
        local sourceDog = dog:view():sourceView()
        
        self._view:sourceView():insert(sourceDog)
        sourceDog.isVisible = false
        
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
                    
                    self:setDogPosition(entry:flowType(), sourceCell)
                    
                end
                
            end
        end
        
    elseif(type == EControllerUpdate.ECUT_SET_CURRENT_CELL)then
        
        local currentCell = self._managerGame:currentCell()
        
        local viewCell = currentCell:controller():view()
        
        self._offsetYDog = - 0.75 * viewCell:realHeight()
        
        self:setDogPosition(currentCell:flowType(), viewCell:sourceView())
        
    elseif(type ==  EControllerUpdate.ECUT_DOG_UP) or (type ==  EControllerUpdate.ECUT_DOG_DOWN)  then
        
        local flowType = self._managerGame:currentLineFlowType()
        
        
        local dog = self._dogs[flowType + 1]
        local sourceDog = dog:view():sourceView()
        
        if self._tweenDogMoved ~= nil then
            
            transition.cancel(self._tweenDogMoved)
            self._tweenDogMoved = nil
            
        else
            
            dog._yBackDog = sourceDog.y
            
        end
        
        self._isBackDog = type == EControllerUpdate.ECUT_DOG_DOWN 
            
            
        
        self:transitionDog(sourceDog, dog._yBackDog)
            
        
        
    else
        assert(false)
    end
    
end

function ControllerGrid.setDogPosition(self, flowType, sourceCell)
    
    local dog = self._dogs[flowType + 1]
                    
    local sourceDog = dog:view():sourceView()
    
    sourceDog.isVisible = true
    sourceDog.x = sourceCell.x
    
    if self._currentDog == dog and self._tweenDogMoved ~= nil then
        
        transition.cancel(self._tweenDogMoved)
        self._tweenDogMoved = nil
        
        sourceDog.y = sourceDog.y + (sourceCell.y -  dog._yBackDog) 
        
        self:transitionDog(sourceDog, sourceCell.y)
        
    elseif self._currentDog ~= dog and self._tweenDogMoved ~= nil then
        
        transition.cancel(self._tweenDogMoved)
        
        local sourceCurrentDog = self._currentDog:view():sourceView()
        
        local currentDogFlowType = table.indexOf(self._dogs, self._currentDog) - 1
        
        if self._managerGame:currentLineFlowType() ~= currentDogFlowType then
            sourceCurrentDog.y = self._currentDog._yBackDog
        end
        
    else
        
        sourceDog.y = sourceCell.y
        
    end
    
    dog._yBackDog = sourceCell.y
    
    self._currentDog = dog
    
end

function ControllerGrid.transitionDog(self, sourceDog, backY)
    
    local offsetY = 0
    local onComplete = nil
        
    if self._isBackDog then
        
        onComplete = function () self._tweenDogMoved = nil end
    else
        offsetY = self._offsetYDog
    end

    local tweenParams =
    {
        y = backY + offsetY,
        time = 4 * application.animation_duration * math.abs((sourceDog.y - (backY + offsetY))/ self._offsetYDog),
        onComplete = onComplete,
    }

    self._tweenDogMoved = transition.to(sourceDog, tweenParams)    
end

function ControllerGrid.cleanup(self)
    
    if self._tweenDogMoved ~= nil then
        transition.cancel(self._tweenDogMoved)
        self._tweenDogMoved = nil
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


