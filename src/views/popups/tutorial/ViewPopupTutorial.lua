ViewPopupTutorial = classWithSuper(ViewPopupFlowBase, 'ViewPopupTutorial')

--
-- Properties
--

function ViewPopupTutorial.buttonNext(self)
    return self._buttonNext 
end

--
-- Methods
--

function ViewPopupTutorial.init(self, params)
    ViewPopupFlowBase.init(self, params)
    
    self._sourceView    = display.newGroup()
    
    local managerResources  = GameInfo:instance():managerResources()
    local managerString     = GameInfo:instance():managerString()
    
    local backgroundImage = managerResources:getPopupBackground(self._controller:getType())
    
    self:initBackground(backgroundImage)
    self:initTitle(EStringType.EST_POPUP_TUTORIAL_TITLE_1)
    
    self._viewTutorial1  = self:createSprite(managerResources:getAsImage(EResourceType.ERT_POPUP_TUTORIAL_VIEW1))
    
    --view2
    self._viewTutorial2             = ViewBase:new({controller = {}})
    self._viewTutorial2._sourceView =  display.newGroup()
    self._sourceView:insert(self._viewTutorial2:sourceView())
    
    self._backgroundTutorial2       = self._viewTutorial2:createSprite(managerResources:getAsImage(EResourceType.ERT_POPUP_TUTORIAL_VIEW_BASE))
    self._viewIcon2                 = self._viewTutorial2:createSprite(managerResources:getAsImage(EResourceType.ERT_STATE_GAME_CELL_BARRIER))
    self._labelStep2                = self._viewTutorial2:createLabel(managerString:getString(EStringType.EST_POPUP_TUTORIAL_TEXT_2), --text
    EFontType.EFT_1, --fontType
    nil,--align
    nil,--wrapWidth
    nil,--value
    nil,--timeUpdate
    {lineSpacing = 5}) --params
    
    self._viewTutorial3             = ViewBase:new({controller = {}})
    self._viewTutorial3._sourceView =  display.newGroup()
    self._sourceView:insert(self._viewTutorial3:sourceView())
    
    self._backgroundTutorial3       = self._viewTutorial3:createSprite(managerResources:getAsImage(EResourceType.ERT_POPUP_TUTORIAL_VIEW_BASE))
    self._viewIcon3                 = self._viewTutorial3:createSprite(managerResources:getAsImage(EResourceType.ERT_STATE_GAME_CELL_BRIDGE))
    self._labelStep3                = self._viewTutorial3:createLabel(managerString:getString(EStringType.EST_POPUP_TUTORIAL_TEXT_3), 
    EFontType.EFT_1, --fontType
    nil,--align
    nil,--wrapWidth
    nil,--value
    nil,--timeUpdate
    {lineSpacing = 5})
    
    --init tutorial
    --    self._viewTutorial2  = self:createSprite(managerResources:getAsImage(EResourceType.ERT_POPUP_TUTORIAL_VIEW2))
    --    self._viewTutorial3  = self:createSprite(managerResources:getAsImage(EResourceType.ERT_POPUP_TUTORIAL_VIEW3))
    
    --        ["ERT_POPUP_BUTTON_BLUE0"]                  = "ERT_POPUP_BUTTON_BLUE0";
    --    ["ERT_POPUP_BUTTON_BLUE1"]                  = "ERT_POPUP_BUTTON_BLUE1";
    --    ["ERT_POPUP_BUTTON_GREEN"]                  = "ERT_POPUP_BUTTON_GREEN";
    
    local buttonClose   = self:createButton(managerResources:getAsButton(EResourceType.ERT_POPUP_BUTTON_GREEN), nil, managerString:getString(EStringType.EST_POPUP_TUTORIAL_BUTTON_CLOSE), EFontType.EFT_2)
    
    self:setButtonClose(buttonClose)
    
    self._buttonNext    =  self:createButton(managerResources:getAsButton(EResourceType.ERT_POPUP_BUTTON_BLUE0), nil, managerString:getString(EStringType.EST_POPUP_TUTORIAL_BUTTON_NEXT), EFontType.EFT_2)
    
    --hide all steps
    self:showStep(0)
end

function ViewPopupTutorial.showStep(self, step)
    
    local managerString = GameInfo:instance():managerString()
    local titleType     = nil
    
    if(step == 1)then
        self._viewTutorial1:show()
        titleType = EStringType.EST_POPUP_TUTORIAL_TITLE_1
    else
        self._viewTutorial1:hide()
    end
    
    if(step == 2)then
        self._viewTutorial2:show()
        titleType = EStringType.EST_POPUP_TUTORIAL_TITLE_2
    else
        self._viewTutorial2:hide()
    end
    
    if(step == 3)then
        self._viewTutorial3:show()
        titleType = EStringType.EST_POPUP_TUTORIAL_TITLE_3
    else
        self._viewTutorial3:hide()
    end
    
    if(titleType ~= nil)then
        self._labelTitle:sourceView():setText(managerString:getString(titleType))
    end
end

function ViewPopupTutorial.placeViews(self)
    
    self._labelTitle:sourceView().y =  - self:realHeight() / 2 + self._labelTitle:realHeight() / 2 + 25
    
    self._buttonNext:sourceView().y  = self:realHeight() / 2 - self._buttonNext:realHeight() / 2 - 30
    self._buttonClose:sourceView().y = self._buttonNext:sourceView().y
    
    self._viewIcon2:sourceView().y   = -self._viewTutorial2:realHeight() / 2 + self._viewIcon2:realHeight() / 2 + 15
    self._labelStep2:sourceView().y  = self._viewTutorial2:realHeight() / 2 - self._labelStep2:realHeight() / 2 - 15
    
    self._viewIcon3:sourceView().y   = -self._viewTutorial2:realHeight() / 2 + self._viewIcon3:realHeight() / 2 + 15
    self._labelStep3:sourceView().y  = self._viewTutorial3:realHeight() / 2 - self._labelStep3:realHeight() / 2 - 15
    
    ViewPopupFlowBase.placeViews(self)
end


function ViewPopupTutorial.cleanup(self)
    
    self._buttonNext:cleanup()
    self._buttonNext = nil
    
    --step1
    self._viewTutorial1:cleanup()
    self._viewTutorial1 = nil
    
    --step2
    self._viewIcon2:cleanup()
    self._viewIcon2 = nil
    
    self._labelStep2:cleanup()
    self._labelStep2 = nil
    
    self._backgroundTutorial2:cleanup()
    self._backgroundTutorial2 = nil
    
    self._viewTutorial2:cleanup()
    self._viewTutorial2 = nil
    
    --step3
    self._viewIcon3:cleanup()
    self._viewIcon3 = nil
    
    self._backgroundTutorial3:cleanup()
    self._backgroundTutorial3 = nil
    
    self._labelStep3:cleanup()
    self._labelStep3 = nil
    
    self._viewTutorial3:cleanup()
    self._viewTutorial3 = nil
    
    ViewPopupFlowBase.cleanup(self)
end

