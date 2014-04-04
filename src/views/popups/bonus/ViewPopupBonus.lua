
ViewPopupBonus = classWithSuper(ViewPopupFlowBase, 'ViewPopupBonus')

--
-- Properties
--

function ViewPopupBonus.setTime(self, value)
    assert(value ~= nil)
    
    self._labelTime:sourceView():setText(string.format("%.2d:%.2d:%.2d", value / (60 * 60) % 60, value / 60 % 60, value % 60))
end

function ViewPopupBonus.buttonSpin(self)
    return self._buttonSpin
end

function ViewPopupBonus.setReward(self, value, type)
    assert(value ~= nil)
    
    self:showIconReward(type)
    
    --place icon
    self._labelRewardCount:sourceView():setText(value)
    self:placeIconReward()
    self._labelRewardCount:setValue(0)
    
    
    self._labelRewardCount:setValue(value)
end

function ViewPopupBonus.setBonus(self, value, callback)
    assert(value ~= nil)
    
    self._viewDrum:sourceView().rotation = 0
    
    local easingProvider = GameInfo:instance():managerStates():easingProvider()
    
    local tweenParam =
    {
        rotation    = -720 - value * self._bonusAngleDelta + self._bonusAngleDelta,
        time        = application.animation_duration * 4 * 5,
        transition  = easingProvider.easeOut,
        onComplete  = 
        function()
            self._tweenDrum = nil
            if(callback ~= nil)then
                callback()
            end
        end
    }
    
    self._tweenDrum = transition.to(self._viewDrum:sourceView(), tweenParam)
end

--
-- Methods
--

function ViewPopupBonus.init(self, params)
    ViewPopupFlowBase.init(self, params)
    
    local managerResources  = GameInfo:instance():managerResources()
    local managerString     =  GameInfo:instance():managerString()
    
    self:initBackground(managerResources:getPopupBackground(self._controller:getType()))
    self:initTitle(EStringType.EST_POPUP_BONUS_TITLE)
    
    self._buttonSpin = self:createButton(managerResources:getAsButton(EResourceType.ERT_POPUP_BUTTON_GREEN),
    nil,
    managerString:getString(EStringType.EST_POPUP_BONUS_BUTTON_SPIN),
    EFontType.EFT_1)
    
    
    local buttonClose = self:createButton(managerResources:getAsButton(EResourceType.ERT_POPUP_BUTTON_BLUE0),
    nil,
    managerString:getString(EStringType.EST_POPUP_BONUS_BUTTON_CLOSE),
    EFontType.EFT_1)
    
    buttonClose:label():sourceView():setColorHex("0xE5FBFF")
    
    self:setButtonClose(buttonClose)
    
    self._viewDrumBg        = self:createSprite(managerResources:getAsImage(EResourceType.ERT_POPUP_BONUS_VIEW_DRUM))
    self._viewDrum          = self:createSprite(managerResources:getAsImage(EResourceType.ERT_POPUP_BONUS_DRUM))
    self._viewArrow         = self:createSprite(managerResources:getAsImage(EResourceType.ERT_POPUP_BONUS_ARROW))
    
    self._viewReward        = self:createSprite(managerResources:getAsImage(EResourceType.ERT_POPUP_BONUS_VIEW_REWARD))
    self._labelReward       = self:createLabel(managerString:getString(EStringType.EST_POPUP_BONUS_REWARD), EFontType.EFT_2)
    
    self._labelRewardCount  = self:createLabel("%i", EFontType.EFT_0, ELabelTextAlign.ELTA_LEFT, nil, 0, application.animation_duration * 4)
    
    self._labelRewardCount:sourceView():setColorHex("0xFFB600")
    
    self._viewTime      = self:createSprite(managerResources:getAsImage(EResourceType.ERT_POPUP_BONUS_VIEW_TIME))
    self._labelTime     = self:createLabel("0", EFontType.EFT_1)
    
    self._labelTime:sourceView().xScale = self._labelTime:sourceView().xScale * 0.85
    self._labelTime:sourceView().yScale = self._labelTime:sourceView().xScale 
    
    self._iconsReward = 
    {
        [EBonusType.EBT_CURRENCY]           = self:createSprite(managerResources:getAsImage(EResourceType.ERT_POPUP_BONUS_ICON_CURRENCY)),
        [EBonusType.EBT_ENERGY]             = self:createSprite(managerResources:getAsImage(EResourceType.ERT_POPUP_BONUS_ICON_ENERGY)),
        [EBonusType.EBT_PURCHASE_ADD_TIME]  = self:createSprite(managerResources:getAsImage(EResourceType.ERT_POPUP_BONUS_ICON_PURCHASE_ADD_TIME)),
        [EBonusType.EBT_PURCHASE_SHOW_TURN] = self:createSprite(managerResources:getAsImage(EResourceType.ERT_POPUP_BONUS_ICON_PURCHASE_SHOW_TURN)),
        [EBonusType.EBT_PURCHASE_RESOLVE]   = self:createSprite(managerResources:getAsImage(EResourceType.ERT_POPUP_BONUS_ICON_PURCHASE_RESOLVE))
    }
    
    local bonuses = GameInfo:instance():managerBonus():bonuses()
    
    self._bonusAngleDelta = 360 / #bonuses
