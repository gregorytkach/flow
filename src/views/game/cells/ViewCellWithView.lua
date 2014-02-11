require('game_flow.src.views.game.cells.ViewCell')

ViewCellWithView = classWithSuper(ViewCell, 'ViewCellWithView')

function ViewCellWithView.init(self, params)
    ViewCell.init(self, params)
    
    local entry = self._controller:entry()
    
    local image = nil
    
    local managerResources =  GameInfo:instance():managerResources()
    
    local cellType = entry:type()
    
    if(cellType == ECellType.ECT_FLOW_POINT)then
        
        if(entry:isStart())then
            image = managerResources:getAsImageWithParam(EResourceType.ERT_STATE_GAME_CELL_START, entry:flowType())
        else
            image = managerResources:getAsImageWithParam(EResourceType.ERT_STATE_GAME_CELL_END, entry:flowType())
        end
        
    elseif(cellType == ECellType.ECT_BRIDGE)then
        image = managerResources:getAsImage(EResourceType.ERT_STATE_GAME_CELL_BRIDGE)
    elseif(cellType ==  ECellType.ECT_BARRIER)then
        image = managerResources:getAsImage(EResourceType.ERT_STATE_GAME_CELL_BARRIER)
    else
        assert(false)
    end
    
    self._view = self:createSprite(image)  
    
end

function ViewCellWithView.cleanup(self)
    
    self._view:cleanup()
    self._view = nil
    
    ViewCell.cleanup(self)
end

