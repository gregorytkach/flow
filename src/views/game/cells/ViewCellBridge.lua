
ViewCellBridge = classWithSuper(ViewCellWithView, 'ViewCellBridge')


--
-- Methods
--

function ViewCellBridge.init(self, params)
    ViewCellWithView.init(self, params)
    
end




function ViewCell.placeViews(self)
    ViewBase.placeViews(self)
    
    self._lineUp.y      = -25
    self._lineDown.y    = 25
    self._lineLeft.x    = -25
    self._lineRight.x   = 25
end
