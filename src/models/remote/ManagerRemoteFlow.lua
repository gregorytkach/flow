ManagerRemoteFlow = classWithSuper(ManagerRemoteBase, 'ManagerRemoteFlow')

--
-- Properties
--

--
-- Methods
--

function ManagerRemoteFlow.init(self, params)
    ManagerRemoteBase.init(self, params)
    
    assert(params.managerCache ~= nil, 'Please init manager cache first')
    
    self._managerCache = params.managerCache
    
end

function ManagerRemoteFlow.cleanup(self)
    Object.cleanup(self)
end

function ManagerRemoteFlow.update(self, type, data, callback)
    
    --todo remove after debug
    self._isConnectionEstablished = false
    
    if(self._isConnectionEstablished)then
        
        local callbackWrapper = function (response)
            if(type == ERemoteUpdateTypeBase.ERUT_GAME_START)then
                --todo: check version and if version is different - remove local data and resave
            end
            
            self._managerCache:update(type, data, callback)
        end
        
        ManagerRemoteBase.update(self, type, data, callbackWrapper)
        
    else
        
        --just update cache
        self._managerCache:update(type, data, callback)
        
    end
    
end