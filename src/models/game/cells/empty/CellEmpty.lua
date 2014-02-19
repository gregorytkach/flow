
CellEmpty = classWithSuper(CellBase, 'CellEmpty')

--
--Properties
--

function CellEmpty.type(self)
    return ECellType.ECT_EMPTY
end

--
--Events
--

--
--Methods
--

function CellEmpty.init(self, params)
    CellBase.init(self, params)
    
end


