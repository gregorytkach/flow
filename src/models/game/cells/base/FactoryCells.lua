FactoryCells = classWithSuper(Object, 'FactoryCells')

function FactoryCells.getCell(params)
    local result
    
    assert(params   ~= nil)
    if(params.type == nil)then
        print(1)
    end
    
    assert(params.type  ~= nil)
    
    if(params.type == ECellType.ECT_EMPTY)then
        
        result = CellEmpty:new(params)
        
    elseif(params.type == ECellType.ECT_BRIDGE)then
        
        result = CellBridge:new(params)   
        
    elseif(params.type == ECellType.ECT_FLOW_POINT)then
        
        result = CellFlowPoint:new(params)   
        
    elseif(params.type == ECellType.ECT_BARRIER)then
        
        result = CellBarrier:new(params)   
        
    else
        assert(false)
    end
    
    return result
end
--
--Methods
--

function FactoryCells.init(self)
    assert(false)
end

