ViewUIEditor = classWithSuper(ViewBase, 'ViewUIEditor')


--
--Properties
--



function ViewUIEditor.buttonShuffle(self)
    return self._buttonShuffle
end

function ViewUIEditor.labelFlowType(self)
    return self._labelFlowType
end

function ViewUIEditor.buttonShop(self)
    return self._buttonShop
end

function ViewUIEditor.labelCurrencySoft(self)
    return self._labelCurrencySoft
end

function ViewUIEditor.setTime(self, value)
    
    assert(value ~= nil)
    
    local text = string.format("%.2d:%.2d", value / 60 % 60, value % 60)
    
    self._labelTime:sourceView():setText(text)
end

function ViewUIEditor.labelFlowType(self)
    return self._labelFlowType
end

function ViewUIEditor.buttonFlowTypeAdd(self)
    return self._buttonFlowTypeAdd
end

function ViewUIEditor.buttonFlowTypeRemove(self)
    return self._buttonFlowTypeRemove
end

function ViewUIEditor.labelSize(self)
    return self._labelSize
end

function ViewUIEditor.buttonSizeAdd(self)
    return self._buttonSizeAdd
end

function ViewUIEditor.buttonSizeRemove(self)
    return self._buttonSizeRemove
end


function ViewUIEditor.labelBridge(self)
    return self._labelBridge
end

function ViewUIEditor.buttonBridgeAdd(self)
    return self._buttonBridgeAdd
end

function ViewUIEditor.buttonBridgeRemove(self)
    return self._buttonBridgeRemove
end

function ViewUIEditor.labelBarrier(self)
    return self._labelBarrier
end

function ViewUIEditor.buttonBarrierAdd(self)
    return self._buttonBarrierAdd
end

function ViewUIEditor.buttonBarrierRemove(self)
    return self._buttonBarrierRemove
end
--
--Methods
--

function ViewUIEditor.init(self, params)
    
    ViewBase.init(self, params)
    
    self._sourceView  = display.newGroup()
    
    local managerResources = GameInfo:instance():managerResources()
    self._gridCreator = GameInfo:instance():managerGame():gridCreator()
    self._buttonShuffle = self:createButton(managerResources:getAsButton(EResourceType.ERT_STATE_EDITOR_BUTTON_SHUFFLE),
    nil,
    "Shuffle",
    EFontType.EFT_1)
    
    self._labelFlowType     = self:createLabel("Flow type: "..tostring(self._gridCreator:flowCount()), EFontType.EFT_0)
    
    self._buttonFlowTypeAdd    = self:createButton(managerResources:getAsButton(EResourceType.ERT_STATE_EDITOR_BUTTON_ADD))
    self._buttonFlowTypeRemove = self:createButton(managerResources:getAsButton(EResourceType.ERT_STATE_EDITOR_BUTTON_REMOVE),
    nil,
    "-",
    EFontType.EFT_1)
    
    local scale = self._buttonFlowTypeAdd:realWidth() / self._buttonFlowTypeRemove:realWidth()
    self._buttonFlowTypeRemove:sourceView():scale(scale, 1)
    self._buttonFlowTypeRemove:label():sourceView():scale(1 / scale, 1)
    
    self._labelSize     = self:createLabel("Size: "..tostring(self._gridCreator:rowsCount()), EFontType.EFT_0)
    
    self._buttonSizeAdd    = self:createButton(managerResources:getAsButton(EResourceType.ERT_STATE_EDITOR_BUTTON_ADD))
    self._buttonSizeRemove = self:createButton(managerResources:getAsButton(EResourceType.ERT_STATE_EDITOR_BUTTON_REMOVE),
    nil,
    "-",
    EFontType.EFT_1)
    
    self._buttonSizeRemove:sourceView():scale(scale, 1)
    self._buttonSizeRemove:label():sourceView():scale(1 / scale, 1)
    
    self._labelBridge     = self:createLabel("Bridges: "..tostring(self._gridCreator:bridgesCount()), EFontType.EFT_0)
    
    self._buttonBridgeAdd    = self:createButton(managerResources:getAsButton(EResourceType.ERT_STATE_EDITOR_BUTTON_ADD))
    self._buttonBridgeRemove = self:createButton(managerResources:getAsButton(EResourceType.ERT_STATE_EDITOR_BUTTON_REMOVE),
    nil,
    "-",
    EFontType.EFT_1)
    
    self._buttonBridgeRemove:sourceView():scale(scale, 1)
    self._buttonBridgeRemove:label():sourceView():scale(1 / scale, 1)
    
    self._labelBarrier     = self:createLabel("Barriers: "..tostring(self._gridCreator:barriersCount()), EFontType.EFT_0)
    
    self._buttonBarrierAdd    = self:createButton(managerResources:getAsButton(EResourceType.ERT_STATE_EDITOR_BUTTON_ADD))
    self._buttonBarrierRemove = self:createButton(managerResources:getAsButton(EResourceType.ERT_STATE_EDITOR_BUTTON_REMOVE),
    nil,
    "-",
    EFontType.EFT_1)
    
    self._buttonBarrierRemove:sourceView():scale(scale, 1)
    self._buttonBarrierRemove:label():sourceView():scale(1 / scale, 1)
end

