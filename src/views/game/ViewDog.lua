ViewDog = classWithSuper(ViewBase, 'ViewDog')


--
--Methods
--

function ViewDog.setCurrentAnimation(self, type)
    
    if(self._currentAnimationType == type)then
        assert(false, 'Review this assert')
        return
    end
    
    self._currentAnimationType = type
    
    print(type)
    
    for animationType, animation in pairs(self._animations) do
        
        if (animationType == self._currentAnimationType)then
            animation:play()
            animation.visible = true
        else
            animation.visible = false
            animation:pause()
        end
    end
    
end

function ViewDog.init(self, params)
    
    ViewBase.init(self, params)
    
    assert(params.flow_type ~= nil)
    
    self._sourceView = display.newGroup()
    
    local managerResources = GameInfo:instance():managerResources()
    
    self._animations = {}
    
    local animationIdle =  managerResources:getAsAnimationWithParam(EResourceType.ERT_STATE_GAME_ANIMATION_DOG_IDLE, params.flow_type)
    self._sourceView:insert(animationIdle)
    
    self._animations[EDogAnimationType.EDAT_IDLE] = animationIdle
    
    local animationDown = managerResources:getAsAnimationWithParam(EResourceType.ERT_STATE_GAME_ANIMATION_DOG_DOWN, params.flow_type)
    self._sourceView:insert(animationDown)
    
    self._animations[EDogAnimationType.EDAT_DOWN] = animationDown
    
    local animationUp = managerResources:getAsAnimationWithParam(EResourceType.ERT_STATE_GAME_ANIMATION_DOG_UP, params.flow_type)
    self._sourceView:insert(animationUp)
    
    self._animations[EDogAnimationType.EDAT_UP] = animationUp
    
    self:setCurrentAnimation(EDogAnimationType.EDAT_IDLE)
end


function ViewDog.cleanup(self)
    
    self._animations[EDogAnimationType.EDAT_IDLE]:cleanup()
    self._animations[EDogAnimationType.EDAT_UP]:cleanup()
    self._animations[EDogAnimationType.EDAT_DOWN]:cleanup()
    
    self._animations = nil
    
    self._sourceView:removeSelf()
    self._sourceView = nil
    
    ViewBase.cleanup(self)
end

