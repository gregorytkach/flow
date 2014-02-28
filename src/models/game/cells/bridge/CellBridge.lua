
CellBridge = classWithSuper(CellBase, 'CellBridge')

--
--Properties
--


function CellBridge.type(self)
    return ECellType.ECT_BRIDGE
end


--use only for bridges
function CellBridge.flowAdditional(self)
    return self._flowAdditional
end


--
--Events
--

--
--Methods
--

function CellBridge.init(self, params)
    
    CellBase.init(self, params)
    
    if not (params.needIgnoreFlowAdditional)then
        
        params.needIgnoreFlowAdditional = true
        
        params.flow_type = EFlowType.EFT_NONE
        
        self._flowAdditional = CellBridge:new(params)
        
    end
    
end


function CellBridge.cleanup(self, params)
    
    if(self._flowAdditional ~= nil)then
        self._flowAdditional:cleanup()
        self._flowAdditional = nil
    end
    
    CellBase.cleanup(self)
end
