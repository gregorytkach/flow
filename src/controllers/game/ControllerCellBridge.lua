require('game_flow.src.views.game.cells.ViewCellBridge')

ControllerCellBridge = classWithSuper(ControllerCell, 'ControllerCellBridge')

--
-- Properties
--


--
--Events
--

function ControllerCellBridge.canSelectTarget(self, target)
    local result = false
    
    local flowTypeAdditional = EFlowType.EFT_NONE
    
    local flowType = self._entry:flowType()
    
    if self._entry:flowAdditional() ~= nil then
        
        flowTypeAdditional = self._entry:flowAdditional():flowType()
    end
    
    local currentLineFlowType = self._managerGame:currentLineFlowType()
    
    local isTargetHorizontal            = (target == self._entry:neighborLeft()  or target == self._entry:neighborRight()) and flowTypeAdditional ~= EFlowType.EFT_NONE
    local isTargetVertical              = (target == self._entry:neighborUp()    or target == self._entry:neighborDown()) and flowType ~= EFlowType.EFT_NONE
    
    local isTargetBarrier               = target:type() == ECellType.ECT_BARRIER
    local currentLineIsEmpty            = currentLineFlowType == nil
    local currentLineIsSameMain         = flowType == currentLineFlowType 
    local currentLineIsSameAdditional   = self._entry:flowAdditional() ~= nil and flowTypeAdditional == currentLineFlowType
    
    result = (not isTargetBarrier) and (currentLineIsEmpty or currentLineIsSameMain or currentLineIsSameAdditional) and (isTargetHorizontal or isTargetVertical)
    
    return result
end
--
--Methods
--

function ControllerCellBridge.init(self, params)
    ControllerCell.init(self, params)
    
     self._entry:flowAdditional():setController(self)
end

function ControllerCellBridge.createView(self)
    local result = nil 
    
    local paramsView = 
    {
        controller   = self,
        isPair       = self._isPair
    }
    
    result = ViewCellBridge:new(paramsView)
    
    return result
end

function ControllerCellBridge.onTrySelect(self, target)
    
    assert(target ~= nil)
    
    local entry = self._entry
    
    if target == self._entry:neighborRight() or target == self._entry:neighborLeft() then
        
        entry = entry:flowAdditional()
        
    end
    
    assert(entry:cellPrev() ~= nil)
    
    if(entry:cellNext() ~= nil)then
        
        self._managerGame:destroyLine(entry)
        
    end
    
    
    if(target:cellPrev() ~= nil)then
        
        if(target:flowType() == entry:flowType())then
            
            self._managerGame:destroyLine(target)
            
        else
            
            self._managerGame:destroyLine(target:cellPrev())
            self:tryBuildLine(entry, target)
            
        end
        
    else
        if(target:type() == ECellType.ECT_FLOW_POINT)then
            
            if(target:flowType() == entry:flowType()) then --and target ~= self._entry:cellPrev()
                
                if(target:cellNext() ~=  nil)then
                    
                    self._managerGame:destroyLine(target)
                    
                else
                    
                    self:tryBuildLine(entry, target)
                    
                end
                
            end
            
        else
            
            self:tryBuildLine(entry, target)
            
        end
    end
    
end


function ControllerCellBridge.update(self, updateType)
    
    if(updateType == EControllerUpdateBase.ECUT_SCENE_ENTER)then
        
        ControllerCell.update(self, updateType)
    
    elseif(updateType == EControllerUpdate.ECUT_CELL_NEXT)then
        
        ControllerCell.update(self, updateType)
        
    elseif(updateType == EControllerUpdate.ECUT_INCLUSION_IN_LINE)then
        
        self._view:setPath(self._entry:flowType())
        
        local flowAdditional = self._entry:flowAdditional()
        
        if flowAdditional ~= nil then
            
            self._view:setPathAbove(flowAdditional:flowType())
            
        end
        
       
    elseif(updateType == EControllerUpdate.ECUT_EXCLUSION_FROM_LINE)then
        
        
        self._view:setPath(self._entry:flowType())
        self._view:setPathAbove(self._entry:flowAdditional():flowType())
        
    elseif(updateType == EControllerUpdate.ECUT_DOG_DOWN) or (updateType == EControllerUpdate.ECUT_DOG_UP)then
        
        ControllerCell.update(self, updateType)
        
    end
    
end

function ControllerCellBridge.cleanup(self)
    ControllerCell.cleanup(self)
end

