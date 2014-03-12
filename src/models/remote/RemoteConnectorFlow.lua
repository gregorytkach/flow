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

function RemoteConnectorFlow.cleanup(self)
    RemoteConnector.cleanup(self)
end