function ViewUIEditor.placeViews(self)
    
    ViewBase.placeViews(self)
    
    local sourceShuffle = self._buttonShuffle:sourceView()
    sourceShuffle.x = display.contentCenterX
    sourceShuffle.y = application.margin_bottom - self._buttonShuffle:realHeight() 

    local sourceFlowType = self._labelFlowType:sourceView()

    sourceFlowType.x = application.margin_left + sourceFlowType.contentWidth / 2 
    sourceFlowType.y = application.margin_top + sourceFlowType.contentHeight  
    self._buttonFlowTypeAdd:setIsEnabled(self._gridCreator:flowCount() ~= tonumber(EFlowType.EFT_COUNT))

    local sourceFlowTypeAdd = self._buttonFlowTypeAdd:sourceView()
    sourceFlowTypeAdd.x = sourceFlowType.x + sourceFlowType.contentWidth * 0.55 + sourceFlowTypeAdd.contentWidth * 0.5
    sourceFlowTypeAdd.y = sourceFlowType.y

    local sourceFlowTypeRemove = self._buttonFlowTypeRemove:sourceView()
    sourceFlowTypeRemove.x = sourceFlowTypeAdd.x + sourceFlowTypeAdd.contentWidth / 2 + sourceFlowTypeRemove.contentWidth * 0.55
    sourceFlowTypeRemove.y = sourceFlowTypeAdd.y

    self._buttonFlowTypeRemove:setIsEnabled(self._gridCreator:flowCount() ~= 1)

    local sourceSize = self._labelSize:sourceView()

    sourceSize.x = sourceFlowType.x
    sourceSize.y = sourceFlowType.y + sourceSize.contentHeight * 2.5

    local sourceSizeAdd = self._buttonSizeAdd:sourceView()
    sourceSizeAdd.x = sourceFlowTypeAdd.x
    sourceSizeAdd.y = sourceSize.y
    self._buttonSizeAdd:setIsEnabled(self._gridCreator:rowsCount() ~= Constants.MAX_GRID_SIZE)

    local sourceSizeRemove = self._buttonSizeRemove:sourceView()
    sourceSizeRemove.x = sourceFlowTypeRemove.x
    sourceSizeRemove.y = sourceSize.y
    self._buttonSizeRemove:setIsEnabled(self._gridCreator:rowsCount() ~= Constants.MIN_GRID_SIZE)


    local sourceBridge = self._labelBridge:sourceView()

    sourceBridge.x = sourceFlowTypeRemove.x + sourceFlowTypeRemove.contentWidth / 2 + sourceBridge.contentWidth 
    sourceBridge.y = sourceFlowType.y
    self._buttonBridgeAdd:setIsEnabled(self._gridCreator:bridgesCount() ~= Constants.MAX_COUNT_BRIDGES)

    local sourceBridgeAdd = self._buttonBridgeAdd:sourceView()
    sourceBridgeAdd.x = sourceBridge.x + sourceBridge.contentWidth * 0.55 + sourceBridgeAdd.contentWidth * 0.5
    sourceBridgeAdd.y = sourceFlowType.y

    local sourceBridgeRemove = self._buttonBridgeRemove:sourceView()
    sourceBridgeRemove.x = sourceBridgeAdd.x + sourceBridgeAdd.contentWidth / 2 + sourceBridgeRemove.contentWidth * 0.55
    sourceBridgeRemove.y = sourceBridgeAdd.y

    local sourceBarrier = self._labelBarrier:sourceView()

    sourceBarrier.x = sourceBridge.x - 8
    sourceBarrier.y = sourceSize.y 

    local sourceBarrierAdd = self._buttonBarrierAdd:sourceView()
    sourceBarrierAdd.x = sourceBridgeAdd.x
    sourceBarrierAdd.y = sourceBarrier.y

    self._buttonBarrierAdd:setIsEnabled(self._gridCreator:barriersCount() ~= Constants.MAX_COUNT_BARRIERS)

    local sourceBarrierRemove = self._buttonBarrierRemove:sourceView()
    sourceBarrierRemove.x = sourceBridgeRemove.x
    sourceBarrierRemove.y = sourceBarrierAdd.y
    self._buttonBarrierRemove:setIsEnabled(self._gridCreator:barriersCount() ~= 0)
    
end



function ViewUIEditor.cleanup(self)
    
    self._buttonShuffle:cleanup()
    self._buttonShuffle = nil
    
    self._buttonFlowTypeAdd:cleanup()
    self._buttonFlowTypeAdd = nil
    
    self._buttonFlowTypeRemove:cleanup()
    self._buttonFlowTypeRemove = nil
    
    self._labelFlowType:cleanup()
    self._labelFlowType = nil
    
    self._buttonSizeAdd:cleanup()
    self._buttonSizeAdd = nil
    
    self._buttonSizeRemove:cleanup()
    self._buttonSizeRemove = nil
    
    self._labelSize:cleanup()
    self._labelSize = nil
    
    self._buttonBridgeAdd:cleanup()
    self._buttonBridgeAdd = nil
    
    self._buttonBridgeRemove:cleanup()
    self._buttonBridgeRemove = nil
    
    self._labelBridge:cleanup()
    self._labelBridge = nil
    
    self._labelBarrier:cleanup()
    self._labelBarrier = nil
    
    self._buttonBarrierAdd:cleanup()
    self._buttonBarrierAdd = nil
    
    self._buttonBarrierRemove:cleanup()
    self._buttonBarrierRemove = nil
    
    self._gridCreator = nil
    
    ViewBase.cleanup(self)
end
