ViewStubs = classWithSuper(ViewBase, 'ViewStubs')

function ViewStubs.init(self, params)
    
    ViewBase.init(self, params)
    
    self._sourceView = display.newGroup()
    
    self:initStubs()
end

function ViewStubs.initStubs(self)
    self._items = {}
    
    local stubsCollection = {}
    local managerResources = GameInfo:instance():managerResources()
    local managerParticles = GameInfo:instance():managerParticles()
    
    --details
    table.insert(stubsCollection, managerResources:getWall(EWallType.EWT_0))
    table.insert(stubsCollection, managerResources:getWall(EWallType.EWT_1))
    table.insert(stubsCollection, managerResources:getWall(EWallType.EWT_2))
    
    table.insert(stubsCollection, managerResources:getShadow())
    
    --bonuses with particles
    for i = 0, 8, 1 do
        
        local bonusType = EBonusType["EBT_"..i]
        
        table.insert(stubsCollection, managerResources:getBonus(bonusType))
        
        local particlesBonusImages =  managerParticles:getParticleBonusImages(bonusType)
        
        for imageIndex = 1, #particlesBonusImages, 1 do
            table.insert(stubsCollection, particlesBonusImages[imageIndex])
        end
        
    end
    
    --bonuses without particles
    table.insert(stubsCollection, managerResources:getBonus(EBonusType.EBT_9))
    
    for i, stubImageName in ipairs(stubsCollection) do
        local controlStubParams =
        {
            image       = stubImageName,
            controller  = self._controller
        }
        
        local controlStub = ViewSprite:new(controlStubParams)
        self._sourceView:insert(controlStub:sourceView())
        
        table.insert(self._items, controlStub)
    end
    
    local wildStyleParams =
    {
        controller = self
    }
    
    local wildStyle = ViewBase:new(wildStyleParams)
    wildStyle._sourceView =  managerResources:getWildstyle()
    
    self._sourceView:insert(wildStyle:sourceView())
    table.insert(stubsCollection, wildStyle)
    
end