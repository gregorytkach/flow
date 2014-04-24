ManagerPurchasesFlow = classWithSuper(ManagerPurchasesBase, 'ManagerPurchasesFlow')

--
-- Properties
--

--
-- Events
--

function ManagerPurchasesFlow.onTryPurchase(self, purchaseItem, onComplete, onError)
    local playerCurrent = GameInfo:instance():managerPlayers():playerCurrent()
    
    if(purchaseItem:type() == EPurchaseType.EPT_RESOLVE and playerCurrent:freePurchaseResolve() > 0)then
        
        playerCurrent:setFreePurchaseResolve(playerCurrent:freePurchaseResolve() - 1)
        
        onComplete()
        
    elseif(purchaseItem:type() == EPurchaseType.EPT_SHOW_TURN and playerCurrent:freePurchaseShowTurn() > 0)then
        
        playerCurrent:setFreePurchaseShowTurn(playerCurrent:freePurchaseShowTurn() - 1)
        
        onComplete()
        
    elseif(purchaseItem:type() == EPurchaseType.EPT_ADD_TIME and playerCurrent:freePurchaseAddTime() > 0)then
        
        playerCurrent:setFreePurchaseAddTime(playerCurrent:freePurchaseAddTime() - 1)
        
        onComplete()
        
    else
        ManagerPurchasesBase.onTryPurchase(self, purchaseItem, onComplete, onError)
    end
end

--
-- Methods
--

function ManagerPurchasesFlow.init(self)
    ManagerPurchasesBase.init(self)
end

function ManagerPurchasesFlow.cleanup(self)
    Object.cleanup(self)
end

