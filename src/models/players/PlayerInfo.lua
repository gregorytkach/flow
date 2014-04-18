
PlayerInfo = classWithSuper(PlayerInfoBase, 'PlayerInfo')

--
-- Properties
--

function PlayerInfo.freeBonusSpins(self)
    return self._freeBonusSpins
end

function PlayerInfo.setFreeBonusSpins(self, value)
    if(self._freeBonusSpins == value)then
        return  
    end
    
    self._freeBonusSpins = value
    
    self:trySaveProgress()
    
    self:tryUpdateCurrentState(EControllerUpdate.ECUT_FREE_BONUS_SPINS)
end


function PlayerInfo.setEnergy(self, value)
    if(self._energy == value) then
        return
    end
    
    PlayerInfoBase.setEnergy(self, value)
    
    local managerBonusEnergy =  GameInfoBase:instance():managerBonusEnergy()
    
    if(managerBonusEnergy ~= nil)then
        managerBonusEnergy:onEnergyChanged()
    end
    
end

function PlayerInfo.freePurchaseAddTime(self)
    return self._freePurchaseAddTime
end


function PlayerInfo.setFreePurchaseAddTime(self, value)
    if(self._freePurchaseAddTime == value)then
        return  
    end
    
    self._freePurchaseAddTime = value
    
    self:trySaveProgress()
    
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
    
    self:trySaveProgress()
    
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
    
    self:trySaveProgress()
    
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

function PlayerInfo.serialize(self)
    local result = PlayerInfoBase.serialize(self)
    
    result.free_purchase_count_add_time     = self._freePurchaseAddTime
    result.free_purchase_count_resolve      = self._freePurchaseResolve
    result.free_purchase_count_show_turn    = self._freePurchaseShowTurn
    result.free_bonus_spins                 = self._freeBonusSpins
    
    return result
end


function PlayerInfo.deserialize(self, data)
    PlayerInfoBase.deserialize(self, data)
    
    self._freePurchaseAddTime   = tonumber(assertProperty(data, 'free_purchase_count_add_time'))
    self._freePurchaseResolve   = tonumber(assertProperty(data, 'free_purchase_count_resolve'))
    self._freePurchaseShowTurn  = tonumber(assertProperty(data, 'free_purchase_count_show_turn'))
    self._freeBonusSpins        = tonumber(assertProperty(data, 'free_bonus_spins'))
    
end
