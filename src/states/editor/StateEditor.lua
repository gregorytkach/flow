StateEditor = classWithSuper(StateBase, 'StateEditor')

require('game_flow.src.controllers.editor.ControllerGridEditor')
require('game_flow.src.controllers.editor.ControllerUIEditor')


--
--Properties
--
function StateEditor.getType(self)
    return  EStateType.EST_EDITOR
end

--
--Events
--

--
-- Methods
--

--Default initializer
function StateEditor.init(self)
    StateBase.init(self)
    
    local managerGame = GameInfo:instance():managerGame()
    
    assert(managerGame ~= nil)
    
    self._managerGame = managerGame
    self._managerGame:registerCurrentState(self)
    
end

function StateEditor.initLayerScene(self)
    StateBase.initLayerScene(self)
    
    local bgParams =
    {
        image       = GameInfo:instance():managerResources():getStateBackground(self:getType()),
        scale       = EScaleType.EST_FILL_HEIGHT,
        controller  = self,
    }
    
    self._background = ViewSprite:new(bgParams)
    self._layerScene:insert(self._background:sourceView())
    
    self._controllerGrid = ControllerGridEditor:new()
    self._layerScene:insert(self._controllerGrid:view():sourceView())
    
    
end

function StateEditor.initLayerUI(self)
    StateBase.initLayerUI(self)
    self._controllerUI = ControllerUIEditor:new()
    self._layerUI:insert(self._controllerGrid:view():sourceView())
    
end

function StateEditor.update(self, updateType)
    
    if(updateType == EControllerUpdateBase.ECUT_SCENE_ENTER)then
        self._controllerGrid:update(EControllerUpdate.ECUT_EDIT)
    elseif(updateType == EControllerUpdate.ECUT_EDIT)then
        
--        self._controllerGrid:cleanup()
--        
--        self._managerGame:createGrid()
--        self._controllerGrid = ControllerGridEditor:new()
--        
--        
--        self._layerScene:insert(self._controllerGrid:view():sourceView())
    
        self._controllerGrid:removeCells()
        self._managerGame:createGrid()
        self._controllerGrid:createCells()
        
        self:placeViews()
        self._controllerGrid:update(updateType)
        
        
        
    elseif(updateType == EControllerUpdateBase.ECUT_SCENE_EXIT)then
    
    elseif(updateType == EControllerUpdateBase.ECUT_PLAYER_ENERGY)then
    
    else
        assert(false, updateType)
    end
    
end


function StateEditor.placeViews(self)
    StateBase.placeViews(self)
    
    self._background:sourceView().x = display.contentCenterX
    self._background:sourceView().y = display.contentCenterY
    
    local widthMax = (application.content.width - display.screenOriginX * 2) - 10
    self._scaleWidth = 1
    
    local realWidth = 0
    local cells = self._controllerGrid._cells
    
    for i, controllerCell in ipairs(cells[1])do
        realWidth = realWidth + controllerCell:view():realWidth()
    end
    
    realWidth = realWidth * 1.2
    
    if realWidth > widthMax then
        self._scaleWidth = widthMax / realWidth
--        self._controllerGrid:view():sourceView().xScale = self._controllerGrid:view():sourceView().xScale * self._scaleWidth
--        self._controllerGrid:view():sourceView().yScale = self._controllerGrid:view():sourceView().xScale 
    end
    
    
    
    for i, row in ipairs(cells)do
        for i, controllerCell in ipairs(row)do
            controllerCell:view():sourceView().xScale = controllerCell:view():sourceView().xScale * self._scaleWidth
            controllerCell:view():sourceView().yScale = controllerCell:view():sourceView().xScale 
        end
    end
    
    self._controllerGrid:view():placeViews()
    self._controllerUI:view():placeViews()
    
   
    
    self._controllerGrid:view():sourceView().x = display.contentCenterX
    self._controllerGrid:view():sourceView().y = display.contentCenterY
    
--    self._controllerUI:view():sourceView().x = display.contentCenterX
--    self._controllerUI:view():sourceView().y = display.contentCenterY
end

function StateEditor.cleanup(self)
    
    GameInfo:instance():onGameEnd()
    
    self._background:cleanup()
    self._background = nil
    
    self._controllerGrid:cleanup()
    self._controllerGrid = nil
    
    StateBase.cleanup(self)
end
