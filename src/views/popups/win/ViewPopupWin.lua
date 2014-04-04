

ViewPopupWin = classWithSuper(ViewPopupFlowBase, 'ViewPopupWin')

--
-- Properties
--

function ViewPopupWin.setRewardCurrency(self, value)
    assert(value ~= nil)
    
    self._labelRewardCount:setValue(value)
end

function ViewPopupWin.setLevel(self, value)
    assert(value ~= nil)
    
    local text = string.format(self._labelTextFormat, value)
    
    self._labelText:sourceView():setText(text)
end

--
-- Methods
--


function ViewPopupWin.init(self, params)
    ViewPopupFlowBase.init(self, params)
    
    local managerResources = GameInfoBase:instance():managerResources()
    local managerString    = GameInfoBase:instance():managerString()
    local backgroundImage  = managerResources:getPopupBackground(self._controller:getType())
    
    self:initBackground(backgroundImage)
    self:initTitle(EStringType.EST_POPUP_WIN_TITLE)
    
    local buttonClose = self:createButton(managerResources:getAsButton(EResourceType.ERT_POPUP_BUTTON_BLUE0), nil, managerString:getString(EStringType.EST_POPUP_WIN_BUTTON_CLOSE), EFontType.EFT_1)
    self:setButtonClose(buttonClose)
    
    self._labelTextFormat = managerString:getString(EStringType.EST_POPUP_WIN_TEXT)
    
    local text = string.format(self._labelTextFormat, 0)
    self._viewText = self:createSprite(managerResources:getAsImage(EResourceType.ERT_POPUP_WIN_VIEW_TEXT))
    self._labelText = self:createLabel(text,        --text
    EFontType.EFT_1,                                --fontType
    nil,                                            --align
    self._viewText:sourceView().width)              --wrapWidth
    
    self._viewReward = self:createSprite(managerResources:getAsImage(EResourceType.ERT_POPUP_WIN_VIEW_REWARD))
    self._labelReward = self:createLabel(managerString:getString(EStringType.EST_POPUP_WIN_REWARD), 
    EFontType.EFT_1,
    ELabelTextAlign.ELTA_RIGHT, 
    nil, 
    0, 
    application.animation_duration * 4 * 10)
    
    self._labelRewardCount = self:createLabel("%i", EFontType.EFT_0, ELabelTextAlign.ELTA_RIGHT, nil, 0, application.animation_duration * 4)
    self._labelRewardCount:sourceView():setColorHex("0xFFB600")
    
    self._iconCurrency = self:createSprite(managerResources:getAsImage(EResourceType.ERT_ICON_CURRENCY))
    
    self._animationDog = managerResources:getAsAnimation(EResourceType.ERT_POPUP_WIN_ANIMATION_DOG)
    self._animationDog:play()
    self._sourceView:insert(self._animationDog)
    
    self._ballonsLeft = managerResources:getAsAnimation(EResourceType.ERT_POPUP_WIN_ANIMATION_BALLOONS)
    self._ballonsLeft:play()
    self._sourceView:insert(self._ballonsLeft)
    
    self._ballonsRight = managerResources:getAsAnimation(EResourceType.ERT_POPUP_WIN_ANIMATION_BALLOONS)
    self._ballonsRight:play()
    self._sourceView:insert(self._ballonsRight)
end


function ViewPopupWin.placeViews(self)
    ViewPopupFlowBase.placeViews(self)
    
    local realHeight = self._background:realHeight()
    local realWidth  = self._background:realWidth()
    
    self._labelTitle:sourceView().x = 0
    self._labelTitle:sourceView().y = 20 - realHeight / 2
    
    self._buttonClose:sourceView().x = 0
    self._buttonClose:sourceView().y =  realHeight / 2 - 40
    
    self._viewText:sourceView().x = 0
    self._viewText:sourceView().y = 0 - self._viewText:realHeight() / 2 - 5
    
    self._labelText:sourceView().x = self._viewText:sourceView().x 
    self._labelText:sourceView().y = self._viewText:sourceView().y
    
    self._viewReward:sourceView().x = 0
    self._viewReward:sourceView().y = 0 + self._viewReward:realHeight() / 2 + 5
    
    self._labelReward:sourceView().x = self._viewReward:sourceView().x
    self._labelReward:sourceView().y = self._viewReward:sourceView().y
    
    self._iconCurrency:sourceView().x = self._viewReward:sourceView().x + self._viewReward:realWidth() / 2 - self._iconCurrency:realWidth() / 2 - 5
    self._iconCurrency:sourceView().y = self._viewReward:sourceView().y
    
    self._labelRewardCount:sourceView().x = self._iconCurrency:sourceView().x - self._iconCurrency:realWidth() / 2 - 5
    self._labelRewardCount:sourceView().y = self._viewReward:sourceView().y
    
    self._animationDog.x = - realWidth / 2  + self._animationDog.contentWidth / 2
    self._animationDog.y = - realHeight / 2 - self._animationDog.contentHeight / 2 + 10
    
    self._ballonsLeft.x = - realWidth / 2
    self._ballonsLeft.y = 40
    
    self._ballonsRight.x = realWidth / 2
    self._ballonsRight.y = - 20
end

function ViewPopupWin.cleanup(self)
    
    
    self._viewText:cleanup()
    self._viewText = nil
    
    self._labelText:cleanup()
    self._labelText = nil
    
    self._viewReward:cleanup()
    self._viewReward = nil
    
    self._labelReward:cleanup()
    self._labelReward = nil
    
    self._iconCurrency:cleanup()
    self._iconCurrency = nil
    
    self._labelRewardCount:cleanup()
    self._labelRewardCount = nil
    
    self._ballonsRight:removeSelf()
    self._ballonsRight = nil
    
    self._ballonsLeft:removeSelf()
    self._ballonsLeft = nil
    
    self._animationDog:removeSelf()
    self._animationDog = nil
    
    ViewPopupFlowBase.cleanup(self)
end
