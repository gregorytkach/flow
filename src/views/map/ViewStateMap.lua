require('game_flow.src.views.map.ViewItems')

ViewStateMap = classWithSuper(ViewStateBase, 'ViewStateMap')


--
--Properties
--

function ViewStateMap.isMapRightExists(self)
    return self._currentMapIndex < Constants.COUNT_MAPS - 1
end


function ViewStateMap.isMapLeftExists(self)
    return self._currentMapIndex > 0
end


function ViewStateMap.viewItems(self)
    return self._viewItems
end
--
-- Events
--

function ViewStateMap.touch(self, event)
    
    if(event.phase == ETouchEvent.ETE_BEGAN)then
        self._x = event.x
    elseif (event.phase == ETouchEvent.ETE_MOVED) then
        
        if(self._x ~= nil)then
            
            local dx = event.x - self._x
            
            self._distance = self._distance + dx
            
            --need translate right
            if(dx < 0)then
                
                if(not self:isMapRightExists())then
                    self._distance = math.max(0, self._distance)
                end
                
                if (self._distance < -self._mapPartWidth) and self:isMapRightExists()  then -- move right
                    
                    self._currentMapIndex = self._currentMapIndex + 1
                    
                    if(self._mapLeft ~= nil)then
                        self._mapLeft:cleanup()
                        self._mapLeft = nil
                    end
                    
                    self._mapLeft   = self._mapCenter
                    self._mapCenter = self._mapRight
                    
                    
                    if(self:isMapRightExists())then
                        self._mapRight                  = self:createMap(self._currentMapIndex + 1)
                        self._mapRight:sourceView().y   = self._mapCenter:sourceView().y 
                    else
                        self._mapRight = nil
                    end
                    
                    self._distance = 0 --self._distance - self._mapPartWidth
                end 
            end
            
            --need translate left
            if(dx > 0)then
                
                if(not self:isMapLeftExists())then
                    self._distance = math.min(0, self._distance)
                end
                
                if (self._distance >  self._mapPartWidth) and self:isMapLeftExists()  then --move left
                    
                    self._currentMapIndex = self._currentMapIndex - 1
                    
                    if(self._mapRight ~= nil)then
                        self._mapRight:cleanup()
                        self._mapRight = nil
                    end
                    
                    self._mapRight = self._mapCenter
                    self._mapCenter = self._mapLeft
                    
                    if(self:isMapLeftExists())then
                        self._mapLeft                   = self:createMap(self._currentMapIndex - 1)
                        self._mapLeft:sourceView().y    = self._mapCenter:sourceView().y 
                    else
                        self._mapLeft  = nil
                    end
                    
                    self._distance = 0 -- self._distance - self._mapPartWidth 
                    
                end
            end
            
            if(self._mapLeft ~= nil)then
                self._mapLeft:sourceView().x    = self._distance - self._mapPartWidth - 5
            end
            
            self._mapCenter:sourceView().x      = self._distance  
            
            if(self._mapRight ~= nil)then
                self._mapRight:sourceView().x   = self._distance  + self._mapPartWidth + 5
            end
            
            self._viewItems:sourceView().x    = -self._mapPartWidth * self._currentMapIndex + self._distance
            
            self._x = event.x 
            
        end
        
    elseif (event.phase == ETouchEvent.ETE_ENDED) or (event.phase == ETouchEvent.ETE_CANCELLED) then    
        self._x = nil
    end
    
end

--
--Methods
--



function ViewStateMap.init(self, params)
    
    ViewStateBase.init(self, params)
    
    self._managerResources = GameInfo:instance():managerResources()
    
    self._currentMapIndex  = 0
    
    if(self._currentMapIndex > 0)then
        self._mapLeft     = self:createMap(self._currentMapIndex - 1)
    end
    
    self._mapCenter     = self:createMap(self._currentMapIndex)
    
    if(self._currentMapIndex < Constants.COUNT_MAPS)then
        self._mapRight      = self:createMap(self._currentMapIndex + 1)
    end
    
    self._mapPartWidth  = self._mapCenter:realWidth()
    
    self._distance           = 0
    
    self._viewItems = ViewItems:new(params)
    self._sourceView:insert(self._viewItems:sourceView())
    
    Runtime:addEventListener(ERuntimeEvent.ERE_TOUCH, self)
end

function ViewStateMap.createMap(self, value)
    local result = self:createSprite(self._managerResources:getAsImageWithParam(EResourceType.ERT_STATE_MAP_MAP_PART, value))
    
    result:sourceView():toBack()
    
    result:sourceView().anchorX = 0
    
    return result
end

function ViewStateMap.placeViews(self)
    
    ViewStateBase.placeViews(self)
    
    local mapOffsetY = application.margin_top + self._mapCenter:realHeight() / 2
    
    if(self._mapLeft ~= nil)then
        self._mapLeft:sourceView().x = self._distance - self._mapPartWidth - 5
        self._mapLeft:sourceView().y = mapOffsetY
    end
    
    self._mapCenter:sourceView().x = self._distance
    self._mapCenter:sourceView().y = mapOffsetY
    
    if(self._mapRight ~= nil) then
        self._mapRight:sourceView().x = self._distance  + self._mapPartWidth + 5
        self._mapRight:sourceView().y = mapOffsetY
    end
    
    self._viewItems:placeViews()
    self._viewItems:sourceView().x    = -self._mapPartWidth * self._currentMapIndex + self._distance
end

function ViewStateMap.cleanup(self)
    
    Runtime:removeEventListener(ERuntimeEvent.ERE_TOUCH, self)
    
    self._viewItems:cleanup()
    self._viewItems = nil
    
    if(self._mapLeft ~= nil)then
        self._mapLeft:cleanup()
        self._mapLeft = nil
    end
    
    self._mapCenter:cleanup()
    self._mapCenter = nil
    
    if(self._mapRight ~= nil)then
        self._mapRight:cleanup()
        self._mapRight = nil
    end
    
    self._managerResources = nil
    
    ViewStateBase.cleanup(self)
end