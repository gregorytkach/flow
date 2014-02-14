ViewDog = classWithSuper(ViewBase, 'ViewDog')



--
--Methods
--


function ViewDog.init(self, params)
    
    
    ViewBase.init(self, params)
    
    assert(params.flow_type ~= nil)
    
    
    self._sourceView = display.newGroup()
    
    local managerResources = GameInfo:instance():managerResources()
    
    local  image  = managerResources:getAsImageWithParam(EResourceType.ERT_STATE_GAME_DOG_IDLE, params.flow_type)
     
    self._viewDog = self:createSprite(image)
    
end


function ViewDog.cleanup(self)
    
    
    self._viewDog:cleanup()
    self._viewDog = nil
    
    self._sourceView:removeSelf()
    self._sourceView = nil
    
    ViewBase.cleanup(self)
end

