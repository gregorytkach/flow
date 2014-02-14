require('game_flow.src.models.particles.EParticleType')

ManagerParticles = classWithSuper(ManagerParticlesBase, 'ManagerParticles')

--
--Properties
--


--
--Methods
--

function ManagerParticles.init(self)
    ManagerParticlesBase.init(self)


    
end

function ManagerParticles.loadParticles(self)
    self:_loadParticle(EParticleType.EPT_COLLISION)
    
    ManagerParticlesBase.loadParticles(self)
end



function ManagerParticles._loadParticle(self, particleType)
    local particleProperties
    
    --todo:implement
    if(particleType == EParticleType.EPT_COLLISION)then
        
        -- particleProperties = self:_getParticleCollision()
        
    else
        
        assert(false)
        
    end
    
    -- DEFINE PARTICLE TYPE PROPERTIES
    self._particleProvider.CreateParticleType(particleType, particleProperties)  
end

function ManagerParticles._getParticleCollision(self)
    local result = 
    {
        imageWidth          = 50,
        imageHeight         = 50,
        
        lifeTime            = application.animation_duration * 4 * 2, 	-- MAX. LIFETIME OF A PARTICLE
        weight              = 1.7,
        directionVariation  = 45,
        
        velocityStart       = 350,      -- PIXELS PER SECOND
        velocityVariation   = 200,
        velocityChange      = 0,
        
        rotationStart       = 0,
        rotationChange      = 360,
        rotationVariation   = 0,
        autoOrientation     = false,	-- ROTATE TO MOVEMENT DIRECTION
        useEmitterRotation  = false,
        
        alphaStart          = 1,
        alphaVariation      = 0,
        fadeInSpeed         = 0,	-- PER SECOND
        fadeOutSpeed        = -0.1,	-- PER SECOND
        fadeOutDelay        = application.animation_duration * 4 * 3,	-- WHEN TO START FADE-OUT
        
        --todo: review this hack with scale 
        scaleStart          = application.scaleMin, 	-- PARTICLE INITIAL SCALE
        scaleVariation      = 0,
        scaleInSpeed        = 0,
        scaleMax            = 1,
        scaleOutDelay       = 0,
        scaleOutSpeed       = 0,
        
        colorModification   = true,
        colorStartR         = 0,
        colorStartG         = 0,
        colorStartB         = 0,
        colorChangeR        = 0,
        colorChangeG        = 0,
        colorChangeB        = 0,
        
        emissionShape       = 0,
        emissionRadius      = 1,
        emmissionAngle      = 360,
        
        randomMotionMode        = 0,
        randomMotionInterval    = 1,
        randomMotionAmount      = 1,
        
        emissionRate        = 5,
        emissionAngle       = 360,
        
        killOutsideScreen   = false,	-- KILL OFF-SCREEN PARTICLES 
    }
    
    return result
end

