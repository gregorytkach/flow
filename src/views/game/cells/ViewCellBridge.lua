
ViewCellBridge = classWithSuper(ViewCellWithView, 'ViewCellBridge')


--
-- Methods
--

function ViewCellBridge.setPathAbove(self, flowTypeAbove)
    
    for i = 0, #self._pathsViewsAbove - 1, 1 do
        
        local path = self._pathsViewsAbove[i + 1]
        path:sourceView().isVisible = (tostring(i) == tostring(flowTypeAbove))
        
    end
end

function ViewCellBridge.init(self, params)
    ViewCellWithView.init(self, params)
    
    self._layerPathAbove = display.newGroup()
    
    
    self._sourceView:insert(self._layerPathAbove)
    
    self._pathsViewsAbove = self:createPathsViews()
    
    for i, pathView in ipairs(self._pathsViewsAbove)do
        self._layerPathAbove:insert(pathView:sourceView())
    end
    
end




function ViewCellBridge.placeViews(self)
    ViewBase.placeViews(self)
    
    self._layerPathAbove.y = -5
    
    self._lineUp.y      = -25
    self._lineDown.y    = 25
    self._lineLeft.x    = -25
    self._lineRight.x   = 25
end

function ViewCellBridge.cleanup(self)
    
    for i = #self._pathsViewsAbove, 1, -1 do
        
        local path = self._pathsViewsAbove[i]
        
        path:cleanup()
        table.remove(self._pathsViewsAbove, i)
        
    end
    
    self._layerPathAbove:removeSelf()
    self._layerPathAbove = nil
    
    ViewCellWithView.cleanup(self)
end
