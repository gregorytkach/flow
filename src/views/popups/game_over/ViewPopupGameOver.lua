
ViewPopupGameOver = classWithSuper(ViewPopupFlowBase, 'ViewPopupGameOver')


function ViewPopupGameOver.init(self, params)
    ViewPopupFlowBase.init(self, params)
    
    local managerResources  = GameInfo:instance():managerResources()
    local managerString     =  GameInfo:instance():managerString()
    
    self:initBackground(managerResources:getPopupBackground(self._controller:getType()))
    self:initTitle(EStringType.EST_POPUP_GAME_OVER_TITLE)
    
    self._animationDog = managerResources:getAsAnimation(EResourceType.ERT_POPUP_GAME_OVER_VIEW_ANIMATION_DOG)
    self._animationDog:play()
    self._sourceView:insert(self._animationDog)
    
    self._viewText      = self:createSprite(managerResources:getAsImage(EResourceType.ERT_POPUP_GAME_OVER_VIEW_TEXT))
    self._labelText     = self:createLabel(managerString:getString(EStringType.EST_POPUP_GAME_OVER_TEXT), EFontType.EFT_1)
    
    self._viewPenalty   = self:createSprite(managerResources:getAsImage(EResourceType.ERT_POPUP_GAME_OVER_VIEW_PENALTY))
    
    --todo: review "-1
    self._lavelPenalty  = self:createLabel("-1", EFontType.EFT_0, ELabelTextAlign.ELTA_RIGHT)
    self._lavelPenalty:sourceView():setColorHex("0xFFB600")
    self._iconCurrency  = self:createSprite(managerResources:getAsImage(EResourceType.ERT_ICON_ENERGY))
    
    local buttonClose = self:createButton(managerResources:getAsButton(EResourceType.ERT_POPUP_BUTTON_BLUE0), 
    nil, 
    managerString:getString(EStringType.EST_POPUP_GAME_OVER_BUTTON_CLOSE), 
    EFontType.EFT_1)
    buttonClose:label():sourceView():setColorHex("0xE5FBFF")
    self:setButtonClose(buttonClose)
end

function ViewPopupGameOver.placeViews(self)
    ViewPopupFlowBase.placeViews(self)
    
    local realHeight = self._background:realHeight()
    local realWidth  = self._background:realWidth()
    
    self._labelTitle:sourceView().x = 0
    self._labelTitle:sourceView().y = 0 - realHeight / 2 + 20
    
    self._animationDog.x = 0 + realWidth / 2 - 20
    self._animationDog.y = 0 - realHeight / 2 +  self._animationDog.contentHeight / 2 - 27
    
    self._viewText:sourceView().x = 0 
    self._viewText:sourceView().y = 0 - self._viewText:realHeight() / 2
    
    self._labelText:sourceView().x = self._viewText:sourceView().x
    self._labelText:sourceView().y = self._viewText:sourceView().y
    
    self._viewPenalty:sourceView().x = 0 
    self._viewPenalty:sourceView().y = 0 + self._viewPenalty:realHeight() / 2
    
    self._lavelPenalty:sourceView().x = 0
    self._lavelPenalty:sourceView().y = self._viewPenalty:sourceView().y
    
    self._iconCurrency:sourceView().x = 0 + self._iconCurrency:realWidth() / 2
    self._iconCurrency:sourceView().y = self._viewPenalty:sourceView().y
    
    self._buttonClose:sourceView().x = 0
    self._buttonClose:sourceView().y = 0 + realHeight / 2 - self._buttonClose:realHeight() / 2 - 20
    
end

function ViewPopupGameOver.cleanup(self)
    self._animationDog:removeSelf()
    self._animationDog = nil
    
    self._viewText:cleanup()
    self._viewText = nil
    
    self._labelText:cleanup()
    self._labelText = nil
    
    self._viewPenalty:cleanup()
    self._viewPenalty = nil
    
    self._lavelPenalty:cleanup()
    self._lavelPenalty = nil
    
    self._iconCurrency:cleanup()
    self._iconCurrency = nil
    
    ViewPopupFlowBase.cleanup(self)
end

