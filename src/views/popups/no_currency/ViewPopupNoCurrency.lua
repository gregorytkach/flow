require('game_flow.src.views.popups.no_resource.ViewPopupNoResource')
ViewPopupNoCurrency = classWithSuper(ViewPopupNoResource, 'ViewPopupNoCurrency')

--
-- Properties
--

--
-- Methods
--

function ViewPopupNoCurrency.init(self, params)
    ViewPopupNoResource.init(self, params)
    
    self:initTitle(EStringType.EST_POPUP_NO_CURRENCY_TITLE)
    
    self:initText(EStringType.EST_POPUP_NO_CURRENCY_TEXT)
    
    self:initIcon(EResourceType.ERT_ICON_CURRENCY)
    
end

function ViewPopupNoCurrency.placeViews(self)
    ViewPopupNoResource.placeViews(self)
    
end

function ViewPopupNoCurrency.cleanup(self)
    ViewPopupNoResource.cleanup(self)
end

