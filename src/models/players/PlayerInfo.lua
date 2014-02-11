
PlayerInfo = classWithSuper(PlayerInfoBase, 'PlayerInfo')

--
-- Properties
--

function PlayerInfo.freePurchaseAddTime(self)
    return self._freePurchaseAddTime
end


function PlayerInfo.setFreePurchaseAddTime(self, value)
    if(self._freePurchaseAddTime == value)then
        return  
    end
    
    self._freePurchaseAddTime = value
    
    self:tryUpdateCurrentState(EControllerUpdate.ECUT_FREE_PURCHASE_ADD_TIME)
end

function PlayerInfo.freePurchaseResolve(self)
    return self._freePurchaseResolve
end

function PlayerInfo.setFreePurchaseResolve(self, value)
    if(self._freePurchaseResolve == value)then
        return  
    end
    
    self._freePurchaseResolve = value
    
    self:tryUpdateCurrentState(EControllerUpdate.ECUT_FREE_PURCHASE_RESOLVE)
end

function PlayerInfo.freePurchaseShowTurn(self)
    return self._freePurchaseShowTurn
end

function PlayerInfo.setFreePurchaseShowTurn(self, value)
    if(self._freePurchaseShowTurn == value)then
        return  
    end
    
    self._freePurchaseShowTurn = value
    
    self:tryUpdateCurrentState(EControllerUpdate.ECUT_FREE_PURCHASE_SHOW_TURN)
end

function PlayerInfo.tryUpdateCurrentState(self, updateType)
    local currentState = GameInfo:instance():managerStates():currentState()
    
    if(currentState ~= nil)then
        currentState:update(updateType)
    end
end


--
-- Methods
--

function PlayerInfo.init(self)
    PlayerInfoBase.init(self)
    
end


function PlayerInfo.deserialize(self, data)
    PlayerInfoBase.deserialize(self, data)
    
    assert(data.free_purchase_count_add_time    ~= nil)
    assert(data.free_purchase_count_resolve     ~= nil)
    assert(data.free_purchase_count_show_turn   ~= nil)
    
    self._freePurchaseAddTime   = data.free_purchase_count_add_time
    self._freePurchaseResolve   = data.free_purchase_count_resolve
    self._freePurchaseShowTurn  = data.free_purchase_count_show_turn
    
end