end

function ViewPopupBonus.showIconReward(self, iconType)
    
    for bonusType, iconView in pairs(self._iconsReward) do
        iconView:sourceView().isVisible = bonusType == iconType
    end
    
end


function ViewPopupBonus.placeViews(self)
    ViewPopupFlowBase.placeViews(self)
    
    local realHeight = self._background:realHeight()
    
    self._labelTitle:sourceView().x = 0 
    self._labelTitle:sourceView().y = 30 - realHeight / 2
    
    self._buttonClose:sourceView().x = 0
    self._buttonClose:sourceView().y = realHeight / 2 - self._buttonClose:realHeight() / 2 - 25
    
    self._buttonSpin:sourceView().x = self._buttonClose:sourceView().x 
    self._buttonSpin:sourceView().y = self._buttonClose:sourceView().y
    
    self._viewDrumBg:sourceView().x =  self._buttonSpin:sourceView().x 
    self._viewDrumBg:sourceView().y =  self._buttonSpin:sourceView().y - self._viewDrumBg:realHeight() / 2 - self._buttonSpin:realHeight() / 2 - 10
    
    self._viewDrum:sourceView().x =  self._viewDrumBg:sourceView().x
    self._viewDrum:sourceView().y =  self._viewDrumBg:sourceView().y
    
    self._viewArrow:sourceView().x =  self._viewDrum:sourceView().x + 1
    self._viewArrow:sourceView().y =  11 + self._viewDrum:sourceView().y - self._viewArrow:realHeight() / 2
    
    self._viewTime:sourceView().x = 30 + self._viewTime:realWidth() / 2
    self._viewTime:sourceView().y =  self._viewDrumBg:sourceView().y - self._viewDrumBg:realHeight() / 2 - self._viewTime:realHeight() / 2 - 10
    
    local viewTimeWidth = self._viewTime:realWidth()
    
    self._labelTime:sourceView().x = self._viewTime:sourceView().x - viewTimeWidth / 2 + viewTimeWidth * 0.3
    self._labelTime:sourceView().y = self._viewTime:sourceView().y + 3
    
    self._viewReward:sourceView().x = self._viewTime:sourceView().x -  self._viewTime:realWidth() / 2 -  self._viewReward:realWidth() / 2 - 3
    self._viewReward:sourceView().y = self._viewTime:sourceView().y + 3
    
    local viewRewardWidth = self._viewReward:realWidth()
    
    self._labelReward:sourceView().x = self._viewReward:sourceView().x - viewRewardWidth / 2 + viewRewardWidth * 0.4
    self._labelReward:sourceView().y = self._viewReward:sourceView().y 
    
    self._labelRewardCount:sourceView().x = self._labelReward:sourceView().x + self._labelReward:realWidth() / 2 + 10
    self._labelRewardCount:sourceView().y = self._labelReward:sourceView().y 
    
    self:placeIconReward()
    
    self:showIconReward(nil)
end

function ViewPopupBonus.placeIconReward(self)
    local labelRewardSource = self._labelRewardCount:sourceView()
    
    for _, iconBonus in pairs( self._iconsReward )do
        iconBonus:sourceView().x = labelRewardSource.x + self._labelRewardCount:realWidth() + iconBonus:realWidth() / 2
        iconBonus:sourceView().y = labelRewardSource.y
    end
end

function ViewPopupBonus.cleanup(self)
    
    if(self._tweenDrum ~= nil)then
        transition.cancel(self._tweenDrum)
        self._tweenDrum = nil
    end
    
    for _, iconBonus in pairs( self._iconsReward )do
        iconBonus:cleanup()
    end
    
    self._iconsReward = nil
    
    self._buttonSpin:cleanup() 
    self._buttonSpin = nil
    
    self._viewDrumBg:cleanup()
    self._viewDrumBg = nil
    
    self._viewDrum:cleanup()
    self._viewDrum = nil
    
    self._viewArrow:cleanup()
    self._viewArrow = nil
    
    self._viewTime:cleanup()
    self._viewTime = nil
    
    self._labelTime:cleanup()
    self._labelTime = nil
    
    self._viewReward:cleanup()
    self._viewReward = nil
    
    self._labelReward:cleanup()
    self._labelReward = nil
    
    self._labelRewardCount:cleanup()
    self._labelRewardCount = nil
    
    ViewPopupFlowBase.cleanup(self)
end


