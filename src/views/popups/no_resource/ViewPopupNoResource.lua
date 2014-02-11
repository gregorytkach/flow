ViewPopupNoResource = classWithSuper(ViewPopupFlowBase, 'ViewPopupNoResource')

--
-- Properties
--

function ViewPopupNoResource.buttonBuy(self)
    return self._buttonBuy
end

--
-- Methods
-- 

function ViewPopupNoResource.init(self, params)
    ViewPopupFlowBase.init(self, params)
    
    local managerResources  = GameInfo:instance():managerResources()
    local managerString     = GameInfo:instance():managerString()
    
    self:initBackground(managerResources:getPopupBackground(self._controller:getType()))
    
    self._viewText  = self:createSprite(managerResources:getAsImage(EResourceType.ERT_POPUP_NO_RESOURCE_VIEW_TEXT)) 
    
    self._buttonBuy = self:createButton(managerResources:getAsButton(EResourceType.ERT_POPUP_BUTTON_GREEN),
    nil,
    managerString:getString(EStringType.EST_POPUP_NO_RESOURCE_BUTTON_BUY),
    EFontType.EFT_2)
    
    self._buttonBuy:label():sourceView():setColorHex("0xE8FFBB")
    
    local buttonClose = self:createButton(managerResources:getAsButton(EResourceType.ERT_POPUP_BUTTON_BLUE0), 
    nil, 
    managerString:getString(EStringType.EST_POPUP_NO_RESOURCE_BUTTON_CLOSE),
    EFontType.EFT_2)
    buttonClose:label():sourceView():setColorHex("0xE5FBFF")
    self:setButtonClose(buttonClose)
    
end

function ViewPopupNoResource.initIcon(self, resourceType)
    local managerResources  = GameInfo:instance():managerResources()
    
    self._iconResource = self:createSprite(managerResources:getAsImage(resourceType))
end

function ViewPopupNoResource.initText(self, textType)
    local managerString = GameInfo:instance():managerString()
    
    self._labelText     = self:createLabel(managerString:getString(textType), EFontType.EFT_1)
end

function ViewPopupNoResource.placeViews(self)
    ViewPopupFlowBase.placeViews(self)
    
    local realWidth  = self._background:realWidth()
    local realHeight = self._background:realHeight()
    
    self._labelTitle:sourceView().x = 0
    self._labelTitle:sourceView().y = 20 - realHeight / 2
    
    self._viewText:sourceView().y = 0 -  self._viewText:realHeight() / 2
    
    self._labelText:sourceView().x = self._viewText:sourceView().x
    self._labelText:sourceView().y = self._viewText:sourceView().y
    
    self._iconResource:sourceView().x = self._viewText:sourceView().x + self._viewText:realWidth() / 2
    self._iconResource:sourceView().y = self._viewText:sourceView().y - self._viewText:realHeight() / 2
    
    self._buttonBuy:sourceView().x = 0
    self._buttonBuy:sourceView().y = self._viewText:sourceView().y + self._viewText:realHeight() / 2 + self._buttonBuy:realHeight() / 2 + 10
    
    self._buttonClose:sourceView().x = 0
    self._buttonClose:sourceView().y = self._buttonBuy:sourceView().y + self._buttonBuy:realHeight() / 2 + self._buttonClose:realHeight() / 2 + 10
    
end

function ViewPopupNoResource.cleanup(self)
    
    self._iconResource:cleanup()
    self._iconResource = nil
    
    self._buttonBuy:cleanup()
    self._buttonBuy = nil
    
    self._viewText:cleanup()
    self._viewText = nil
    
    self._labelText:cleanup()
    self._labelText = nil
    
    ViewPopupFlowBase.cleanup(self)
end



