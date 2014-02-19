ViewDog = classWithSuper(ViewBase, 'ViewDog')


--
--Methods
--

function ViewDog.setCurrentAnimation(self, type)
    
    self._currentAnimation:pause()
    self._currentAnimation.isVisible = false
    
    local animation = self._animations[type]
    animation.isVisible = true
    animation:play()
    
    self._currentAnimation = animation
    
end

function ViewDog.init(self, params)
    
    
    ViewBase.init(self, params)
    
    assert(params.flow_type ~= nil)
    
    self._sourceView = display.newGroup()
    
    local managerResources = GameInfo:instance():managerResources()
    
    managerResources:setDogAnimationResource(params.flow_type)
    
    self._animations = {}
    
    local animationIdle = managerResources:getAsAnimation(EResourceType.ERT_STATE_GAME_ANIMATION_DOG_IDLE)
    self._animations[EDogAnimationType.EDAT_IDLE] = animationIdle
    animationIdle:play()
    self._sourceView:insert(animationIdle)
    self._currentAnimation = animationIdle
    
    local animationDown = managerResources:getAsAnimation(EResourceType.ERT_STATE_GAME_ANIMATION_DOG_DOWN)
    self._animations[EDogAnimationType.EDAT_DOWN] = animationDown
    animationDown.isVisible = false
    self._sourceView:insert(animationDown)
    
    local animationUp = managerResources:getAsAnimation(EResourceType.ERT_STATE_GAME_ANIMATION_DOG_UP)
    self._animations[EDogAnimationType.EDAT_UP] = animationUp
    animationUp.isVisible = false
    self._sourceView:insert(animationUp)
    
end


function ViewDog.cleanup(self)
    
    self._animations[EDogAnimationType.EDAT_IDLE]:cleanup()
    self._animations[EDogAnimationType.EDAT_IDLE] = nil
    
    self._animations[EDogAnimationType.EDAT_UP]:cleanup()
    self._animations[EDogAnimationType.EDAT_UP] = nil
    
    self._animations[EDogAnimationType.EDAT_DOWN]:cleanup()
    self._animations[EDogAnimationType.EDAT_DOWN] = nil
    
     self._animations = nil
    
    self._currentAnimation = nil
    
    self._sourceView:removeSelf()
    self._sourceView = nil
    
    ViewBase.cleanup(self)
end

