ViewEffect = classWithSuper(ViewSprite, 'ViewEffect')

--
-- Properties
--

--
-- Methods
--

function ViewEffect.init(self, params)
    ViewSprite.init(self, params)

    self:effectStart()

end

function ViewEffect.effectStart(self)
    assert(self._tweenEffect == nil, "Effect already started")
    
    local animationCount = 1000000
    
    local angle = self._sourceView.rotation + 360 * animationCount
    
    if(math.random(0, 1) == 1)then
        angle = -angle
    end
    
    local time = application.animation_duration * 10 * animationCount
    
    local paramsTween = 
    {
        time        = time,
        rotation    = angle,
        onComplete  =
        function()
            self._tweenEffect = nil
            self:effectStart()
        end
    }
    
    transition.to(self._sourceView, paramsTween)
    
end


function ViewEffect.effectStop(self)
    if(self._tweenEffect == nil)then
        return 
    end
    
    transition.cancel(self._tweenEffect)
    
    self._tweenEffect = nil
end


function ViewEffect.cleanup(self)
    
    self:effectStop()
    
    ViewSprite.cleanup(self)
end

