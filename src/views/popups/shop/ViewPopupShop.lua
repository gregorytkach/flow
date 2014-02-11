require('game_flow.src.views.popups.shop.ViewPopupShopContent')

ViewPopupShop = classWithSuper(ViewPopupFlowBase, 'ViewPopupShop')


--
--Properties
--

function ViewPopupShop.buttonCurrency(self)
    return self._buttonCurrency
end

function ViewPopupShop.buttonEnergy(self)
    return self._buttonEnergy
end

function ViewPopupShop.contentCurrency(self)
    return self._contentCurrency
end

function ViewPopupShop.contentEnergy(self)
    return self._contentEnergy
end
--
-- Methods
--

function ViewPopupShop.init(self, params)
    ViewPopupFlowBase.init(self, params)
    
    local managerResources = GameInfoBase:instance():managerResources()
    local managerString    = GameInfoBase:instance():managerString()
    local backgroundImage = managerResources:getPopupBackground(self._controller:getType())
    
    self:initBackground(backgroundImage)
    self:initTitle(EStringType.EST_POPUP_SHOP_TITLE)
    
    local buttonClose = self:createButton(managerResources:getAsButton(EResourceType.ERT_POPUP_BUTTON_BLUE0), nil, managerString:getString(EStringType.EST_POPUP_SHOP_BUTTON_CLOSE), EFontType.EFT_1)
    self:setButtonClose(buttonClose)
    
    self._buttonClose:label():sourceView():setColorHex("0xE5FBFF")
    
    self._buttonCurrencyBg      = self:createSprite(managerResources:getAsImage(EResourceType.ERT_POPUP_SHOP_VIEW_ITEM))
    self._buttonCurrency        = self:createButton(managerResources:getAsButton(EResourceType.ERT_POPUP_BUTTON_BLUE1), nil, managerString:getString(EStringType.EST_POPUP_SHOP_BUTTON_CURRENCY), EFontType.EFT_2)
    self._buttonEnergyBg        = self:createSprite(managerResources:getAsImage(EResourceType.ERT_POPUP_SHOP_VIEW_ITEM))
    self._buttonEnergy          = self:createButton(managerResources:getAsButton(EResourceType.ERT_POPUP_BUTTON_BLUE1), nil, managerString:getString(EStringType.EST_POPUP_SHOP_BUTTON_ENERGY), EFontType.EFT_2)
    
    self._contentEnergy = ViewPopupShopContent:new(params)
    self._sourceView:insert(self._contentEnergy:sourceView())
    
    self._contentCurrency = ViewPopupShopContent:new(params)
    self._sourceView:insert(self._contentCurrency:sourceView())
    
end

function ViewPopupShop.placeViews(self)
    ViewPopupFlowBase.placeViews(self)
    
    local realHeight = self._background:realHeight()
    
    self._labelTitle:sourceView().x = 0
    self._labelTitle:sourceView().y = 30 - realHeight / 2
    
    self._contentCurrency:placeViews()
    local contentOffsetY = 110 - realHeight / 2
    
    self._buttonCurrency:sourceView().x = -5 -  self._buttonCurrency:realWidth() / 2
    self._buttonCurrency:sourceView().y = contentOffsetY
    
    self._buttonCurrencyBg:sourceView().x = self._buttonCurrency:sourceView().x
    self._buttonCurrencyBg:sourceView().y = self._buttonCurrency:sourceView().y 
    
    self._buttonEnergy:sourceView().x = 15 +  self._buttonEnergy:realWidth() / 2
    self._buttonEnergy:sourceView().y = contentOffsetY
    
    self._buttonEnergyBg:sourceView().x = self._buttonEnergy:sourceView().x
    self._buttonEnergyBg:sourceView().y = self._buttonEnergy:sourceView().y 
    
    contentOffsetY = contentOffsetY + self._buttonCurrency:realHeight()
    
    self._contentCurrency:sourceView().x = 5
    self._contentCurrency:sourceView().y = contentOffsetY
    
    self._contentEnergy:placeViews()
    
    self._contentEnergy:sourceView().x = 5
    self._contentEnergy:sourceView().y = contentOffsetY
    
    self._buttonClose:sourceView().y = realHeight / 2 - self._buttonClose:realHeight() / 2 - 30 
    
end

function ViewPopupShop.cleanup(self)
    
    self._buttonCurrencyBg:cleanup()
    self._buttonCurrencyBg = nil
    
    self._buttonCurrency:cleanup()
    self._buttonCurrency = nil
    
    self._buttonEnergyBg:cleanup()
    self._buttonEnergyBg = nil
    
    self._buttonEnergy:cleanup()
    self._buttonEnergy = nil
    
    self._contentEnergy:cleanup()
    self._contentEnergy = nil
    
    self._contentCurrency:cleanup()
    self._contentCurrency = nil
    
    ViewPopupFlowBase.cleanup(self)
end
