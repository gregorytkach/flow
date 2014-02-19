ViewPopupShopContent = classWithSuper(ViewBase, 'ViewPopupShopContent')

function ViewPopupShopContent.init(self, params)
    ViewBase.init(self, params)
    
    self._sourceView = display.newGroup()
    
    self._items = {}
end

function ViewPopupShopContent.addItem(self, item)
    assert(item ~= nil)
    table.insert(self._items, item)
    
    self._sourceView:insert(item:sourceView())
end

function ViewPopupShopContent.placeViews(self)
    
    local startX = 0
    local startY = 0
    
    local currentX = startX
    local currentY = startY
    
    local offsetY = 10
    
    for i, item in ipairs(self._items)do
        item:placeViews()
        
        item:sourceView().x = currentX 
        item:sourceView().y = currentY + item:realHeight() / 2
        
        currentY = currentY + item:realHeight() + offsetY
    end
    
    ViewBase.placeViews(self)
end


