ViewPurchases = classWithSuper(ViewBase, 'ViewPurchases')

--
-- Properties
--

function ViewPurchases.buttonResolve(self)
    return self._buttonResolve
end

function ViewPurchases.setTextButtonResolve(self, value, isIconVisible)
    assert(value ~= nil)
    
    self._labelResolve:sourceView():setText(value)
    
    if(isIconVisible)then
        self._iconCurrencyResolve:show()
    else
        self._iconCurrencyResolve:hide()
    end
end

function ViewPurchases.buttonAddTime(self)
    return self._buttonAddTime
end

function ViewPurchases.setTextButtonAddTime(self, value, isIconVisible)
    assert(value ~= nil)
    
    self._labelAddTime:sourceView():setText(value)
    
    if(isIconVisible)then
        self._iconCurrencyAddTime:show()
    else
        self._iconCurrencyAddTime:hide()
    end
end

function ViewPurchases.buttonShowTurn(self)
    return self._buttonShowTurn
end

function ViewPurchases.setTextButtonShowTurn(self, value, isIconVisible)
    assert(value ~= nil)
    
    self._labelShowTurn:sourceView():setText(value)
    
    if(isIconVisible)then
        self._iconCurrencyShowTurn:show()
    else
        self._iconCurrencyShowTurn:hide()
    end
end



--
-- Methods
-- 

function ViewPurchases.init(self, params)
    ViewBase.init(self, params)
    
    local managerResources = GameInfo:instance():managerResources()
    
    self._sourceView = display.newGroup()
    
    local scaleLabel            = 0.75
    
    self._buttonAddTime         = self:createButton(managerResources:getAsButton(EResourceType.ERT_STATE_GAME_BUTTON_ADD_TIME))
    self._labelAddTime          = self:createLabel("0", EFontType.EFT_1)
    self._iconCurrencyAddTime   = self:createSprite(managerResources:getAsImage(EResourceType.ERT_ICON_CURRENCY))
    
    self:scaleView(self._labelAddTime, scaleLabel)
    self:scaleView(self._iconCurrencyAddTime, scaleLabel * 0.8)
    
    self._buttonResolve         = self:createButton(managerResources:getAsButton(EResourceType.ERT_STATE_GAME_BUTTON_RESOLVE))
    self._labelResolve          = self:createLabel("0", EFontType.EFT_1)
    self._iconCurrencyResolve   = self:createSprite(managerResources:getAsImage(EResourceType.ERT_ICON_CURRENCY))
    
    self:scaleView(self._labelResolve, scaleLabel)
    self:scaleView(self._iconCurrencyResolve, scaleLabel * 0.8)
    
    self._buttonShowTurn        = self:createButton(managerResources:getAsButton(EResourceType.ERT_STATE_GAME_BUTTON_SHOW_TURN))
    self._labelShowTurn         = self:createLabel("0", EFontType.EFT_1)
    self._iconCurrencyShowTurn  = self:createSprite(managerResources:getAsImage(EResourceType.ERT_ICON_CURRENCY))
    
    self:scaleView(self._labelShowTurn, scaleLabel)
    self:scaleView(self._iconCurrencyShowTurn, scaleLabel * 0.8)
    
end

function ViewPurchases.scaleView(self, view, scale)
    assert(view ~= nil)
    
    view:sourceView().xScale = view:sourceView().xScale * scale
    view:sourceView().yScale = view:sourceView().xScale 
end


function ViewPurchases.placeViews(self)
    ViewBase.placeViews(self)
    
    self._buttonAddTime:sourceView().x = 0 + self._buttonAddTime:realWidth() / 2 
    self._buttonAddTime:sourceView().y = 0
    
    self._iconCurrencyAddTime:sourceView().x = self._buttonAddTime:sourceView().x + self._buttonAddTime:realWidth() / 2  - self._iconCurrencyAddTime:realWidth() - 2
    self._iconCurrencyAddTime:sourceView().y = self._buttonAddTime:sourceView().y + self._buttonAddTime:realHeight() / 2 - self._iconCurrencyAddTime:realHeight() - 7
    
    self._labelAddTime:sourceView().x = self._buttonAddTime:sourceView().x + self._buttonAddTime:realWidth() / 2 - 38
    self._labelAddTime:sourceView().y = self._buttonAddTime:sourceView().y + self._buttonAddTime:realHeight() / 2 - 22
    
    self._buttonResolve:sourceView().x = self._buttonAddTime:sourceView().x + self._buttonAddTime:realWidth() / 2 + self._buttonResolve:realWidth() / 2
    self._buttonResolve:sourceView().y = 0
    
    self._iconCurrencyResolve:sourceView().x = self._buttonResolve:sourceView().x + self._buttonResolve:realWidth() / 2  - self._iconCurrencyResolve:realWidth() - 2
    self._iconCurrencyResolve:sourceView().y = self._buttonResolve:sourceView().y + self._buttonResolve:realHeight() / 2 - self._iconCurrencyResolve:realHeight() - 7
    
    self._labelResolve:sourceView().x = self._buttonResolve:sourceView().x + self._buttonResolve:realWidth() / 2 - 38
    self._labelResolve:sourceView().y = self._buttonResolve:sourceView().y + self._buttonResolve:realHeight() / 2 - 22
    
    self._buttonShowTurn:sourceView().x = self._buttonResolve:sourceView().x + self._buttonResolve:realWidth() / 2 + self._buttonShowTurn:realWidth() / 2 
    self._buttonShowTurn:sourceView().y = 0
    
    self._iconCurrencyShowTurn:sourceView().x = self._buttonShowTurn:sourceView().x + self._buttonShowTurn:realWidth() / 2  - self._iconCurrencyShowTurn:realWidth() - 2
    self._iconCurrencyShowTurn:sourceView().y = self._buttonShowTurn:sourceView().y + self._buttonShowTurn:realHeight() / 2 - self._iconCurrencyShowTurn:realHeight() - 7
    
    self._labelShowTurn:sourceView().x = self._buttonShowTurn:sourceView().x + self._buttonShowTurn:realWidth() / 2 - 38
    self._labelShowTurn:sourceView().y = self._buttonShowTurn:sourceView().y + self._buttonShowTurn:realHeight() / 2 - 22
    
end

function ViewPurchases.cleanup(self)
    self._buttonAddTime:cleanup()
    self._buttonAddTime = nil
    
    self._iconCurrencyAddTime:cleanup()
    self._iconCurrencyAddTime = nil
    
    self._labelAddTime:cleanup()
    self._labelAddTime = nil
    
    self._buttonResolve:cleanup()
    self._buttonResolve = nil
    
    self._iconCurrencyResolve:cleanup()
    self._iconCurrencyResolve = nil
    
    self._labelResolve:cleanup()
    self._labelResolve = nil
    
    self._buttonShowTurn:cleanup()
    self._buttonShowTurn = nil
    
    self._iconCurrencyShowTurn:cleanup()
    self._iconCurrencyShowTurn = nil
    
    self._labelShowTurn:cleanup()
    self._labelShowTurn = nil
    
    ViewBase.cleanup(self)
end
