require('game_flow.src.controllers.game.ControllerCell')
require('game_flow.src.controllers.game.ControllerCellBarrier')
require('game_flow.src.controllers.game.ControllerCellBridge')
require('game_flow.src.controllers.game.ControllerCellEmpty')
require('game_flow.src.controllers.game.ControllerCellFlowPoint')

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
    
    local phone = 0
    local gridCells =  GameInfo:instance():managerGame():currentLevel():grid()
    
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
end

function ControllerGrid.update(self, type)
    
    if(type == EControllerUpdateBase.ECUT_SCENE_ENTER)then
        
        for indexRow, row in ipairs(self._cells)do
            for indexColumn, cell in ipairs(row)do
                cell:update(type)
                cell:view():establishBounds()
            end
        end
        
    else
        assert(false)
    end
    
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
    
    Controller.cleanup(self)
end


