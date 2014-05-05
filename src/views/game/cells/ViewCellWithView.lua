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

function ViewCellWithView.realWidth(self)
    return self._realWidth
end

--
--methods
--
function ViewCellWithView.init(self, params)
    ViewCell.init(self, params)
    
    --cache real width without images
    self._realWidth = ViewCell.realWidth(self)
    self._realHeight = ViewCell.realHeight(self)
    
    
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
        self._effect:sourceView().isVisible = false
        
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

function ViewCellWithView.establishBounds(self)
    local widthHalf     = self._realWidth  / 2
    local heightHalf    = self._realHeight / 2
    
    local xGlobal, yGlobal = self._sourceView:localToContent(0, 0)
    
    self._x0 = xGlobal - widthHalf
    self._x1 = xGlobal + widthHalf
    
    self._y0 = yGlobal - heightHalf
    self._y1 = yGlobal + heightHalf
    
    self._boundsEstablished = true
end

function ViewCellWithView.placeViews(self)
    
    local entry = self._controller:entry()
    
    if( entry:type() == ECellType.ECT_FLOW_POINT)then
        
        if(entry:isStart())then
            self._view:sourceView().x =   self._view:realWidth()  / 2 
            self._view:sourceView().y =   -self._view:realHeight() / 2 
        else
            self._viewFull:sourceView().anchorY = 1
            self._viewFull:sourceView().y = self._view:realHeight() / 2
        end
        
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

