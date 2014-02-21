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
        local dog = {}
        
        local dogParams = 
        {
            flow_type = flowType,
        }
        
        dog = ControllerDog:new(dogParams)
        
        local sourceDog = dog:view():sourceView()
        dog:view():hide()
        
        self._view:sourceView():insert(sourceDog)
        
        self._dogs[flowType] = dog
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
        
        for flowType, controllerDog in pairs(self._dogs)do
            --            controllerDog:view():sourceView().isVisible = true
            controllerDog:view():show()
            
        end
        
    elseif(type == EControllerUpdate.ECUT_SET_CURRENT_CELL)then
        
        local currentCell = self._managerGame:currentCell()
        
        local viewCell = currentCell:controller():view()
        
        self._offsetYDog = -0.3 * viewCell:realHeight()
        
        self:setDogPosition(currentCell:flowType(), currentCell:controller():view():sourceView())
        
    elseif(type ==  EControllerUpdate.ECUT_DOG_UP) or (type ==  EControllerUpdate.ECUT_DOG_DOWN)  then
        
        local flowType = self._managerGame:currentLineFlowType()
        
        local dog = self._dogs[flowType]
        local sourceDog = dog:view():sourceView()
        
        self:tryCleanupTweenDogMoved()
        
        self._isDownDog = type == EControllerUpdate.ECUT_DOG_DOWN 
        self:transitionDog(sourceDog, dog._yBackDog)
        dog:update(type)    
        
    else
        assert(false)
    end
    
end

function ControllerGrid.setDogPosition(self, flowType, sourceCell)
    
    local controllerDog = self._dogs[flowType]
    
    local viewDog = controllerDog:view()
    
    local sourceDog = viewDog:sourceView()
    
    sourceDog.x = sourceCell.x
    
    local yTarget = sourceCell.y - viewDog:realHeight() / 2
    
    if self._currentDog == controllerDog and self._tweenDogMoved ~= nil then
        
        transition.cancel(self._tweenDogMoved)
        
        sourceDog.y = sourceDog.y + (yTarget -  controllerDog._yBackDog) 
        
        self:transitionDog(sourceDog, yTarget)
        
    elseif self._currentDog ~= controllerDog and self._tweenDogMoved ~= nil then
        
        local sourceCurrentDog = self._currentDog:view():sourceView()
        
        local flowType =  self._currentDog:flowType()
        
        if flowType ~= self._managerGame:currentLineFlowType() then
            
            transition.cancel(self._tweenDogMoved)
            
            sourceCurrentDog.y = self._currentDog._yBackDog
            self._currentDog:update(EControllerUpdate.ECUT_DOG_IDLE)
            
        end
        
    else
        sourceDog.y = yTarget
    end
    
    controllerDog._yBackDog = yTarget
    
    self._currentDog = controllerDog
    
end

function ControllerGrid.transitionDog(self, sourceDog, backY)
    
    local offsetY = 0
    local onComplete = nil
    
    if self._isDownDog then
        
        onComplete = function () 
            self._tweenDogMoved = nil 
            self._currentDog:update(EControllerUpdate.ECUT_DOG_IDLE)
        end
        
    else
        
        offsetY = self._offsetYDog
        
    end
    
    if sourceDog.y ~= backY + offsetY then
        
        local tweenParams =
        {
            y           = backY + offsetY,
            time        = application.animation_duration * math.abs((sourceDog.y - (backY + offsetY)) / self._offsetYDog),
            onComplete  = onComplete,
        }
        
        self._tweenDogMoved = transition.to(sourceDog, tweenParams) 
        
    end
    
end

function ControllerGrid.tryCleanupTweenDogMoved(self)
    if self._tweenDogMoved ~= nil then
        transition.cancel(self._tweenDogMoved)
        self._tweenDogMoved = nil
    end
end



function ControllerGrid.cleanup(self)
    
    self:tryCleanupTweenDogMoved()
    
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


