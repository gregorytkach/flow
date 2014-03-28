require('game_flow.src.views.game.ViewEffect')
require('game_flow.src.views.game.cells.ViewCell')

ViewCellWithView = classWithSuper(ViewCell, 'ViewCellWithView')

--
--properties
--

function ViewCellWithView.houseFull(self)
    return self._viewFull:sourceView()
end

function ViewCellWithView.house(self)
    return self._view:sourceView()
end

function ViewCellWithView.effect(self)
    return self._effect
end


--
--methods
--
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
        
        local paramsEffect =
        {
            controller  = self._controller,
            image       = managerResources:getAsImage(EResourceType.ERT_STATE_GAME_DOG_SELECTION)
        }
        
        self._effect = ViewEffect:new(paramsEffect)
        self._sourceView:insert(self._effect:sourceView())
        
    elseif(cellType == ECellType.ECT_BRIDGE)then
        image = managerResources:getAsImage(EResourceType.ERT_STATE_GAME_CELL_BRIDGE)
    elseif(cellType ==  ECellType.ECT_BARRIER)then
        image = managerResources:getAsImage(EResourceType.ERT_STATE_GAME_CELL_BARRIER)
    else
        assert(false)
    end
    
    self._view = self:createSprite(image)  
    
    if(cellType == ECellType.ECT_FLOW_POINT) and not entry:isStart() then
         image = managerResources:getAsImageWithParam(EResourceType.ERT_STATE_GAME_CELL_END_FULL, entry:flowType())
         self._viewFull = self:createSprite(image)
         self._viewFull:sourceView().isVisible = false
    end
    
end

function ViewCellWithView.placeViews(self)
    
    local entry = self._controller:entry()
    
    if( entry:type() == ECellType.ECT_FLOW_POINT and entry:isStart())then
        self._view:sourceView().x =   self._view:realWidth()  / 2 - self:realWidth()   / 2
        self._view:sourceView().y =   self._view:realHeight() / 2 - self:realHeight()  / 2
    elseif( entry:type() == ECellType.ECT_FLOW_POINT and not entry:isStart())then
        self._viewFull:sourceView().anchorY = 1
        self._viewFull:sourceView().y = self._view:realHeight() / 2
    end
    
    ViewCell.placeViews(self) 
end

function ViewCellWithView.cleanup(self)
    
    if(self._effect ~= nil)then
        self._effect:cleanup()
        self._effect = nil
    end
    
    self._view:cleanup()
    self._view = nil
    
    ViewCell.cleanup(self)
end

