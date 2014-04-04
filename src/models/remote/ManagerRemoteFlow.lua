require('game_flow.src.models.remote.ERemoteUpdateType')

ManagerRemoteFlow = classWithSuper(ManagerRemoteBase, 'ManagerRemoteFlow')

--
-- Properties
--

--
-- Methods
--

function ManagerRemoteFlow.init(self, params)
    ManagerRemoteBase.init(self, params)
    
    assert(params.manager_cache ~= nil, 'Please init manager cache first')
    
    self._managerCache = params.manager_cache
    
end

function ManagerRemoteFlow.cleanup(self)
    Object.cleanup(self)
end

function ManagerRemoteFlow.update(self, type, data, callback)
    
    --todo remove after debug
    self._isConnectionEstablished = true
    
    if(self._isConnectionEstablished)then
        
        local callbackWrapper = function (response)
            
            if(response:status() == EResponseType.ERT_OK)then
                if(type == ERemoteUpdateTypeBase.ERUT_GAME_START)then
                    self._managerCache:update(type, response:response(), callback)
                    
                elseif(type == ERemoteUpdateType.ERUT_SAVE_GENERATED_LEVEL)then
                    
                    self:onGeneratedLevelSave(data, callback)
                    
                else
                    self._managerCache:update(type, data, callback)
                    
                end
                
            else
                
                self._managerCache:update(type, data, callback)
                
                --                callback(response)
            end
            
        end
        
        ManagerRemoteBase.update(self, type, data, callbackWrapper)
        
    else
        
        --just update cache
        self._managerCache:update(type, data, callback)
        
    end
    
end


function ManagerRemoteFlow.onGeneratedLevelSave(self, data, callback)
    
end
