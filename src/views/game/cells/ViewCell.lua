ViewCell = classWithSuper(ViewBase, 'ViewCell')

--
--Events
--
function ViewCell.realWidthBg(self)
    return self._realWidthBg
end

function ViewCell.realHeightBg(self)
    return self._realHeightBg
end

--
--Properties
--

function ViewCell.setIsEnabled(self, value)
    
    if(self._isEnabled == value)then
        return
    end
    
    self._isEnabled = value
    
    --todo: enable color
--    if(self._isEnabled)then
--        self._sourceView:setColor(1, 1, 1)
--    else
--        self._sourceView:setColor(0.5, 0.5, 0.5)
--    end
end

--
--Methods
--

function ViewCell.setPath(self, flowType)
    for i = 0, #self._pathsViews - 1, 1 do
        
        local path = self._pathsViews[i + 1]
        
        local isPathViewVisible = tostring(i) == tostring(flowType)
        path:sourceView().isVisible = isPathViewVisible
        
        if isPathViewVisible and not self._isEnabled then
            path:sourceView():setFillColor(0.5, 0.5, 0.5)
        end
        
    end
end

function ViewCell.init(self, params)
    
    assert(params.isPair ~= nil)
    
    ViewBase.init(self, params)
    
    self._isEnabled  = true
    
    self._sourceView = display.newGroup()
    
    local managerResources = GameInfo:instance():managerResources()
    
    local prefix = 0
    
    if(params.isPair)then
        prefix = 1
    end
    
    self._cell = self:createSprite(managerResources:getAsImageWithParam(EResourceType.ERT_STATE_GAME_CELL_DEFAULT, prefix)) 
    
    self._layerPath = display.newGroup()
    self._sourceView:insert(self._layerPath)
    
    self._pathsViews = self:createPathsViews()
    
    for i, pathView in ipairs(self._pathsViews)do
        self._layerPath:insert(pathView:sourceView())
    end
    
    self:initLines()
    
    self._realWidthBg   = self:realWidth()
    self._realHeightBg  = self:realHeight()
    
    
end

function ViewCell.createPathsViews(self)
    local result = {}
    
    for i = 0, EFlowType.EFT_COUNT - 1 do
        
        local pathParams = 
        {
            image       =  GameInfo:instance():managerResources():getAsImageWithParam(EResourceType.ERT_STATE_GAME_CELL_PATH, i),
            controller = self._controller
        }
        
        local pathView = ViewSprite:new(pathParams)
        
        pathView:sourceView().isVisible = false
        
        table.insert(result, pathView)  
    end 
    
    return result
end

function ViewCell.initLines(self)
    
    self._lineUp = display.newRect(0, 0, 10, 20)
    self._lineUp:setFillColor(0.72, 0.9, 0.16, 0.78)
    
    self._sourceView:insert(self._lineUp)
    
    self._lineDown = display.newRect(0, 0, 10, 20)
    self._lineDown:setFillColor(0.72, 0.9, 0.16, 0.78)
    
    self._sourceView:insert(self._lineDown)
    
    self._lineLeft = display.newRect(0, 0, 20, 10)
    self._lineLeft:setFillColor(0.72, 0.9, 0.16, 0.78)
    
    self._sourceView:insert(self._lineLeft)
    
    self._lineRight = display.newRect(0, 0, 20, 10)
    self._lineRight:setFillColor(0.72, 0.9, 0.16, 0.78)
    
    self._sourceView:insert(self._lineRight)
end

--
--Lines logic
--

function ViewCell.hideAllLines(self)
    
    self._lineUp.alpha      = 0
    self._lineDown.alpha    = 0
    self._lineLeft.alpha    = 0
    self._lineRight.alpha   = 0
    
end

function ViewCell.showLineUp(self)
    self._lineUp.alpha = 1
end

function ViewCell.showLineDown(self)
    self._lineDown.alpha = 1
end

function ViewCell.showLineLeft(self)
    self._lineLeft.alpha = 1
end

function ViewCell.showLineRight(self)
    self._lineRight.alpha = 1
end

function ViewCell.placeViews(self)
    ViewBase.placeViews(self)
    
    self._lineUp.y      = -25
    self._lineDown.y    = 25
    self._lineLeft.x    = -25
    self._lineRight.x   = 25
end

function ViewCell.cleanup(self)
    
    self._cell:cleanup()
    self._cell = nil
    
    for i = #self._pathsViews, 1, -1 do
        
        local path = self._pathsViews[i]
        path:cleanup()
    end
    
    self._pathsViews = nil
    
    self._layerPath:removeSelf()
    self._layerPath = nil
    
    ViewBase.cleanup(self)
end




