
ViewUIMap = classWithSuper(ViewBase, 'ViewUIMap')


--
--Properties
--

function ViewUIMap.buttonBonus(self)
    return self._buttonBonus
end

function ViewUIMap.buttonSound(self)
    return self._buttonSound
end

function ViewUIMap.buttonSoundDisabled(self)
    return self._buttonSoundDisabled
end

function ViewUIMap.buttonFreeCurrency(self)
    return self._buttonFreeCurrency
end

function ViewUIMap.buttonBuyCurrency(self)
    return self._buttonBuyCurrency
end

function ViewUIMap.buttonBuyEnergy(self)
    return self._buttonBuyEnergy
end

function ViewUIMap.buttonHelp(self)
    return self._buttonHelp
end

function ViewUIMap.setCurrency(self, value)
    assert(value ~= nil)
    
    self._labelCurrencySoft:sourceView():setText(value)
end

function ViewUIMap.setEnergy(self, value)
    assert(value ~= nil)
    
    self._labelEnergy:sourceView():setText(value)
end

function ViewUIMap.setTimeEnergy(self, value)
    
    assert(value ~= nil)
    
    local text = string.format("%.2d:%.2d", value / 60 % 60, value % 60)
    
    self._labelTimeEnergy:sourceView():setText(text)
end

function ViewUIMap.setTimeBonus(self, value)
    
    assert(value ~= nil)
    
    local text = string.format("%.2d:%.2d:%.2d", value / (60 * 60) % 60, value / 60 % 60, value % 60)
    
    self._labelTimeBonus:sourceView():setText(text)
end

--
--Methods
--

function ViewUIMap.init(self, params)
    
    ViewBase.init(self, params)
    
    self._sourceView = display.newGroup()
    
    local managerResources = GameInfo:instance():managerResources()
    local managerString    = GameInfo:instance():managerString()
    self._viewGrass = self:createSprite(managerResources:getAsImage(EResourceType.ERT_STATE_MAP_VIEW_GRASS))
    
    self._buttonSound           = self:createButton(managerResources:getAsButton(EResourceType.ERT_STATE_MAP_BUTTON_SOUND))
    self._buttonSoundDisabled   = self:createButton(managerResources:getAsButton(EResourceType.ERT_STATE_MAP_BUTTON_SOUND_DISABLED))
    self._buttonHelp            = self:createButton(managerResources:getAsButton(EResourceType.ERT_BUTTON_HELP))
    self._buttonBonus           = self:createButton(managerResources:getAsButton(EResourceType.ERT_STATE_MAP_BUTTON_BONUS))
    
    self._viewTimeBonus         = self:createSprite(managerResources:getAsImage(EResourceType.ERT_STATE_MAP_VIEW_TIME_BONUS))
    self._labelTimeBonus        = self:createLabel("0", EFontType.EFT_0)
    
    self._labelTimeBonus:sourceView().xScale = self._labelTimeBonus:sourceView().xScale * 0.5
    self._labelTimeBonus:sourceView().yScale = self._labelTimeBonus:sourceView().xScale
    
    self._buttonFreeCurrency    = self:createButton(managerResources:getAsButton(EResourceType.ERT_STATE_MAP_BUTTON_FREE_CURRENCY),
    nil,
    managerString:getString(EStringType.EST_STATE_MAP_FREE_CURRENCY),
    EFontType.EFT_1)
    
    self._viewCurrency          = self:createSprite(managerResources:getAsImage(EResourceType.ERT_VIEW_CURRENCY))
    
    self._labelCurrencySoft     = self:createLabel("%i", EFontType.EFT_0, ELabelTextAlign.ELTA_RIGHT, nil, 0, application.animation_duration * 4)
    self._labelCurrencySoft:sourceView():setColorHex("0xFFB600")
    
    self._buttonBuyCurrency     = self:createButton(managerResources:getAsButton(EResourceType.ERT_BUTTON_SHOP))
    
    self._viewEnergy            = self:createSprite(managerResources:getAsImage(EResourceType.ERT_STATE_MAP_VIEW_ENERGY))
    self._labelEnergy           = self:createLabel("%i",  EFontType.EFT_0, ELabelTextAlign.ELTA_RIGHT, nil, 0, application.animation_duration * 4)
    self._labelEnergy:sourceView():setColorHex("0xFFB600")
    
    self._buttonBuyEnergy       = self:createButton(managerResources:getAsButton(EResourceType.ERT_BUTTON_SHOP))
    
    self._viewTimeEnergy        = self:createSprite(managerResources:getAsImage(EResourceType.ERT_STATE_MAP_VIEW_TIME_ENERGY))
    self._labelTimeEnergy       = self:createLabel("0", EFontType.EFT_0)
    
    self._labelTimeEnergy:sourceView().xScale = self._labelTimeEnergy:sourceView().xScale * 0.5
    self._labelTimeEnergy:sourceView().yScale = self._labelTimeEnergy:sourceView().xScale
