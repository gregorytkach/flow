StateEditor = classWithSuper(StateBase, 'StateEditor')

require('game_flow.src.controllers.editor.ControllerGridEditor')


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
    
    
end

function StateEditor.update(self, updateType)
    
    if(updateType == EControllerUpdateBase.ECUT_SCENE_ENTER)then
        self._controllerGrid:update(EControllerUpdate.ECUT_EDIT)
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
    
    self._controllerGrid:view():placeViews()
    self._controllerGrid:view():sourceView().x = display.contentCenterX
    self._controllerGrid:view():sourceView().y = display.contentCenterY
end

function StateEditor.cleanup(self)
    
    GameInfo:instance():onGameEnd()
    
    self._background:cleanup()
    self._background = nil
    
    self._controllerGrid:cleanup()
    self._controllerGrid = nil
    
    StateBase.cleanup(self)
end
