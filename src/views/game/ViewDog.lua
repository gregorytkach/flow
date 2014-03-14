ViewDog = classWithSuper(ViewBase, 'ViewDog')

--
--Properties
--

function ViewDog.inHouse(self)
    return self._inHouse
end

function ViewDog.setInHouse(self, value)
    
    assert(value ~= nil)
    self._inHouse = value
    
end

function ViewDog.currentAnimation(self)
     
    return self._animations[self._currentAnimationType]
    
end

--
--Methods
--

function ViewDog.setDogPosition(self, sourceCell)
    
    self._sourceView.x = sourceCell.x
    self._sourceView.y = sourceCell.y - 45
    
    
    if  (self._currentAnimationType == EDogAnimationType.EDAT_IDLE) then
        local animation = self._animations[self._currentAnimationType]

        animation.isVisible = not self._inHouse

    end
    
    
end

function ViewDog.setCurrentAnimation(self, type)
    
    if(self._currentAnimationType == type)then
--        assert(false, 'Review this assert')
        return
    end
    
    self._currentAnimationType = type
    
    print(type)
    
    for animationType, animation in pairs(self._animations) do
        if (animationType == self._currentAnimationType)then
            animation:play()
            
            if type == EDogAnimationType.EDAT_IDLE then
                animation.isVisible = not self._inHouse
            else
                animation.isVisible = true
            end
            
        else
            
            
            animation.isVisible = false
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
    
    self._inHouse = false
end


function ViewDog.cleanup(self)
    
    self._animations[EDogAnimationType.EDAT_IDLE]:removeSelf()
    self._animations[EDogAnimationType.EDAT_UP]:removeSelf()
    self._animations[EDogAnimationType.EDAT_DOWN]:removeSelf()
    
    self._animations = nil
    
    self._sourceView:removeSelf()
    self._sourceView = nil
    
    ViewBase.cleanup(self)
end

