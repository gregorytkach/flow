ViewMapItemBase = classWithSuper(ViewBase, 'ViewMapItemBase')

--
-- Properties
-- 


function ViewMapItemBase.button(self)
    return self._button
end

--
-- Methods
--

function ViewMapItemBase.init(self, params)
    ViewBase.init(self, params)
    
    self._sourceView = display.newGroup()
    
end

function ViewMapItemBase.createButtonItem(self, buttonType)
    self._button = self:createButton(GameInfo:instance():managerResources():getAsButton(buttonType))
end

function ViewMapItemBase.createImageItem(self, imageType)
    self._image = self:createButton(GameInfo:instance():managerResources():getAsImage(imageType))
end



function ViewMapItemBase.placeViews(self)
    ViewBase.placeViews(self)
    
end

function ViewMapItemBase.getParamsTweenShow(self, time, callback)
    
    if(time == nil)then
        time = application.animation_duration * 2
    end
    
    local result = 
    {
        time        = time,
        xScale      = 1,
        yScale      = 1,
        transition  = GameInfo:instance():managerStates():easingProvider().easeOutBounce,
        onComplete  = 
        function()
            if(callback ~= nil)then
                callback()
            end
        end
    }
    
    return result
end

function ViewMapItemBase.getParamsTweenHide(self, time, callback)
    
    if(time == nil)then
        time = application.animation_duration * 2
    end
    
    local result = 
    {
        time        = time,
        xScale      = 0.01,
        yScale      = 0.01,
        transition  = GameInfo:instance():managerStates():easingProvider().easeInBounce,
        onComplete  = 
        function()
            if(callback ~= nil)then
                callback()
            end
        end
    }
    
    return result
end

function ViewMapItemBase.cleanup(self)
    
    if(self._button ~= nil)then
        self._button:cleanup()
        self._button = nil
    end
    
    if(self._image ~= nil)then
        self._image:cleanup()
        self._image = nil
    end
    
    ViewBase.cleanup(self)
end


