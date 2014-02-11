ViewMapItemCurrent = classWithSuper(ViewMapItemBase, 'ViewMapItemCurrent')

--
-- Properties 
--


--
-- Methods
--

function ViewMapItemCurrent.init(self, params)
    ViewMapItemBase.init(self, params)
    
    self:createButtonItem(EResourceType.ERT_STATE_MAP_ITEM_CURRENT)
    
end

function ViewMapItemCurrent.placeViews(self)
    ViewMapItemBase.placeViews(self)
end



