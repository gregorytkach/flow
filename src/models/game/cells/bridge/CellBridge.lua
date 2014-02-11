
CellBridge = classWithSuper(CellBase, 'Cell')

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

function CellBridge.setFlowAdditional(self, value)
    assert(value ~= nil)
    
    self._flowAdditional = value
end

--
--Events
--

--
--Methods
--

function CellBridge.init(self, params)
    CellBase.init(self, params)
end


