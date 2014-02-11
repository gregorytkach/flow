ViewMapItemComplete = classWithSuper(ViewMapItemBase, 'ViewMapItemComplete')

--
-- Methods
--

function ViewMapItemComplete.init(self, params)
    ViewMapItemBase.init(self, params)
    
    self:createButtonItem(EResourceType.ERT_STATE_MAP_ITEM_COMPLETE)
    
    self._icon = self:createSprite(GameInfo:instance():managerResources():getAsImage(EResourceType.ERT_STATE_MAP_ITEM_COMPLETE_ICON))
    
end


function ViewMapItemBase.createIcon(self)
end


function ViewMapItemBase.animateIcon(self, delay)
    local targetSource = self._icon:sourceView()
    
    local time = application.animation_duration
    
    local paramsTweenDown =
    {
        y           = targetSource.y,
        time        = time,
        onComplete  = 
        function() 
            self._tweenIcon = nil  
        end
    }
    
    local paramsTweenUp = 
    {
        y          = targetSource.y - 10,
        delay      = delay,
        time       = time,
        onComplete = 
        function() 
            self._tweenIcon = nil  
            
            self._tweenIcon = transition.to(targetSource, paramsTweenDown)
        end
    }
    
    self._tweenIcon = transition.to(targetSource, paramsTweenUp)
end


function ViewMapItemComplete.placeViews(self)
    ViewMapItemBase.placeViews(self)
    
    self._icon:sourceView().x = 10
    self._icon:sourceView().y = 10
end

function ViewMapItemComplete.cleanup(self)
    if(self._tweenIcon ~= nil)then
        transition.cancel(self._tweenIcon)
        self._tweenIcon = nil
    end
    
    self._icon:cleanup()
    self._icon = nil
    
    ViewMapItemBase.cleanup(self)
end

