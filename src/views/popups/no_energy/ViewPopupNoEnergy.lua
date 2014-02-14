require('game_flow.src.views.popups.no_resource.ViewPopupNoResource')
ViewPopupNoEnergy = classWithSuper(ViewPopupNoResource, 'ViewPopupNoEnergy')

--
-- Properties
--

--
-- Methods
--

function ViewPopupNoEnergy.init(self, params)
    ViewPopupNoResource.init(self, params)
    
    self:initTitle(EStringType.EST_POPUP_NO_ENERGY_TITLE)
    
    self:initText(EStringType.EST_POPUP_NO_ENERGY_TEXT)
    
    self:initIcon(EResourceType.ERT_ICON_ENERGY)
    
end

function ViewPopupNoEnergy.placeViews(self)
    ViewPopupNoResource.placeViews(self)
    
end