end

function ViewUIMap.placeViews(self)
    
    ViewBase.placeViews(self)
    
    self._viewGrass:sourceView().x = display.contentCenterX
    self._viewGrass:sourceView().y = application.margin_bottom -  self._viewGrass:realHeight() / 2
    
    local buttonsOffsetY = application.margin_bottom - self._buttonSound:realHeight() / 2 - 5
    
    self._buttonSound:sourceView().x = application.margin_left + self._buttonSound:realWidth() / 2 + 20
    self._buttonSound:sourceView().y = buttonsOffsetY
    
    self._buttonSoundDisabled:sourceView().x = self._buttonSound:sourceView().x
    self._buttonSoundDisabled:sourceView().y = self._buttonSound:sourceView().y
    
    self._buttonHelp:sourceView().x = self._buttonSound:sourceView().x + self._buttonSound:realWidth() / 2 + self._buttonHelp:realWidth() / 2 + 5
    self._buttonHelp:sourceView().y = self._buttonSound:sourceView().y
    
    self._buttonBonus:sourceView().x = self._buttonHelp:sourceView().x + self._buttonBonus:realWidth() / 2 + self._buttonHelp:realWidth() / 2 + 5
    self._buttonBonus:sourceView().y = self._buttonSound:sourceView().y
    
    self._viewTimeBonus:sourceView().x = self._buttonBonus:sourceView().x
    self._viewTimeBonus:sourceView().y = self._buttonBonus:sourceView().y - self._buttonBonus:realHeight() / 2 - self._viewTimeBonus:realHeight() / 2  + 5
    
    self._labelTimeBonus:sourceView().x = self._viewTimeBonus:sourceView().x
    self._labelTimeBonus:sourceView().y = self._viewTimeBonus:sourceView().y
    
    self._buttonFreeCurrency:sourceView().x = self._buttonBonus:sourceView().x + self._buttonBonus:realWidth() / 2 + self._buttonFreeCurrency:realWidth() / 2 + 5
    self._buttonFreeCurrency:sourceView().y = self._buttonSound:sourceView().y
    
    self._viewCurrency:sourceView().x = application.margin_left + self._viewCurrency:realWidth() / 2 + 10
    self._viewCurrency:sourceView().y = application.margin_top +  self._viewCurrency:realHeight() / 2 + 0
    
    self._buttonBuyCurrency:sourceView().x = self._viewCurrency:sourceView().x + self._viewCurrency:realWidth() / 2 - self._buttonBuyCurrency:realWidth() / 2 - 5
    self._buttonBuyCurrency:sourceView().y = self._viewCurrency:sourceView().y
    
    self._labelCurrencySoft:sourceView().x = self._buttonBuyCurrency:sourceView().x - self._buttonBuyCurrency:realWidth() / 2 - 5
    self._labelCurrencySoft:sourceView().y = self._buttonBuyCurrency:sourceView().y
    
    self._viewEnergy:sourceView().x = application.margin_right - self._viewCurrency:realWidth() / 2 - 10
    self._viewEnergy:sourceView().y = application.margin_top +  self._viewCurrency:realHeight() / 2 + 4
    
    self._buttonBuyEnergy:sourceView().x = self._viewEnergy:sourceView().x + self._viewEnergy:realWidth() / 2 - self._buttonBuyEnergy:realWidth() / 2 - 5
    self._buttonBuyEnergy:sourceView().y = self._viewEnergy:sourceView().y - 5
    
    
    self._labelEnergy:sourceView().x = self._buttonBuyEnergy:sourceView().x - self._buttonBuyEnergy:realWidth() / 2 - 5
    self._labelEnergy:sourceView().y = self._buttonBuyEnergy:sourceView().y
    
    self._viewTimeEnergy:sourceView().x = self._buttonBuyEnergy:sourceView().x
    self._viewTimeEnergy:sourceView().y = self._buttonBuyEnergy:sourceView().y + self._buttonBuyEnergy:realHeight() / 2 +  self._viewTimeEnergy:realHeight() / 2
    
    self._labelTimeEnergy:sourceView().x = self._viewTimeEnergy:sourceView().x
    self._labelTimeEnergy:sourceView().y = self._viewTimeEnergy:sourceView().y
end

function ViewUIMap.cleanup(self)
    
    self._viewGrass:cleanup()
    self._viewGrass = nil
    
    ViewBase.cleanup(self)
end