ControllerCellEmpty = classWithSuper(ControllerCell, 'ControllerCellEmpty')

--
--Methods
--

function ControllerCellEmpty.init(self, params)
    ControllerCell.init(self, params)
end

function ControllerCellEmpty.canSelectTarget(self, target)
    local result = ControllerCell.canSelectTarget(self, target)
    
    if(result)then
        result = self._entry:cellPrev() ~= nil
    end
    
    return result
end

function ControllerCellEmpty.onTrySelect(self, target)
    assert(target ~= nil)
    assert(self._entry:cellPrev() ~= nil)
    
    if(self._entry:cellNext() ~= nil)then
        self._managerGame:destroyLine(self._entry)
    end
    
    
    if(target:cellPrev() ~= nil)then
        
        if(target:flowType() == self._entry:flowType())then
            self._managerGame:destroyLine(target)
        else
            self._managerGame:destroyLine(target:cellPrev())
            
            self:buildLine(self._entry, target)
        end
        
    else
        if(target:type() == ECellType.ECT_FLOW_POINT)then
            
            if(target:flowType() == self._entry:flowType()) then --and target ~= self._entry:cellPrev()
                
                if(target:cellNext() ~=  nil)then
                    self._managerGame:destroyLine(target)
                else
                    self:buildLine(self._entry, target)
                end
                
            end
            
        else
            self:buildLine(self._entry, target)
        end
    end
    
end