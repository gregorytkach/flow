StateMap = classWithSuper(StateBase, 'StateMap')

require('game_flow.src.controllers.map.ControllerStateMap')
require('game_flow.src.controllers.map.ControllerUIMap')

--
--Properties
--
function StateMap.getType(self)
    return  EStateType.EST_MAP
end

--
--Events
--

--
-- Methods
--

--Default initializer
function StateMap.init(self)
    StateBase.init(self)
end

function StateMap.prepareToExit(self)
    
    self._blockerScene.alpha = 0.01
    
    local callback = function()
        self._blockerScene.alpha = 0
        
        GameInfoBase:instance():managerStates():onStateGone()
    end
    
    self._controllerStateMap:itemsHide(callback)
    
end

function StateMap.createScene(self, event)
    
    StateBase.createScene(self, event)
end

function StateMap.initLayerScene(self)
    StateBase.initLayerScene(self)
    
    self._controllerStateMap = ControllerStateMap:new()
    self._layerScene:insert(self._controllerStateMap:view():sourceView())
end

function StateMap.initLayerUI(self)
    StateBase.initLayerUI(self)
    
    self._controllerUIMap = ControllerUIMap:new()
    self._layerScene:insert(self._controllerUIMap:view():sourceView())
    
    --        self._layerUI.fill.effect = "filter.blur"
end

function StateMap.initLayerPopups(self)
    StateBase.initLayerPopups(self)
    
    self:registerPopup(ControllerPopupBonus:new())
    self:registerPopup(ControllerPopupShop:new())
    self:registerPopup(ControllerPopupNoEnergy:new())
end

function StateMap.update(self, updateType)
    
    if(updateType == EControllerUpdateBase.ECUT_SCENE_ENTER)then
        
        self._controllerStateMap:itemsShow()
        
    elseif(updateType == EControllerUpdateBase.ECUT_SCENE_EXIT)then
        
        
        
    elseif(updateType == EControllerUpdateBase.ECUT_PLAYER_ENERGY)then
        
        self._controllerUIMap:update(updateType)
        
    elseif(updateType == EControllerUpdateBase.ECUT_PLAYER_CURERNCY)then
        
        self._controllerUIMap:update(updateType)
        
    elseif( updateType == EControllerUpdate.ECUT_FREE_PURCHASE_SHOW_TURN or
        updateType == EControllerUpdate.ECUT_FREE_PURCHASE_ADD_TIME or
        updateType == EControllerUpdate.ECUT_FREE_PURCHASE_RESOLVE)then
        
        --do nothing
        
    else
        assert(false, updateType)
    end
    
end

function StateMap.placeViews(self)
    StateBase.placeViews(self)
    
    self._controllerStateMap:view():placeViews()
    self._controllerUIMap:view():placeViews()
    
    --todo: remove 
--    self:showPopup(EPopupType.EPT_NO_ENERGY)
end

function StateMap.cleanup(self)
    
    self._controllerStateMap:cleanup()
    self._controllerStateMap = nil
    
    self._controllerUIMap:cleanup()
    self._controllerUIMap = nil
    
    StateBase.cleanup(self)
end
