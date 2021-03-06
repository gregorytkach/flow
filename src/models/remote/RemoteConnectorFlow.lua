RemoteConnectorFlow = classWithSuper(RemoteConnector, 'RemoteConnectorFlow')

--
-- Properties
--

function RemoteConnectorFlow.getSubController(self)
    return '/flow_mobile/index.php?r='
end

--
-- Methods
--

function RemoteConnectorFlow.init(self, params)
    RemoteConnector.init(self, params)
    
end

function RemoteConnectorFlow.getController(self, type)
    local result = ''
    
    if(type == ERemoteUpdateType.ERUT_SAVE_GENERATED_LEVEL)then
        result = "level/save"
        
    else
        result = RemoteConnector.getController(self, type)
    end
    
    return result
    
end

function RemoteConnectorFlow.cleanup(self)
    RemoteConnector.cleanup(self)
end

