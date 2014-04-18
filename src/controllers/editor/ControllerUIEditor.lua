require('game_flow.src.views.editor.ViewUIEditor')


ControllerUIEditor = classWithSuper(Controller, 'ControllerUIEditor')

--
--Events
--

function ControllerUIEditor.onViewClicked(self, target, event)
    
    if (self._view:buttonShuffle() == target) then
        
        local rowsCount = self._managerGame:gridCreator():rowsCount()
        
        self._managerGame:shuffle(rowsCount * 100)
        self._currentState:update(EControllerUpdate.ECUT_EDIT)
        
    elseif(self._view:buttonSend() == target)then
        
        local json = require('json')
        
        local dataLines = self._managerGame:getDataLines()
        
        local dataLinesStr =  json.encode(dataLines)
        print(dataLinesStr)
        
        local dataGrid    = self._managerGame:getDataGrid()
        local dataGridStr = json.encode(dataGrid)
        print(dataGridStr)
        
        local data = 
        {
            data_grid               = dataGrid,
            data_lines              = dataLines,
            reward_currency_soft    = 50,
            reward_scores           = 50,
            time_left               = 120
        }
        
        GameInfo:instance():managerRemote():update(ERemoteUpdateType.ERUT_SAVE_GENERATED_LEVEL, data)
        
    elseif (self._view:buttonFlowTypeAdd() == target) then
        
        self:tryUpdateFlowCount(self._managerGame:flowCount() + 1)
        
    elseif (self._view:buttonFlowTypeRemove() == target) then
        
        self:tryUpdateFlowCount(self._managerGame:flowCount() - 1)
        
    elseif (self._view:buttonSizeAdd() == target) then
        
        self:tryUpdateGridSize(self._managerGame:gridSize() + 1)
        
    elseif (self._view:buttonSizeRemove() == target) then
        
        self:tryUpdateGridSize(self._managerGame:gridSize() - 1)
        
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

function ControllerUIEditor.tryUpdateFlowCount(self, value)
    
    if(value > tonumber(EFlowType.EFT_COUNT) or value < 1)then
        return
    end
    
    self._managerGame:setFlowCount(value)
    
    self._view:labelFlowType():sourceView():setText("Flow type: "..tostring(self._managerGame:gridCreator():flowCount()))
    self._currentState:update(EControllerUpdate.ECUT_EDIT)
    
    self._view:buttonFlowTypeAdd():setIsEnabled(value ~= tonumber(EFlowType.EFT_COUNT))
    self._view:buttonFlowTypeRemove():setIsEnabled(value ~= 1)
    
end

function ControllerUIEditor.tryUpdateGridSize(self, value)
    
    if value > Constants.MAX_GRID_SIZE or value < Constants.MIN_GRID_SIZE then
        return 
    end
    
    self._view:labelSize():sourceView():setText("Size: "..tostring(self._managerGame:gridSize()), EFontType.EFT_0)
    self._currentState:update(EControllerUpdate.ECUT_EDIT)
    
    self._view:buttonSizeRemove():setIsEnabled(value ~= Constants.MIN_GRID_SIZE)
    self._view:buttonSizeAdd():setIsEnabled(value    ~= Constants.MAX_GRID_SIZE)
    
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

