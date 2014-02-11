
CellBarrier = classWithSuper(CellBase, 'CellBarrier')

--
--Properties
--

function CellBarrier.type(self)
    return ECellType.ECT_BARRIER
end

--
--Events
--

--
--Methods
--

function CellBarrier.init(self, params)
    CellBase.init(self, params)
end




