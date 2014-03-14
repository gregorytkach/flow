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
    
    local cellPrev = target:cellPrev()
    if(cellPrev ~= nil)then
        
        if(target:flowType() == self._entry:flowType())then
            self._managerGame:destroyLine(target)
        else
            
            
            self._managerGame:destroyLine(cellPrev)
            
            self:tryOutHouse(cellPrev)
            
            self:tryBuildLine(self._entry, target)
        end
        
    else
        if(target:type() == ECellType.ECT_FLOW_POINT)then
            
            if(target:flowType() == self._entry:flowType()) then
                
                if(target:cellNext() ~=  nil)then
                    self._managerGame:destroyLine(target)
                else
                    self:tryBuildLine(self._entry, target)
                    self._managerGame:tryValidate()
                end
                
            end
            
        else
            
            self:tryBuildLine(self._entry, target)
            
        end
    end
    
end

function ControllerCellEmpty.cleanup(self)
    ControllerCell.cleanup(self)
end
