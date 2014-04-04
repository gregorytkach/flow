require('game_flow.src.views.editor.ViewUIEditor')


ControllerUIEditor = classWithSuper(Controller, 'ControllerUIEditor')

--
--Events
--

function ControllerUIEditor.onViewClicked(self, target, event)
    
    if (self._view:buttonShuffle() == target) then
                    
        self._managerGame:shuffle(self._managerGame:gridCreator():rowsCount() * 100)
        self._currentState:update(EControllerUpdate.ECUT_EDIT)
        
    elseif(self._view:buttonSend() == target)then
        
        GameInfo:instance():managerRemote():update()
        
    elseif (self._view:buttonFlowTypeAdd() == target) then
        
        if self._managerGame:onAddFlow(1) then
            self._view:labelFlowType():sourceView():setText("Flow type: "..tostring(self._managerGame:gridCreator():flowCount()))
            self._currentState:update(EControllerUpdate.ECUT_EDIT)
            self._view:buttonFlowTypeAdd():setIsEnabled(self._managerGame:gridCreator():flowCount() ~= tonumber(EFlowType.EFT_COUNT))
        end
        
    elseif (self._view:buttonFlowTypeRemove() == target) then
        
        if self._managerGame:onAddFlow(-1) then
            self._view:labelFlowType():sourceView():setText("Flow type: "..tostring(self._managerGame:gridCreator():flowCount()))
            self._currentState:update(EControllerUpdate.ECUT_EDIT)
            self._view:buttonFlowTypeRemove():setIsEnabled(self._managerGame:gridCreator():flowCount() ~= 1)
        end
    
    elseif (self._view:buttonSizeAdd() == target) then
        
        if self._managerGame:onAddSize(1) then
            self._view:labelSize():sourceView():setText("Size: "..tostring(self._managerGame:gridCreator():rowsCount()), EFontType.EFT_0)
            self._currentState:update(EControllerUpdate.ECUT_EDIT)
            self._view:buttonSizeAdd():setIsEnabled(self._managerGame:gridCreator():rowsCount() ~= Constants.MAX_GRID_SIZE)
        end
        
    elseif (self._view:buttonSizeRemove() == target) then
        
        if self._managerGame:onAddSize(-1) then
            self._view:labelSize():sourceView():setText("Size: "..tostring(self._managerGame:gridCreator():rowsCount()), EFontType.EFT_0)
            self._currentState:update(EControllerUpdate.ECUT_EDIT)
            self._view:buttonSizeRemove():setIsEnabled(self._managerGame:gridCreator():rowsCount() ~= Constants.MIN_GRID_SIZE)
        end
    
    elseif (self._view:buttonBridgeAdd() == target) then
        
        if self._managerGame:onAddBridge(1) then
            self._view:labelBridge():sourceView():setText("Bridges: "..tostring(self._managerGame:gridCreator():bridgesCount()), EFontType.EFT_0)
            self._currentState:update(EControllerUpdate.ECUT_EDIT)
            self._view:buttonBridgeAdd():setIsEnabled(self._managerGame:gridCreator():bridgesCount() ~= Constants.MAX_COUNT_BRIDGES)
        end
        
    elseif (self._view:buttonBridgeRemove() == target) then
        
        if self._managerGame:onAddBridge(-1) then
            self._view:labelBridge():sourceView():setText("Bridges: "..tostring(self._managerGame:gridCreator():bridgesCount()), EFontType.EFT_0)
            self._currentState:update(EControllerUpdate.ECUT_EDIT)
            self._view:buttonBridgeRemove():setIsEnabled(self._managerGame:gridCreator():bridgesCount() ~= 0)
            
        end
        
    elseif (self._view:buttonBarrierAdd() == target) then
        
        if self._managerGame:onAddBarrier(1) then
            self._view:labelBarrier():sourceView():setText("Barriers: "..tostring(self._managerGame:gridCreator():barriersCount()), EFontType.EFT_0)
            self._currentState:update(EControllerUpdate.ECUT_EDIT)
            self._view:buttonBarrierAdd():setIsEnabled(self._managerGame:gridCreator():barriersCount() ~= Constants.MAX_COUNT_BARRIERS)
        end
        
    elseif (self._view:buttonBarrierRemove() == target) then
        
        if self._managerGame:onAddBarrier(-1) then
            self._view:labelBarrier():sourceView():setText("Barriers: "..tostring(self._managerGame:gridCreator():barriersCount()), EFontType.EFT_0)
            self._currentState:update(EControllerUpdate.ECUT_EDIT)
            self._view:buttonBarrierRemove():setIsEnabled(self._managerGame:gridCreator():barriersCount() ~= 0)
        end
        
    else
        
        assert(false)
        
    end
    
    
end


--
--Methods
--

function ControllerUIEditor.init(self)
    
    local paramsView =
    {
        controller = self
    }
    
    local paramsController =
    {
        view = ViewUIEditor:new(paramsView)
    }
    
    Controller.init(self, paramsController)
    
    self._managerGame    = GameInfo:instance():managerGame()
    self._currentState = GameInfo:instance():managerStates():currentState()
    
end



function ControllerUIEditor.cleanup(self)
    
    self._view:cleanup()
    self._view = nil
    
    Controller.cleanup(self)
end

