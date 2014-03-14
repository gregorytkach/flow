StateGame = classWithSuper(StateBase, 'StateGame')

require('game_flow.src.controllers.game.ControllerGrid')
require('game_flow.src.controllers.game.ControllerUI')

--
--Properties
--
function StateGame.getType(self)
    return  EStateType.EST_GAME
end

function StateGame.controllerGrid(self)
    return self._controllerGrid
end

--
--Events
--

--
-- Methods
--

--Default initializer
function StateGame.init(self)
    StateBase.init(self)
    
    assert(GameInfo:instance():managerGame() ~= nil)
    self._managerGame = GameInfo:instance():managerGame()
    self._managerGame:registerCurrentState(self)
end

function StateGame.initLayerScene(self)
    StateBase.initLayerScene(self)
    
    local bgParams =
    {
        image       = GameInfo:instance():managerResources():getStateBackground(self:getType()),
        scale   = EScaleType.EST_FILL_HEIGHT,
        controller  = self,
    }
    
    self._background = ViewSprite:new(bgParams)
    self._layerScene:insert(self._background:sourceView())
    
    self._controllerGrid = ControllerGrid:new()
    self._layerScene:insert(self._controllerGrid:view():sourceView())
end

function StateGame.initLayerUI(self)
    StateBase.initLayerUI(self)
    
    self._controllerUI = ControllerUI:new()
    self._layerUI:insert(self._controllerUI:view():sourceView())
end

function StateGame.initLayerPopups(self)
    StateBase.initLayerPopups(self)
    
    self:registerPopup(ControllerPopupShop:new())
    self:registerPopup(ControllerPopupWin:new())
    self:registerPopup(ControllerPopupGameOver:new())
    self:registerPopup(ControllerPopupNoCurrency:new())
    
end

function StateGame.update(self, updateType)
    
    if(updateType == EControllerUpdateBase.ECUT_SCENE_ENTER)then
        self._controllerGrid:update(updateType)
    elseif(updateType == EControllerUpdateBase.ECUT_SCENE_EXIT)then
        
    elseif(updateType == EControllerUpdate.ECUT_GAME_TIME)then
        self._controllerUI:update(updateType)
        
    elseif(updateType == EControllerUpdateBase.ECUT_PLAYER_CURERNCY)then
        self._controllerUI:update(updateType)
        
    elseif(updateType == EControllerUpdateBase.ECUT_PLAYER_ENERGY)then
        --do nothing
        
    elseif(updateType == EControllerUpdate.ECUT_SET_CURRENT_CELL)then
        
        self._controllerGrid:update(updateType)
        
    elseif(updateType == EControllerUpdate.ECUT_SET_DOGS) then
        
        self._controllerGrid:update(updateType)
        
    elseif(updateType == EControllerUpdate.ECUT_FREE_PURCHASE_ADD_TIME or
        updateType == EControllerUpdate.ECUT_FREE_PURCHASE_SHOW_TURN or
        updateType == EControllerUpdate.ECUT_FREE_PURCHASE_RESOLVE)then
        
        self._controllerUI:update(updateType)
        
    elseif(updateType == EControllerUpdate.ECUT_CURRENT_DOG) then
        
       self._controllerGrid:update(updateType) 
        
    elseif(updateType == EControllerUpdateBase.ECUT_GAME_FINISHED)then
        
        self._blockerScene.alpha = 0.01
        
        timer.performWithDelay(application.animation_duration * 4 * 2, 
        function() 
            if(self._managerGame:isPlayerWin()) then
                self:showPopup(EPopupType.EPT_WIN)
            else
                self:showPopup(EPopupType.EPT_GAME_OVER)
            end
        end,1)
        
    else
        assert(false, updateType)
    end
    
end

function StateGame.showPopup(self, popupType, callback)
    self._managerGame:timerStop()
    
    StateBase.showPopup(self, popupType, callback)
end

function StateGame.hidePopup(self, callback)
    
    local callbackWrapper = 
    function()
        
        self._managerGame:timerStart()
        
        if(callback ~= nil)then
            callback()
        end
    end
    
    StateBase.hidePopup(self, callbackWrapper)
end


function StateGame.placeViews(self)
    StateBase.placeViews(self)
    
    
    
    self._background:sourceView().x = display.contentCenterX
    self._background:sourceView().y = display.contentCenterY
    
    self._controllerGrid:view():placeViews()
    self._controllerGrid:view():sourceView().x = display.contentCenterX
    self._controllerGrid:view():sourceView().y = display.contentCenterY
    
    self._controllerUI:view():placeViews()
    
    --todo: remove
    --        self:showPopup(EPopupType.EPT_NO_CURRENCY)
end

function StateGame.cleanup(self)
    
    self._background:cleanup()
    self._background = nil
    
    self._controllerGrid:cleanup()
    self._controllerGrid = nil
    
    self._controllerUI:cleanup()
    self._controllerUI = nil
    
    StateBase.cleanup(self)
end
