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
        
        self._view:sourceView():insert(dog:view():sourceView())
        
    end
    
end

function ControllerGrid.update(self, type)
    
    if(type == EControllerUpdateBase.ECUT_SCENE_ENTER)then
        print(EControllerUpdateBase.ECUT_SCENE_ENTER)
        
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
        

        
        local sourceCell = currentCell:controller():view():sourceView()
        
        self:setDogPosition(currentCell:flowType(), sourceCell)
        
    else
        assert(false)
    end
    
end

function ControllerGrid.setDogPosition(self, flowType, sourceCell)
    
    local dog = self._dogs[flowType + 1]
                    
    local sourceDog = dog:view():sourceView()

    sourceDog.x = sourceCell.x
    sourceDog.y = sourceCell.y
    
end

function ControllerGrid.cleanup(self)
    
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


