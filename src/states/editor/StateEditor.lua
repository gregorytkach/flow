StateEditor = classWithSuper(StateBase, 'StateEditor')

require('game_flow.src.controllers.game.ControllerGridEditor')


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
    
    self._managerGame = GameInfo:instance():managerGame()
    self._managerGame:registerCurrentState(self)
    
end

function StateEditor.initLayerScene(self)
    StateBase.initLayerScene(self)
    
    local bgParams =
    {
        image       = GameInfo:instance():managerResources():getStateBackground(self:getType()),
        scale   = EScaleType.EST_FILL_HEIGHT,
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

function StateEditor.initLayerPopups(self)
    StateBase.initLayerPopups(self)
    
--    self:registerPopup(ControllerPopupShop:new())
--    self:registerPopup(ControllerPopupWin:new())
--    self:registerPopup(ControllerPopupGameOver:new())
--    self:registerPopup(ControllerPopupNoCurrency:new())
    
end

function StateEditor.update(self, updateType)
    
    if(updateType == EControllerUpdateBase.ECUT_SCENE_ENTER)then
        self._controllerGrid:update(updateType)
    elseif(updateType == EControllerUpdateBase.ECUT_SCENE_EXIT)then
        
    else
        assert(false, updateType)
    end
    
end

function StateEditor.showPopup(self, popupType, callback)
    self._managerGame:timerStop()
    
    StateBase.showPopup(self, popupType, callback)
end

function StateEditor.hidePopup(self, callback)
    
    local callbackWrapper = 
    function()
        
        self._managerGame:timerStart()
        
        if(callback ~= nil)then
            callback()
        end
    end
    
    StateBase.hidePopup(self, callbackWrapper)
end


function StateEditor.placeViews(self)
    StateBase.placeViews(self)
    
    self._background:sourceView().x = display.contentCenterX
    self._background:sourceView().y = display.contentCenterY
    
    self._controllerGrid:view():placeViews()
    self._controllerGrid:view():sourceView().x = display.contentCenterX
    self._controllerGrid:view():sourceView().y = display.contentCenterY
    
    
    
    --todo: remove
    --        self:showPopup(EPopupType.EPT_NO_CURRENCY)
end

function StateEditor.cleanup(self)
    
    self._background:cleanup()
    self._background = nil
    
    self._controllerGrid:cleanup()
    self._controllerGrid = nil
    
    
    
    StateBase.cleanup(self)
end
