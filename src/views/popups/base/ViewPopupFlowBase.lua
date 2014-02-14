ViewPopupFlowBase = classWithSuper(ViewPopup, 'ViewPopupFlowBase')

function ViewPopupFlowBase.init(self, params)
    ViewPopup.init(self, params)
    
    self._sourceView = display.newGroup()
end

function ViewPopupFlowBase.initBackground(self, image)
    self._background = self:createSprite(image) 
end

function ViewPopupFlowBase.initTitle(self, stringType)
    self._labelTitle = self:createLabel(GameInfo:instance():managerString():getString(stringType), EFontType.EFT_2)
    self._labelTitle:sourceView():setColorHex("0x478733")
end


function ViewPopupFlowBase.placeViews(self)
    
    local realHeight = self._background:realHeight()
    
    self._background:sourceView().x = 0
    self._background:sourceView().y = 0
    
    ViewPopup.placeViews(self)
end


function ViewPopupFlowBase.cleanup(self)
    
    self._background:cleanup()
    self._background = nil
    
    self._labelTitle:cleanup()
    self._labelTitle = nil
    
    ViewPopup.cleanup(self)
end

