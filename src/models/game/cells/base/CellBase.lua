require('game_flow.src.models.game.cells.base.ECellType')

CellBase = classWithSuper(Object, 'CellBase')

--
--Properties
--
function CellBase.needManageMemory(self)
    return false
end

function CellBase.view(self)
    return self._controller:view()
end

function CellBase.controller(self)
    return self._controller
end

function CellBase.x(self)
    return self._x
end

function CellBase.y(self)
    return self._y
end

function CellBase.type(self)
    assert(false, 'Please override')
end

function CellBase.flowType(self)
    return self._flowType
end


function CellBase.cellPrev(self)
    return self._cellPrev
end

function CellBase.cellNext(self)
    return self._cellNext
end

function CellBase.setCellNext(self, value)
    
    
    if(self._cellNext == value)then
        return
    end
    
    if(value == nil and self._cellNext ~= nil)then
        
        if(self._cellNext:type() ~= ECellType.ECT_FLOW_POINT)then
            self._cellNext._flowType = EFlowType.EFT_NONE
        end
        
        self._cellNext._cellPrev = nil
        
        self._cellNext._controller:update(EControllerUpdate.ECUT_EXCLUSION_FROM_LINE)
    end
    
    self._cellNext = value
    
    if(self._cellNext ~= nil)then
        
        assert(self._cellNext._cellPrev == nil)
        
        self._cellNext._cellPrev = self
        self._cellNext._flowType = self._flowType
        
        self._cellNext._controller:update(EControllerUpdate.ECUT_INCLUSION_IN_LINE)
        
    end
    
    self._controller:update(EControllerUpdate.ECUT_CELL_NEXT)
    
end

function CellBase.isPurchased(self)
    return self._isPurchased
end

--
-- Events
-- 

function CellBase.onPurchased(self, flowType)
    print(self._x..' '..self._y)
    print(flowType)
    assert(not self._isPurchased, 'Cell already purchased')
    assert(flowType ~= nil)
    
    self._isPurchased   = true
    self._flowType      = flowType
    
    self._controller:update(EControllerUpdate.ECUT_CELL_PURCHASED)
end

--
-- neighbors
--

function CellBase.neighborUp(self)
    return self._neighborUp
end

function CellBase.setNeighborUp(self, value)
    self._neighborUp = value
end

function CellBase.neighborDown(self)
    return self._neighborDown
end

function CellBase.setNeighborDown(self, value)
    self._neighborDown = value
end

function CellBase.neighborLeft(self)
    return self._neighborLeft
end

function CellBase.setNeighborLeft(self, value)
    self._neighborLeft = value
end

function CellBase.neighborRight(self)
    return self._neighborRight
end

function CellBase.setNeighborRight(self, value)
    self._neighborRight = value
end

function CellBase.setController(self, value)
    assert(value            ~= nil)
    assert(self._controller == nil)
    
    self._controller = value
    
end

--
--Events
--

--
--Methods
--

function CellBase.init(self, params)
    assert(params               ~= nil)
    assert(params.flow_type     ~= nil)
    assert(params.x             ~= nil)
    assert(params.y             ~= nil)
    
    self._flowType      = params.flow_type
    self._x             = params.x
    self._y             = params.y
    self._isPurchased   = false
    
end


--
--restore line logic
--

function CellBase.cacheState(self)
    if(self._isPurchased)then
        return
    end
    
    self._cellPrevCached = self._cellPrev
    self._cellNextCached = self._cellNext
    self._flowTypeCached = self._flowType
    
end

function CellBase.destroyCache(self)
    if(self._isPurchased)then
        return
    end
    
    self._cellPrevCached = nil
    self._cellNextCached = nil
    self._flowTypeCached = nil
    
end

function CellBase.canRestoreState(self)
    local cellNextFlowTypeIsNone    = self._cellNext ~= nil and (self._cellNext:flowType() == EFlowType.EFT_NONE)
    local cellNextIsNil             = self._cellNext == nil
    
    return (cellNextFlowTypeIsNone or cellNextIsNil) and not self._isPurchased
end

function CellBase.restoreState(self)
    
    if (self._isPurchased)then
        return false
    end
    
    local result = true
    
    self._cellPrev = self._cellPrevCached 
    self._cellNext = self._cellNextCached 
    self._flowType = self._flowTypeCached
    
    self._controller:update(EControllerUpdate.ECUT_INCLUSION_IN_LINE)
    
    result = self:canRestoreState()
    
    if not result then
        
        self._cellNext = nil
        
    end
    
    return result
end

function CellBase.cellPrevCached(self)
    return self._cellPrevCached
end

function CellBase.cellNextCached(self)
    return self._cellNextCached
end

function CellBase.flowTypeCached(self)
    return self._flowTypeCached
end

