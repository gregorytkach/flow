ViewUI = classWithSuper(ViewBase, 'ViewUI')


--
--Properties
--

function ViewUI.setViewPurchases(self, value)
    if(self._viewPurchases == value)then
        return 
    end
    
    self._viewPurchases = value
    self._sourceView:insert(self._viewPurchases:sourceView())
end

function ViewUI.buttonHelp(self)
    return self._buttonHelp
end

function ViewUI.buttonHome(self)
    return self._buttonHome
end

function ViewUI.buttonShop(self)
    return self._buttonShop
end

function ViewUI.labelCurrencySoft(self)
    return self._labelCurrencySoft
end

function ViewUI.setTime(self, value)
    
    assert(value ~= nil)
    
    local text = string.format("%.2d:%.2d", value / 60 % 60, value % 60)
    
    self._labelTime:sourceView():setText(text)
end

function ViewUI.labelTime(self)
    return self._labelTime
end

--
--Methods
--

function ViewUI.init(self, params)
    
    ViewBase.init(self, params)
    
    local managerResources = GameInfo:instance():managerResources()
    
    self._sourceView  = display.newGroup()
    
    self._viewCurrency = self:createSprite(managerResources:getAsImage(EResourceType.ERT_VIEW_CURRENCY))
    self._viewTime = self:createSprite(managerResources:getAsImage(EResourceType.ERT_STATE_GAME_VIEW_TIME)) 
    
    self._buttonShop = self:createButton(managerResources:getAsButton(EResourceType.ERT_BUTTON_SHOP))
    self._buttonHelp = self:createButton(managerResources:getAsButton(EResourceType.ERT_BUTTON_HELP))
    self._buttonHome = self:createButton(managerResources:getAsButton(EResourceType.ERT_STATE_GAME_BUTTON_HOME))
    
    self._labelCurrencySoft    = self:createLabel("%i", EFontType.EFT_0, nil, nil, nil, nil,
    {
        value       = 0,
        timeUpdate  = application.animation_duration * 2
    })
    self._labelCurrencySoft:sourceView():setColorHex("0xFFB600")
    
    self._labelTime     = self:createLabel("0:0", EFontType.EFT_0)
end

function ViewUI.placeViews(self)
    
    ViewBase.placeViews(self)
    
    local offsetX = 5
    local offsetY = 5
    
    local widthMax = (application.content.width - display.screenOriginX * 2) - 10
    
    local scaleWidth = 1
    
    local realWidth = self._buttonHome:realWidth() + self._viewCurrency:realWidth() + self._buttonShop:realWidth() + self._viewTime:realWidth() + 25
    
    if realWidth > widthMax  then
        scaleWidth =  widthMax / realWidth
    end
    
    local function scaleView(object) 
        assert(object ~= nil)
        object:sourceView().xScale = object:sourceView().xScale * scaleWidth
        object:sourceView().yScale = object:sourceView().xScale
        
    end
    
    
    scaleView(self._buttonHome)
    self._buttonHome:sourceView().x =  application.margin_left + self._buttonHome:realWidth() / 2 + offsetX 
    self._buttonHome:sourceView().y =  application.margin_top + self._buttonHome:realHeight() / 2 + offsetY 
    
    scaleView(self._buttonHelp)
    self._buttonHelp:sourceView().x = application.margin_right - self._buttonHelp:realHeight() / 2 - offsetX
    self._buttonHelp:sourceView().y = application.margin_top + self._buttonHome:realHeight() / 2 + offsetY
    
    scaleView(self._viewCurrency)
    self._viewCurrency:sourceView().x = self._buttonHome:sourceView().x + self._buttonHome:realWidth() / 2 + self._viewCurrency:realWidth() / 2
    self._viewCurrency:sourceView().y = application.margin_top + self._viewCurrency:realHeight() / 2 + offsetY
    
    scaleView(self._labelCurrencySoft)
    self._labelCurrencySoft:sourceView().x  = self._viewCurrency:sourceView().x + 5
    self._labelCurrencySoft:sourceView().y  = self._viewCurrency:sourceView().y
    
    scaleView(self._buttonShop)
    self._buttonShop:sourceView().x = self._viewCurrency:sourceView().x + self._viewCurrency:realWidth() / 2 - self._buttonShop:realWidth() / 2 - 5
    self._buttonShop:sourceView().y = self._viewCurrency:sourceView().y 
    
    scaleView(self._viewTime)
    self._viewTime:sourceView().x = self._viewCurrency:sourceView().x + self._viewCurrency:realWidth() / 2 + self._viewTime:realWidth() / 2 + offsetX
    self._viewTime:sourceView().y = application.margin_top + self._viewTime:realHeight() / 2 + offsetY
    
    scaleView(self._labelTime)
    self._labelTime:sourceView().x  = self._viewTime:sourceView().x + 15
    self._labelTime:sourceView().y  = self._viewTime:sourceView().y
    
    
    scaleWidth = GameInfo:instance():managerStates():currentState():scaleWidth()
    self._viewPurchases:placeViews()
    scaleView(self._viewPurchases)
    
    self._viewPurchases:sourceView().x = display.contentCenterX - self._viewPurchases:realWidth() / 2
    self._viewPurchases:sourceView().y = application.margin_bottom - self._viewPurchases:realHeight() * 0.45 
end



function ViewUI.cleanup(self)
    
    self._buttonHome:cleanup()
    self._buttonHome = nil
    
    self._buttonHelp:cleanup()
    self._buttonHelp = nil
    
    self._buttonShop:cleanup()
    self._buttonShop = nil
    
    self._viewCurrency:cleanup()
    self._viewCurrency = nil
    
    self._labelCurrencySoft:cleanup()
    self._labelCurrencySoft = nil
    
    self._labelTime:cleanup()
    self._labelTime = nil
    
    self._viewTime:cleanup()
    self._viewTime = nil
    
    ViewBase.cleanup(self)
end
